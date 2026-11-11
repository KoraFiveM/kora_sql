'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { WriteQueue, pkKey, comparePk, hasUniqueIndexOn, isRetryableWriteError } = require('../../server/js/queue.js');
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

function assertDropped(q, fn, re, msg) {
    const log = require('../../server/js/logger.js');
    const errors = [];
    const error = log.error;
    log.error = (_tag, m) => errors.push(m);
    q.warnedRejects.clear();
    let result;
    try {
        assert.doesNotThrow(() => { result = fn(); }, msg);
    } finally {
        log.error = error;
    }
    assert.ok(result && result.dropped >= 1, msg || 'row dropped');
    assert.ok(errors.some((m) => re.test(m)), `${msg || ''} expected a log matching ${re}: ${errors.join(' | ')}`);
    return result;
}

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

    assert.equal(executed.length, 1);
    assert.match(executed[0].sql, /`citizenid`,`job`,`money`/);
    assert.deepEqual(executed[0].params, ['ABC', 'j1', 'm2']);
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
    assert.deepEqual(executed[0].params, ['ABC', 15]);
    assert.match(executed[0].sql, /`dist` = `dist` \+ VALUES\(`dist`\)/);
});

test('coalesce ratio reflects rows-in vs rows-written', async () => {
    const { pools } = makeFakePools();
    const stats = new Stats(150, 50);
    const q = new WriteQueue(null, pools, stats, CFG);

    q.enqueueMany('players', 'citizenid', [
        { pk: 'ABC', cols: { money: 'a' } },
        { pk: 'ABC', cols: { money: 'b' } },
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

    assert.equal(executed.length, 1);
    assert.deepEqual(executed[0].params, ['ABC', 'm']);
});

test('queued upserts turn missing values and the public NULL sentinel into SQL NULL', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);

    q.enqueue('kora_multijob_jobs', 'citizenid', {
        pk: 'ABC',
        cols: { jobs: undefined, note: '\u0000kora_sql:null\u0000' },
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
                assert.equal(q.pending.get('players').rows.get(pkKey('BAD')).cols.money, remaining,
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

test('an idle table accepts new queue options; a table with pending rows still refuses them', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    q.enqueue('counters', 'id', { pk: 'a', cols: { n: 1 } }, { mode: 'assign' });
    assertDropped(q, () => q.enqueue('counters', 'id', { pk: 'a', cols: { n: 1 } }, { mode: 'accumulate' }), /incompatible queue options/);
    await q.flush();
    q.enqueue('counters', 'id', { pk: 'a', cols: { n: 2 } }, { mode: 'accumulate' });
    await q.flush();
    assert.equal(executed.length, 2);
    assert.match(executed[1].sql, /`n` = `n` \+ VALUES\(`n`\)/);
});

test('batched UPDATE chunks stay inside the placeholder budget for wide rows', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, maxPlaceholders: 100, padToBuckets: true });
    const cols = { a: 1, b: 2, c: 3, d: 4 };
    const rows = Array.from({ length: 30 }, (_, i) => ({ pk: `p${i}`, cols }));
    q.enqueueMany('players', 'citizenid', rows, { mode: 'assign', writeMode: 'update' });
    await q.flush();
    assert.ok(executed.length >= 3);
    for (const e of executed) assert.ok(e.params.length <= 100, `${e.params.length} placeholders`);
});

function deterministic(code) {
    const err = new Error(`simulated ${code}`);
    err.code = code;
    return err;
}

test('S3: composite keys that collided under the old \\x1f join stay distinct rows', async () => {
    assert.notEqual(pkKey(['a\x1fb', 'c']), pkKey(['a', 'b\x1fc']));
    assert.notEqual(pkKey(['a', 'b']), pkKey('a\x1fb'));
    assert.notEqual(pkKey(['a,b']), pkKey(['a', 'b']));

    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    q.enqueue('inventories', ['owner', 'label'], { pk: ['a\x1fb', 'c'], cols: { items: 'first' } });
    q.enqueue('inventories', ['owner', 'label'], { pk: ['a', 'b\x1fc'], cols: { items: 'second' } });
    await q.flush();
    assert.equal(executed.length, 1);
    assert.deepEqual(executed[0].params, ['a', 'b\x1fc', 'second', 'a\x1fb', 'c', 'first'],
        'each row keeps its own key and value (sorted by key)');
});

test('S3: object/null key components are refused instead of colliding as "[object Object]"', () => {
    const { pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: {}, cols: { money: 1 } }), /primary key values/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: null, cols: { money: 1 } }), /primary key values/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: NaN, cols: { money: 1 } }), /primary key values/);
    assertDropped(q, () => q.enqueue('t', ['a', 'b'], { pk: ['only-one'], cols: { v: 1 } }), /2 primary key value/);
    assert.equal(q.pendingRowCount, 0);
});

