'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { Executor, normalizeNamedPlaceholders } = require('../../server/js/execute');

function harness(results) {
    const calls = [];
    const protocols = [];
    const touched = [];
    const pool = {
        execute: async (sql, params) => {
            calls.push([sql, params]);
            protocols.push('execute');
            return [results.shift(), []];
        },
        query: async (sql, params) => {
            calls.push([sql, params]);
            protocols.push('query');
            return [results.shift(), []];
        },
    };
    const statements = {
        isPreparable: () => true,
        recordHit: (sql) => touched.push(sql),
        recordMiss: (sql) => touched.push(sql),
        markUnpreparable: (sql) => touched.push(sql),
    };
    const stats = { record: () => {} };
    return { executor: new Executor({ read: pool, write: pool }, statements, stats), calls, protocols, touched, pool };
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

test('P1: parameter-less SQL uses the text protocol and never enters the statement cache', async () => {
    const { executor, protocols, touched, calls } = harness([[{ n: 1 }], [{ n: 2 }], [{ n: 3 }]]);
    await executor.query("SELECT * FROM players WHERE citizenid = 'ABC123'", []);
    await executor.query("SELECT * FROM players WHERE citizenid = 'DEF456'");
    await executor.query('SELECT * FROM players WHERE citizenid = ?', ['GHI789']);
    assert.deepEqual(protocols, ['query', 'query', 'execute']);
    assert.deepEqual(touched, ['SELECT * FROM players WHERE citizenid = ?'], 'one-shot texts must not evict cached marks');
    assert.deepEqual(calls[1], ["SELECT * FROM players WHERE citizenid = 'DEF456'", []]);
});

test('P1: the oxmysql view keeps prepared-path result casting on the text path', async () => {
    const { executor, pool } = harness([[{ n: 1 }]]);
    let options;
    pool.query = async (opts) => { options = opts; return [[{ n: 1 }], []]; };
    await executor.withOxTypeCast().query('SELECT NOW() AS n', []);
    assert.equal(options.sql, 'SELECT NOW() AS n');
    assert.equal(options.typeCast, require('../../server/js/typecast').typeCastExecute);
});

test('S6: read-pool statements carry the query timeout; write-pool statements never do', async () => {
    const seen = [];
    const read = {
        execute: async (...args) => { seen.push(['read', ...args]); return [[], []]; },
        query: async (...args) => { seen.push(['read', ...args]); return [[], []]; },
    };
    const write = {
        execute: async (...args) => { seen.push(['write', ...args]); return [{ affectedRows: 1 }, []]; },
        query: async (...args) => { seen.push(['write', ...args]); return [{ affectedRows: 1 }, []]; },
    };
    const executor = new Executor({ read, write }, { isPreparable: () => true, recordHit() {} }, { record() {} });
    executor.readTimeout = 1500;
    await executor.query('SELECT * FROM t WHERE id = ?', [1]);
    await executor.query('SELECT 1', []);
    await executor.update('UPDATE t SET v = ? WHERE id = ?', [1, 2]);
    assert.deepEqual(seen[0], ['read', { sql: 'SELECT * FROM t WHERE id = ?', values: [1], timeout: 1500 }]);
    assert.deepEqual(seen[1], ['read', { sql: 'SELECT 1', values: [], timeout: 1500 }]);
    assert.deepEqual(seen[2], ['write', 'UPDATE t SET v = ? WHERE id = ?', [1, 2]]);
});

test('oxmysql prepare returns every row of a multi-row SELECT, not only the first', async () => {
    const rows = [{ citizenid: 'CID1' }, { citizenid: 'CID2' }, { citizenid: 'CID3' }];
    const { executor } = harness([rows]);
    assert.deepEqual(await executor.prepare('SELECT citizenid FROM players WHERE job = ?', ['police']), rows);

    const empty = harness([[]]);
    assert.equal(await empty.executor.prepare('SELECT citizenid FROM players WHERE job = ?', ['none']), null);
});

test('L1: the executor text fallback JSON-encodes plain-object binds; Dates/Buffers/arrays are untouched', async () => {
    const { executor, calls, protocols } = harness([{ affectedRows: 1 }]);
    executor.statements.isPreparable = () => false;
    const when = new Date(0);
    const buf = Buffer.from('x');
    await executor.execute('UPDATE t SET meta = ?, at = ?, b = ? WHERE id IN (?)', [{ a: { b: 1 } }, when, buf, [1, 2]]);
    assert.deepEqual(protocols, ['query']);
    assert.deepEqual(calls[0][1], ['{"a":{"b":1}}', when, buf, [1, 2]]);
});

test('L1/H1: needsTextProtocol and textParams helpers', () => {
    const { needsTextProtocol, textParams } = require('../../server/js/execute');
    assert.equal(needsTextProtocol([1, 'a', null]), false);
    assert.equal(needsTextProtocol([[1, 2]]), true);
    assert.equal(needsTextProtocol([{ a: 1 }]), true);
    assert.equal(needsTextProtocol({ ids: [1] }), true);
    assert.equal(needsTextProtocol({ id: 1 }), false);
    assert.equal(needsTextProtocol([Buffer.from('x'), new Date()]), false);
    assert.deepEqual(textParams({ meta: { a: 1 }, id: 2 }), { meta: '{"a":1}', id: 2 });
});
