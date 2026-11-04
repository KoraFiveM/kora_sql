// Write-queue behaviour, exercised against a FAKE pool that records the SQL and
// params it is asked to execute -- no database. This pins the coalescing
// contract: merge by PK, group by signature at flush, last-write-wins per
// column, and mid-flush enqueues landing in the next generation.

'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { WriteQueue } = require('../../server/js/queue.js');
const { Stats } = require('../../server/js/stats.js');

function makeFakePools(opts) {
    opts = opts || {};
    const executed = [];
    let calls = 0;
    const pool = {
        async execute(sql, params) {
            calls++;
            if (opts.failDeadLetter && /kora_sql_deadletter/.test(sql)) {
                throw new Error('simulated dead-letter failure');
            }
            if (opts.failFirst && calls <= opts.failFirst) {
                if (opts.onFailure) opts.onFailure(calls);
                const e = new Error('simulated write failure');
                throw e;
            }
            executed.push({ sql, params });
            return [{ affectedRows: 1 }];
        },
        async getConnection() { throw new Error('not used'); },
        async query() { return [[]]; },
    };
    return {
        executed,
        pools: { read: pool, write: pool, version: { isMariaDB: true, major: 10, minor: 11, patch: 14 } },
    };
}

const CFG = {
    flushInterval: 250, maxPendingRows: 500, maxRowsPerStatement: 200,
    maxPlaceholders: 60000, padToBuckets: false,
};

function deferred() {
    let resolve;
    const promise = new Promise((done) => { resolve = done; });
    return { promise, resolve };
}

const nextTurn = () => new Promise((resolve) => setImmediate(resolve));

test('flush waits for active and covered pending writes without chasing later enqueues', async (t) => {
    const { pools } = makeFakePools();
    const started = [deferred(), deferred(), deferred()];
    const release = [deferred(), deferred(), deferred()];
    const written = [];
    pools.write.execute = async (sql, params) => {
        const index = written.length;
        written.push(params[0]);
        started[index].resolve();
        await release[index].promise;
        return [{ affectedRows: 1 }];
    };
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => { release.forEach((gate) => gate.resolve()); clearTimeout(q.timer); });
    q.enqueue('players', 'citizenid', { pk: 'A', cols: { money: 1 } });
    const first = q.flush('players');
    await started[0].promise;
    let emptyDone = false;
    const empty = q.flush('players').then(() => { emptyDone = true; });
    q.enqueue('players', 'citizenid', { pk: 'B', cols: { money: 2 } });
    let coveredDone = 0;
    const covered = [q.flush('players'), q.flush('players')].map((p) => p.then(() => { coveredDone++; }));
    await nextTurn();
    assert.equal(emptyDone, false, 'an empty pending map does not mean the active write finished');
    assert.equal(coveredDone, 0);
    release[0].resolve();
    await Promise.all([first, empty, started[1].promise]);
    assert.equal(coveredDone, 0, 'all callers covering B must await its write');
    assert.deepEqual(written, ['A', 'B']);
    q.enqueue('players', 'citizenid', { pk: 'C', cols: { money: 3 } });
    release[1].resolve();
    await Promise.all(covered);
    assert.deepEqual(written, ['A', 'B'], 'C arrived after the captured target');
    assert.equal(q.pendingRowCount, 1);
    const last = q.flush('players');
    await started[2].promise;
    release[2].resolve();
    await last;
    assert.deepEqual(written, ['A', 'B', 'C']);
    assert.equal(q.pendingRowCount, 0);
});

test('flush publishes its active write before a provider re-enters immediate enqueue', async (t) => {
    const { pools } = makeFakePools();
    const release = deferred();
    const started = deferred();
    const written = [];
    let active = 0;
    let maxActive = 0;
    pools.write.execute = async (sql, params) => {
        active++;
        maxActive = Math.max(maxActive, active);
        written.push(params[0]);
        if (params[0] === 'A') {
            q.enqueue('players', 'citizenid', { pk: 'B', cols: { money: 2 } }, { priority: 'immediate' });
            started.resolve();
            await release.promise;
        }
        active--;
        return [{ affectedRows: 1 }];
    };
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => { release.resolve(); clearTimeout(q.timer); });
    q.enqueue('players', 'citizenid', { pk: 'A', cols: { money: 1 } }, { priority: 'immediate' });
    await started.promise;
    const completion = q.flush('players');
    await nextTurn();
    assert.deepEqual(written, ['A']);
    release.resolve();
    await completion;
    assert.equal(maxActive, 1, 'same-table writes must never overlap');
    assert.deepEqual(written, ['A', 'B']);
});

