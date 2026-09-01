'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { Executor } = require('../../server/js/execute');

function harness(results) {
    const calls = [];
    const pool = {
        execute: async (sql, params) => {
            calls.push([sql, params]);
            return [results.shift(), []];
        },
    };
    const statements = {
        isPreparable: () => true,
        recordHit: () => {},
        markUnpreparable: () => {},
    };
    const stats = { record: () => {} };
    return { executor: new Executor({ read: pool, write: pool }, statements, stats), calls };
}

test('oxmysql prepare executes every supplied parameter set', async () => {
    const { executor, calls } = harness([{ affectedRows: 1 }, { affectedRows: 2 }]);
    const result = await executor.prepare('UPDATE players SET name = ? WHERE citizenid = ?', [
        ['A', 'CID1'],
        ['B', 'CID2'],
    ], 'consumer');

    assert.deepEqual(result, [1, 2]);
    assert.deepEqual(calls.map((call) => call[1]), [['A', 'CID1'], ['B', 'CID2']]);
});

test('oxmysql prepare unpacks one-column and one-row SELECT responses', async () => {
    const scalar = harness([[{ count: 4 }]]);
    assert.equal(await scalar.executor.prepare('SELECT COUNT(*) AS count FROM players', []), 4);

    const single = harness([[{ citizenid: 'CID1', name: 'A' }]]);
    assert.deepEqual(
        await single.executor.prepare('SELECT citizenid, name FROM players WHERE citizenid = ?', ['CID1']),
        { citizenid: 'CID1', name: 'A' }
    );
});