test('S3: a numeric key and its string spelling address the same row and still merge', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    q.enqueue('vehicles', 'id', { pk: 7, cols: { fuel: 10 } });
    q.enqueue('vehicles', 'id', { pk: '7', cols: { fuel: 20 } });
    await q.flush();
    assert.equal(executed.length, 1);
    assert.deepEqual(executed[0].params, [7, 20]);
});

test('S3: composite dead-letter keys are stored unambiguously', async (t) => {
    const { executed, pools } = makeFakePools({ failFirst: 6 });
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    q.enqueue('inventories', ['owner', 'label'], { pk: ['a\x1fb', 'c'], cols: { items: 'x' } });
    await assert.rejects(q.flush(), /failed after 5 retries/);
    const dead = executed.find(({ sql }) => /kora_sql_deadletter/.test(sql));
    assert.deepEqual(JSON.parse(dead.params[1]), ['a\x1fb', 'c']);
});

test('S4: accumulate mode sums numeric strings as numbers, never concatenates', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    q.enqueue('accounts', 'id', { pk: 'A', cols: { balance: '5' } }, { mode: 'accumulate' });
    q.enqueue('accounts', 'id', { pk: 'A', cols: { balance: '3' } }, { mode: 'accumulate' });
    q.enqueue('accounts', 'id', { pk: 'A', cols: { balance: 2.5 } }, { mode: 'accumulate' });
    await q.flush();
    assert.deepEqual(executed[0].params, ['A', 10.5], "'5' + '3' must be 8, not '53'");
    assert.equal(typeof executed[0].params[1], 'number');
});

test('S4: accumulate mode drops non-numeric values and queues nothing for them', () => {
    const { pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    for (const bad of ['x', '5x', '', ' ', '0x10', null, undefined, true, {}, [], NaN, Infinity, '1e999']) {
        assertDropped(q, () => q.enqueue('accounts', 'id', { pk: 'A', cols: { balance: bad } }, { mode: 'accumulate' }),
            /accumulate mode needs a finite number/, String(bad));
    }
    assert.equal(q.pendingRowCount, 0);
    assert.equal(q.pending.size, 0);
    assert.throws(() => q.enqueueMany('accounts', 'id', [
        { pk: 'A', cols: { balance: 1 } },
        { pk: 'B', cols: { balance: 'oops' } },
    ], { mode: 'accumulate', strict: true }), /accumulate mode/);
    assert.equal(q.pendingRowCount, 0);
});

test('S2: table, conflict key and column names must be plain identifiers', () => {
    const { pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    const row = { pk: 'A', cols: { money: 1 } };
    assertDropped(q, () => q.enqueue('players.money', 'citizenid', row), /invalid table name/);
    assertDropped(q, () => q.enqueue('players`; DROP TABLE x; --', 'citizenid', row), /invalid table name/);
    assertDropped(q, () => q.enqueue('players', 'citizen id', row), /invalid conflict key/);
    assertDropped(q, () => q.enqueue('players', [], row), /invalid conflict key/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: 'A', cols: { 'players.money': 1 } }), /invalid column name/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: 'A', cols: { 'a`b': 1 } }), /invalid column name/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: 'A', cols: { CitizenID: 'B' } }), /conflict key column/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: 'A', cols: {} }), /no columns/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: 'A' }), /must be \{ pk/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', row, { mode: 'sum' }), /unsupported mode/);
    assert.equal(q.pendingRowCount, 0);
});

test('S2: allowedColumns rejects mass-assigned columns from forwarded client data', () => {
    const { pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    const opts = { allowedColumns: ['settings', 'Metadata'] };
    q.enqueue('players', 'citizenid', { pk: 'A', cols: { settings: '{}', metadata: '{}' } }, opts);
    assertDropped(q, () => q.enqueue('players', 'citizenid', { pk: 'A', cols: { settings: '{}', money: 1e9 } }, opts),
        /players\.money is not in allowedColumns/);
    assert.equal(q.pending.get('players').rows.get(pkKey('A')).cols.money, undefined);
});

test('P5: rows are written in primary-key order, numerically for integer keys', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    q.enqueueMany('vehicles', 'id', [10, 9, '100', 2, 'B', 'A'].map((pk) => ({ pk, cols: { v: 1 } })));
    await q.flush();
    assert.deepEqual(executed[0].params.filter((_, i) => i % 2 === 0), [2, 9, 10, '100', 'A', 'B']);
    assert.ok(comparePk({ pk: ['a', 2] }, { pk: ['a', 10] }) < 0, 'composite keys compare componentwise');
});