test('flush checks completed generations when another writer starts before its waiter resumes', async (t) => {
    const { pools } = makeFakePools();
    const started = [deferred(), deferred()];
    const release = [deferred(), deferred()];
    let calls = 0;
    pools.write.execute = async () => {
        const index = calls++;
        started[index].resolve();
        await release[index].promise;
        return [{ affectedRows: 1 }];
    };
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => { release.forEach((gate) => gate.resolve()); clearTimeout(q.timer); });
    q.enqueue('players', 'citizenid', { pk: 'A', cols: { money: 1 } });
    const st = q.pending.get('players');
    let inFlight = null;
    let reentered;
    let injected = false;
    Object.defineProperty(st, 'inFlight', {
        get: () => inFlight,
        set: (value) => {
            inFlight = value;
            if (value === null && !injected) {
                injected = true;
                // A caller may start B after cleanup, before A's waiters resume.
                queueMicrotask(() => { reentered = q.flush('players'); });
            }
        },
    });
    const first = q.flush('players');
    await started[0].promise;
    q.enqueue('players', 'citizenid', { pk: 'B', cols: { money: 2 } });
    let settled = false;
    const watched = q.flush('players').then(() => { settled = true; });
    release[0].resolve();
    await started[1].promise;
    await nextTurn();
    assert.equal(settled, false, 'starting B does not mean the covered generation completed');
    release[1].resolve();
    await Promise.all([first, watched, reentered]);
    assert.equal(calls, 2);
});

test('failed active flush rearms the timer for immediate pending writes', async (t) => {
    const { executed, pools } = makeFakePools({
        failFirst: 6,
        onFailure: (calls) => {
            if (calls === 1) q.enqueue('players', 'citizenid', { pk: 'B', cols: { money: 2 } }, { priority: 'immediate' });
        },
    });
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    q.enqueue('players', 'citizenid', { pk: 'A', cols: { money: 1 } }, { priority: 'immediate' });
    await assert.rejects(q.flush('players'), /failed after 5 retries/);
    assert.ok(q.timer, 'failed immediate writes must not strand the pending generation');
    assert.equal(q.pendingRowCount, 1);
    await q.flush('players');
    assert.deepEqual(executed.filter(({ sql }) => !/kora_sql_deadletter/.test(sql)).map(({ params }) => params), [['B', 2]]);
});

test('flush waits for every selected table before reporting the first write failure', async (t) => {
    const { pools } = makeFakePools({ failFirst: 6 });
    const execute = pools.write.execute;
    const healthyStarted = deferred();
    const deadLettered = deferred();
    const release = deferred();
    pools.write.execute = async (sql, params) => {
        if (/`healthy`/.test(sql)) {
            healthyStarted.resolve();
            await release.promise;
            return [{ affectedRows: 1 }];
        }
        const result = await execute(sql, params);
        if (/kora_sql_deadletter/.test(sql)) deadLettered.resolve();
        return result;
    };
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => { release.resolve(); clearTimeout(q.timer); });
    q.enqueue('failed', 'id', { pk: 'A', cols: { money: 1 } });
    q.enqueue('healthy', 'id', { pk: 'B', cols: { money: 2 } });
    let settled = false;
    const result = q.flush().then(() => { settled = true; }, (err) => { settled = true; return err; });
    await Promise.all([healthyStarted.promise, deadLettered.promise]);
    await nextTurn();
    assert.equal(settled, false, 'a failed table must not bypass another active write');
    release.resolve();
    assert.match((await result).message, /write to failed failed after 5 retries/);
    assert.equal(q.pendingRowCount, 0);
});

test('same PK enqueued twice merges to one row with per-column last-write-wins', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);

    q.enqueue('players', 'citizenid', { pk: 'ABC', cols: { money: 'm1' } }, {});
    q.enqueue('players', 'citizenid', { pk: 'ABC', cols: { money: 'm2', job: 'j1' } }, {});
    await q.flush();

    // One statement (one signature: money,job), one row.
    assert.equal(executed.length, 1);
    // Columns are sorted in the signature: job, money.
    assert.match(executed[0].sql, /`citizenid`,`job`,`money`/);
    assert.deepEqual(executed[0].params, ['ABC', 'j1', 'm2']);   // m2 wins over m1
});

test('differing column sets produce distinct signatures = distinct statements', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);

    q.enqueue('players', 'citizenid', { pk: 'ABC', cols: { money: 'm' } }, {});
    q.enqueue('players', 'citizenid', { pk: 'DEF', cols: { money: 'm', position: 'p' } }, {});
    await q.flush();

    assert.equal(executed.length, 2, 'two signatures -> two statements');
    const single = executed.find((e) => !/position/.test(e.sql));
    const dual = executed.find((e) => /position/.test(e.sql));
    assert.deepEqual(single.params, ['ABC', 'm']);
    assert.deepEqual(dual.params, ['DEF', 'm', 'p']);
});

test('accumulate mode sums overlapping columns before flush', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);

    q.enqueue('player_stats', 'citizenid', { pk: 'ABC', cols: { dist: 10 } }, { mode: 'accumulate' });
    q.enqueue('player_stats', 'citizenid', { pk: 'ABC', cols: { dist: 5 } }, { mode: 'accumulate' });
    await q.flush();

    assert.equal(executed.length, 1);
    assert.deepEqual(executed[0].params, ['ABC', 15]);   // summed in-memory
    assert.match(executed[0].sql, /`dist` = `dist` \+ VALUES\(`dist`\)/);
});

