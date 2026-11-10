'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { withAcquireTimeout, sessionTimeoutSql } = require('../../server/js/pool.js');

function fakePool() {
    const waiting = [];
    const released = [];
    const pool = {
        released,
        waiting,
        getConnection() {
            return new Promise((resolve) => waiting.push(resolve));
        },
        end: async () => {},
        on: () => {},
    };
    const conn = (id) => ({
        id,
        execute: async (sql, params) => [{ id, sql, params }],
        query: async (sql, params) => [{ id, sql, params }],
        release: () => released.push(id),
    });
    return { pool, conn };
}

test('S6: a call waiting for a busy pool fails after the acquire timeout', async (t) => {
    t.mock.timers.enable({ apis: ['setTimeout'] });
    const { pool, conn } = fakePool();
    const wrapped = withAcquireTimeout(pool, 1000, 'read');
    const pending = wrapped.query('SELECT 1', []);
    t.mock.timers.tick(999);
    await Promise.resolve();
    t.mock.timers.tick(1);
    await assert.rejects(pending, (err) => err.code === 'KORA_SQL_ACQUIRE_TIMEOUT' && /within 1000ms/.test(err.message));

    pool.waiting.shift()(conn('late'));
    await Promise.resolve();
    assert.deepEqual(pool.released, ['late']);
});

test('S6: a connection obtained in time runs the statement and is released', async () => {
    const { pool, conn } = fakePool();
    const wrapped = withAcquireTimeout(pool, 1000, 'write');
    const pending = wrapped.execute('UPDATE t SET v = ?', [1]);
    pool.waiting.shift()(conn('c1'));
    const [result] = await pending;
    assert.deepEqual(result, { id: 'c1', sql: 'UPDATE t SET v = ?', params: [1] });
    assert.deepEqual(pool.released, ['c1']);
});

test('S6: acquire timeout 0 leaves the pool untouched', () => {
    const { pool } = fakePool();
    assert.equal(withAcquireTimeout(pool, 0, 'read'), pool);
});

test('S6: read connections get a server-side limit in the right dialect', () => {
    assert.equal(sessionTimeoutSql({ _isMariaDB: false }, 30000), 'SET SESSION max_execution_time = 30000');
    assert.equal(sessionTimeoutSql({ _isMariaDB: true }, 30000), 'SET SESSION max_statement_time = 30.000');
});

test('M4: an unknown session variable retries once with the other dialect', () => {
    const { limitReadStatements } = require('../../server/js/pool.js');
    let onConnection;
    limitReadStatements({ on: (_ev, fn) => { onConnection = fn; } }, 30000);
    const sent = [];
    const conn = {
        _isMariaDB: false,
        query(sql, cb) {
            sent.push(sql);
            if (/max_execution_time/.test(sql)) cb(Object.assign(new Error('Unknown system variable'), { code: 'ER_UNKNOWN_SYSTEM_VARIABLE', errno: 1193 }));
            else cb(null);
        },
    };
    onConnection(conn);
    assert.deepEqual(sent, ['SET SESSION max_execution_time = 30000', 'SET SESSION max_statement_time = 30.000']);
    assert.equal(sessionTimeoutSql({ _handshakePacket: { serverVersion: '5.5.5-10.11.6-MariaDB' } }, 1000), 'SET SESSION max_statement_time = 1.000');
});