test('P6: a deterministic error is not retried; the chunk is bisected so only the bad row dead-letters', async (t) => {
    const { executed, pools } = makeFakePools();
    let attempts = 0;
    const execute = pools.write.execute;
    pools.write.execute = async (sql, params) => {
        if (!/kora_sql_deadletter/.test(sql)) {
            attempts++;
            if (params.includes('TOO_LONG')) throw deterministic('ER_DATA_TOO_LONG');
        }
        return execute(sql, params);
    };
    const stats = new Stats(150, 50);
    const q = new WriteQueue(null, pools, stats, { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    const rows = ['A', 'B', 'C', 'D', 'E'].map((pk) => ({ pk, cols: { name: pk === 'C' ? 'TOO_LONG' : 'ok' } }));
    q.enqueueMany('players', 'citizenid', rows);
    const started = Date.now();
    await assert.rejects(q.flush(), /ER_DATA_TOO_LONG\); 1 row\(s\) were dead-lettered/);
    assert.ok(Date.now() - started < 500, 'no exponential backoff for a deterministic error');

    const written = executed.filter(({ sql }) => !/kora_sql_deadletter/.test(sql))
        .flatMap(({ params }) => params.filter((_, i) => i % 2 === 0));
    assert.deepEqual(written.sort(), ['A', 'B', 'D', 'E'], 'every healthy row is still written');
    const dead = executed.filter(({ sql }) => /kora_sql_deadletter/.test(sql));
    assert.equal(dead.length, 1);
    assert.equal(dead[0].params[1], 'C');
    assert.equal(stats.queue.deadLettered, 1);
    assert.equal(stats.queue.rowsWritten, 4);
    assert.ok(attempts <= 7, `bisection, not retries (${attempts} attempts)`);
    assert.equal(q.pendingRowCount, 0, 'nothing stale is left pending');
});

test('P6: transient errors keep the retry path; error classification', () => {
    assert.equal(isRetryableWriteError(deterministic('ER_LOCK_DEADLOCK')), true);
    assert.equal(isRetryableWriteError(deterministic('ER_LOCK_WAIT_TIMEOUT')), true);
    assert.equal(isRetryableWriteError(new Error('unknown')), true);
    assert.equal(isRetryableWriteError(Object.assign(deterministic('ER_BAD_FIELD_ERROR'), { fatal: true })), true);
    assert.equal(isRetryableWriteError(deterministic('ER_BAD_FIELD_ERROR')), false);
    assert.equal(isRetryableWriteError(deterministic('ER_BAD_NULL_ERROR')), false);
});

test('P6: a multi-row dead-letter is one INSERT', async () => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    await q._deadLetter('missing', [{ pk: 'A', cols: { v: 1 } }, { pk: ['x', 'y'], cols: { v: 2 } }], deterministic('ER_NO_SUCH_TABLE'));
    assert.equal(executed.length, 1);
    assert.match(executed[0].sql, /VALUES \(\?,\?,\?,\?,NOW\(\)\),\(\?,\?,\?,\?,NOW\(\)\)$/);
    assert.deepEqual(executed[0].params.filter((_, i) => i % 4 === 1), ['A', '["x","y"]']);
});