test('coalesce ratio reflects rows-in vs rows-written', async () => {
    const { pools } = makeFakePools();
    const stats = new Stats(150, 50);
    const q = new WriteQueue(null, pools, stats, CFG);

    q.enqueueMany('players', 'citizenid', [
        { pk: 'ABC', cols: { money: 'a' } },
        { pk: 'ABC', cols: { money: 'b' } },   // same PK -> coalesced
        { pk: 'DEF', cols: { money: 'c' } },
    ], {});
    await q.flush();

    const s = stats.summary({});
    assert.equal(s.queue.boundaryCrossings, 1, 'one enqueueMany = one crossing');
    assert.equal(s.queue.rowsEnqueued, 2, 'two distinct rows survived the merge');
    assert.equal(s.queue.rowsWritten, 2);
});

test('a transient write failure requeues and eventually succeeds', async () => {
    const { executed, pools } = makeFakePools({ failFirst: 1 });
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);

    q.enqueue('players', 'citizenid', { pk: 'ABC', cols: { money: 'm' } }, {});
    await q.flush();

    // First attempt failed, retry succeeded -> exactly one successful write.
    assert.equal(executed.length, 1);
    assert.deepEqual(executed[0].params, ['ABC', 'm']);
});

test('queued upserts turn missing values and the public NULL sentinel into SQL NULL', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);

    q.enqueue('kora_multijob_jobs', 'citizenid', {
        pk: 'ABC',
        cols: { jobs: undefined, note: '\u0000qbsql:null\u0000' },
    }, {});
    await q.flush();

    assert.deepEqual(executed[0].params, ['ABC', null, null]);
});

test('a terminal write failure is dead-lettered and rejects the flush', async () => {
    const { executed, pools } = makeFakePools({ failFirst: 6 });
    const stats = new Stats(150, 50);
    const q = new WriteQueue(null, pools, stats, CFG);

    q.enqueue('players', 'citizenid', { pk: 'ABC', cols: { money: 'm' } }, {});
    await assert.rejects(() => q.flush(), /failed after 5 retries/);

    assert.equal(executed.length, 1, 'only the dead-letter insert should succeed');
    assert.match(executed[0].sql, /kora_sql_deadletter/);
    assert.equal(stats.summary({}).queue.deadLettered, 1);
    assert.equal(q.depth().players.rows, 0, 'the stale retry hedge must not remain queued after dead-lettering');
});

for (const mode of ['assign', 'accumulate']) {
    for (const writeMode of ['upsert', 'update']) {
        for (const failDeadLetter of [false, true]) {
            test(`failed ${mode}/${writeMode} chunk preserves later rows and newer writes (dead-letter failure: ${failDeadLetter})`, async (t) => {
                const options = { mode, writeMode };
                const { executed, pools } = makeFakePools({
                    failFirst: 6,
                    failDeadLetter,
                    onFailure: (calls) => {
                        if (calls === 2) q.enqueue('players', 'citizenid', { pk: 'BAD', cols: { money: 99 } }, options);
                    },
                });
                const stats = new Stats(150, 50);
                const q = new WriteQueue(null, pools, stats, {
                    ...CFG, flushInterval: 60000, maxRowsPerStatement: 1,
                });
                t.after(() => clearTimeout(q.timer));
                q.enqueueMany('players', 'citizenid', [
                    { pk: 'BAD', cols: { money: 10 } },
                    { pk: 'GOOD', cols: { money: 20 } },
                    { pk: 'OTHER_SIGNATURE', cols: { money: 30, distance: 4 } },
                ], options);
                await assert.rejects(q.flush('players'), failDeadLetter ? /failed to dead-letter/ : /failed after 5 retries/);

                const writes = () => executed.filter(({ sql }) => !/kora_sql_deadletter/.test(sql));
                assert.deepEqual(writes().map(({ params }) => params[0]), ['GOOD', 'OTHER_SIGNATURE'],
                    'later chunks and column groups must still be written');
                assert.equal(stats.queue.rowsWritten, 2, 'count only successful writes');
                assert.equal(stats.queue.statementsIssued, 2);
                assert.equal(stats.queue.deadLettered, failDeadLetter ? 0 : 1);
                const recovery = executed.filter(({ sql }) => /kora_sql_deadletter/.test(sql));
                if (!failDeadLetter) {
                    assert.equal(recovery.length, 1);
                    assert.equal(recovery[0].params[1], 'BAD');
                    assert.deepEqual(JSON.parse(recovery[0].params[2]), { money: 10 });
                }

                const remaining = failDeadLetter && mode === 'accumulate' ? 109 : 99;
                assert.equal(q.pending.get('players').rows.get('BAD').cols.money, remaining,
                    'retain the new assignment or delta without replaying a dead-lettered increment');
                assert.equal(q.pendingRowCount, 1);
                await q.flush('players');
                assert.equal(writes().length, 3, 'healthy rows must not be resent in the next flush');
                assert.equal(writes()[2].params[0], 'BAD');
                assert.equal(writes()[2].params[1], remaining);
                assert.equal(q.pendingRowCount, 0);
                assert.equal(q.depth().players.rows, 0);
            });
        }
    }
}
