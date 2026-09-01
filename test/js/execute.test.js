'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { Executor, normalizeNamedPlaceholders } = require('../../server/js/execute');

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

test('query preserves write ResultSetHeader fields like oxmysql', async () => {
    const result = { affectedRows: 2, insertId: 17, warningStatus: 0 };
    const { executor } = harness([result]);
    assert.deepEqual(await executor.query('INSERT INTO test VALUES (?)', [1]), result);
});

test('rawExecute returns oxmysql raw result values and supports multiple bind sets', async () => {
    const { executor } = harness([
        [{ value: 1 }],
        [{ value: 2 }],
    ]);

    // mysql2 fields metadata is internal; oxmysql's rawExecute exposes only
    // the raw row/result values and flattens batch results.
    assert.deepEqual(await executor.rawExecute('SELECT ? AS value', [[1], [2]]), [
        [{ value: 1 }],
        [{ value: 2 }],
    ]);
});

test('mysql-async @name placeholders normalize without touching literals/comments', () => {
    const result = normalizeNamedPlaceholders(
        "SELECT '@literal', col FROM users WHERE id = @id AND tag = :tag -- @comment\nAND email = @email",
        { '@id': 7, ':tag': 'x', email: 'a@example.com' },
    );
    assert.equal(result.sql,
        "SELECT '@literal', col FROM users WHERE id = :id AND tag = :tag -- @comment\nAND email = :email");
    assert.equal(result.params.id, 7);
    assert.equal(result.params.tag, 'x');
    assert.equal(result.params.email, 'a@example.com');
});