test('P7: a conflict key without a matching PRIMARY/UNIQUE index is reported once', async () => {
    const { pools } = makeFakePools();
    const queried = [];
    pools.read = { query: async (sql, params) => {
        queried.push(params[0]);
        if (params[0] === 'good') return [[{ INDEX_NAME: 'PRIMARY', COLUMN_NAME: 'id' }], []];
        return [[{ INDEX_NAME: 'uk_other', COLUMN_NAME: 'other' }], []];
    } };
    const log = require('../../server/js/logger.js');
    const warnings = [];
    const warn = log.warn;
    log.warn = (tag, msg) => warnings.push(msg);
    try {
        const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, verifyConflictKeys: true });
        q.enqueue('good', 'id', { pk: 1, cols: { v: 1 } });
        q.enqueue('bad', 'citizenid', { pk: 'A', cols: { v: 1 } });
        q.enqueue('bad', 'citizenid', { pk: 'B', cols: { v: 1 } });
        await nextTurn();
        await nextTurn();
        assert.deepEqual(queried, ['good', 'bad'], 'verified once per table and key');
        assert.equal(warnings.length, 1);
        assert.match(warnings[0], /conflict key \(citizenid\) on bad is not a PRIMARY or UNIQUE index/);
        await q.flush();
    } finally {
        log.warn = warn;
    }
    assert.equal(hasUniqueIndexOn([{ INDEX_NAME: 'uk', COLUMN_NAME: 'B' }, { INDEX_NAME: 'uk', COLUMN_NAME: 'a' }], ['a', 'b']), true);
    assert.equal(hasUniqueIndexOn([{ INDEX_NAME: 'uk', COLUMN_NAME: 'a' }], ['a', 'b']), true, 'a unique subset still catches duplicates');
    assert.equal(hasUniqueIndexOn([{ INDEX_NAME: 'uk', COLUMN_NAME: 'a' }, { INDEX_NAME: 'uk', COLUMN_NAME: 'c' }], ['a', 'b']), false, 'a wider unique index does not');
});

test('P3: the flush writes on the dedicated flush pool when one exists', async () => {
    const { pools } = makeFakePools();
    const flushed = [];
    pools.flush = { execute: async (sql, params) => { flushed.push(params); return [{ affectedRows: 1 }]; } };
    pools.write = { ...pools.write, execute: async () => assert.fail('the write pool must not carry the flush') };
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    q.enqueue('players', 'citizenid', { pk: 'A', cols: { money: 1 } });
    await q.flush();
    assert.deepEqual(flushed, [['A', 1]]);
});

test('P10: enqueueMany with immediate priority flushes once, not once per row', async (t) => {
    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    q.enqueueMany('players', 'citizenid', [1, 2, 3, 4].map((n) => ({ pk: `P${n}`, cols: { v: n } })), { priority: 'immediate' });
    await q.flush('players');
    assert.equal(executed.length, 1, 'one statement for the whole batch');
});

test('H2: one invalid row in enqueueMany drops only that row; the rest are queued and written', async () => {
    const { executed, pools } = makeFakePools();
    const log = require('../../server/js/logger.js');
    const errors = [];
    const error = log.error;
    log.error = (_tag, m) => errors.push(m);
    try {
        const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
        let result;
        assert.doesNotThrow(() => {
            result = q.enqueueMany('players', 'citizenid', [
                { pk: 'A', cols: { money: 1 } },
                { pk: null, cols: { money: 2 } },
                { pk: 'C', cols: { 'bad-name': 3 } },
                { pk: 'D', cols: { money: 4 } },
                { pk: undefined, cols: { money: 5 } },
            ], {}, 'kora_core');
        });
        assert.deepEqual(result, { queued: 2, dropped: 3 });
        q.enqueueMany('players', 'citizenid', [{ pk: null, cols: { money: 9 } }], {}, 'kora_core');
        assert.equal(errors.length, 2, `one log per (resource, reason): ${errors.join(' | ')}`);
        assert.ok(errors.every((m) => /kora_core/.test(m)), 'the log names the calling resource');
        await q.flush();
        assert.equal(executed.length, 1);
        assert.deepEqual(executed[0].params, ['A', 1, 'D', 4]);
    } finally {
        log.error = error;
    }
});

