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
            if (opts.failDeadLetter && /qbsql_deadletter/.test(sql)) {
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

    q.enqueue('qbmultijob_jobs', 'citizenid', {
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
    assert.match(executed[0].sql, /qbsql_deadletter/);
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

                const writes = () => executed.filter(({ sql }) => !/qbsql_deadletter/.test(sql));
                assert.deepEqual(writes().map(({ params }) => params[0]), ['GOOD', 'OTHER_SIGNATURE'],
                    'later chunks and column groups must still be written');
                assert.equal(stats.queue.rowsWritten, 2, 'count only successful writes');
                assert.equal(stats.queue.statementsIssued, 2);
                assert.equal(stats.queue.deadLettered, failDeadLetter ? 0 : 1);
                const recovery = executed.filter(({ sql }) => /qbsql_deadletter/.test(sql));
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