test('H2: a non-list rows argument or bad options never throw from enqueue/enqueueMany', () => {
    const { pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    assertDropped(q, () => q.enqueueMany('players', 'citizenid', 'nope'), /needs a list of rows/);
    assertDropped(q, () => q.enqueue('players', 'citizenid', null), /must be \{ pk/);
    assertDropped(q, () => q.enqueueMany('players', 'citizenid', [{ pk: 'A', cols: { v: 1 } }], { writeMode: 'x' }), /unsupported writeMode/);
    assert.equal(q.pendingRowCount, 0);
});

function failingPools(code, { failDeadLetter = false } = {}) {
    const fake = makeFakePools();
    let writes = 0;
    let deadLetterInserts = 0;
    const execute = fake.pools.write.execute;
    fake.pools.write.execute = async (sql, params) => {
        if (/kora_sql_deadletter/.test(sql)) {
            deadLetterInserts++;
            if (failDeadLetter) throw deterministic('ER_DATA_TOO_LONG');
        } else {
            writes++;
            throw deterministic(code);
        }
        return execute(sql, params);
    };
    return { ...fake, counts: () => ({ writes, deadLetterInserts }) };
}

test('M1: a statement-level error dead-letters the whole chunk at once, without bisecting', async (t) => {
    const { executed, pools, counts } = failingPools('ER_BAD_FIELD_ERROR');
    const stats = new Stats(150, 50);
    const q = new WriteQueue(null, pools, stats, { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    const log = require('../../server/js/logger.js');
    const errors = [];
    const error = log.error;
    log.error = (_tag, m) => errors.push(m);
    try {
        q.enqueueMany('players', 'citizenid', Array.from({ length: 64 }, (_, i) => ({ pk: `P${i}`, cols: { gone: i } })));
        await assert.rejects(q.flush(), /ER_BAD_FIELD_ERROR\); 64 row\(s\) were dead-lettered/);
    } finally {
        log.error = error;
    }
    assert.deepEqual(counts(), { writes: 1, deadLetterInserts: 1 }, 'one failing statement, one multi-row dead-letter insert');
    assert.equal(executed[0].params.length, 64 * 4);
    assert.equal(stats.queue.deadLettered, 64);
    assert.equal(errors.length, 1, 'one log line for the chunk');
    assert.equal(q.pendingRowCount, 0);
});

test('M1: ER_NO_SUCH_TABLE is retried a couple of times before it dead-letters', async (t) => {
    const { pools } = makeFakePools();
    let attempts = 0;
    const execute = pools.write.execute;
    pools.write.execute = async (sql, params) => {
        if (!/kora_sql_deadletter/.test(sql) && ++attempts <= 2) throw deterministic('ER_NO_SUCH_TABLE');
        return execute(sql, params);
    };
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    t.mock.timers.enable({ apis: ['setTimeout'] });
    q.enqueueMany('fresh_table', 'id', [{ pk: 1, cols: { v: 1 } }, { pk: 2, cols: { v: 2 } }]);
    const done = q.flush();
    for (let i = 0; i < 10 && attempts < 3; i++) {
        await nextTurn();
        t.mock.timers.tick(1000);
    }
    await done;
    assert.equal(attempts, 3, 'the table appeared during the retries and the write succeeded');
    assert.equal(q.pendingRowCount, 0);
});

test('M2: a row whose dead-letter insert keeps failing is retried a bounded number of times, then dropped with a full log', async (t) => {
    const { pools, counts } = failingPools('ER_DATA_TOO_LONG', { failDeadLetter: true });
    const q = new WriteQueue(null, pools, new Stats(150, 50), { ...CFG, flushInterval: 60000 });
    t.after(() => clearTimeout(q.timer));
    const log = require('../../server/js/logger.js');
    const errors = [];
    const error = log.error;
    const warn = log.warn;
    log.error = (_tag, m) => errors.push(m);
    log.warn = () => {};
    try {
        q.enqueue('players', 'citizenid', { pk: 'POISON', cols: { name: 'x'.repeat(300) } });
        for (let i = 0; i < 6; i++) await q.flush().catch(() => {});
    } finally {
        log.error = error;
        log.warn = warn;
    }
    assert.equal(counts().writes, 3, 'capped at 3 attempts, not one per flush forever');
    assert.equal(q.pendingRowCount, 0);
    assert.ok(errors.some((m) => /DROPPED players row POISON after 3 failed dead-letter attempts/.test(m) && /cols_json=\{"name":"x{300}"\}/.test(m)));
});

test('M2: dead-letter pk fits varchar(191) and BigInt keys/values do not throw', async () => {
    const { deadLetterPk } = require('../../server/js/queue.js');
    const long = deadLetterPk(['a'.repeat(150), 'b'.repeat(150)]);
    assert.equal(long.length, 191);
    assert.match(long, /~sha:[0-9a-f]{40}$/);
    assert.notEqual(long, deadLetterPk(['a'.repeat(150), 'b'.repeat(149) + 'c']), 'distinct keys stay distinct');
    assert.equal(deadLetterPk(12n), '12');
    assert.equal(deadLetterPk([1, 2n]), '["1","2"]');
    assert.equal(deadLetterPk('plain'), 'plain');

    const { executed, pools } = makeFakePools();
    const q = new WriteQueue(null, pools, new Stats(150, 50), CFG);
    const failed = await q._deadLetter('t', [{ pk: 9007199254740993n, cols: { big: 9007199254740993n } }], deterministic('ER_DUP_ENTRY'));
    assert.deepEqual(failed, []);
    assert.equal(executed[0].params[1], '9007199254740993');
    assert.equal(executed[0].params[2], '{"big":"9007199254740993"}');
});
