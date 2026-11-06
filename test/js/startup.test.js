'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { connectWithRetry, isTransientConnectionError } = require('../../server/js/startup');

test('startup retries a timed-out database until it becomes reachable', async () => {
    let calls = 0;
    const waits = [];
    const retries = [];
    const expected = { read: {}, write: {} };

    const result = await connectWithRetry(async () => {
        calls++;
        if (calls < 3) {
            const err = new Error('connect ETIMEDOUT');
            err.code = 'ETIMEDOUT';
            throw err;
        }
        return expected;
    }, {}, {
        retryInterval: 25,
        delay: async (ms) => waits.push(ms),
        onRetry: (err, attempt) => retries.push([err.code, attempt]),
    });

    assert.equal(result, expected);
    assert.equal(calls, 3);
    assert.deepEqual(waits, [25, 25]);
    assert.deepEqual(retries, [['ETIMEDOUT', 1], ['ETIMEDOUT', 2]]);
});

test('startup does not hide authentication or configuration failures', async () => {
    let waits = 0;
    const err = new Error('Access denied');
    err.code = 'ER_ACCESS_DENIED_ERROR';

    await assert.rejects(
        connectWithRetry(async () => { throw err; }, {}, { delay: async () => { waits++; } }),
        err
    );
    assert.equal(waits, 0);
});

test('common network startup failures are classified as transient', () => {
    assert.equal(isTransientConnectionError({ code: 'ECONNREFUSED' }), true);
    assert.equal(isTransientConnectionError({ cause: { code: 'ETIMEDOUT' } }), true);
    assert.equal(isTransientConnectionError({ code: 'ER_BAD_DB_ERROR' }), false);
});

test('connection charset accepts a bare charset or a full collation name', () => {
    const { connectionCollation } = require('../../server/js/config');
    assert.equal(connectionCollation('utf8mb4'), 'utf8mb4_unicode_ci');
    assert.equal(connectionCollation(undefined), 'utf8mb4_unicode_ci');
    assert.equal(connectionCollation('utf8mb4_general_ci'), 'utf8mb4_general_ci');
    assert.equal(connectionCollation('utf8mb4_unicode_ci'), 'utf8mb4_unicode_ci');
});

test('the renamed statement cache convar still honours its qbsql_ spelling', () => {
    const cfgLoader = require('../../server/js/config');
    const load = (convars) => {
        globalThis.GetConvar = (name, def) => (name in convars ? convars[name] : def);
        try { return cfgLoader.load(); } finally { delete globalThis.GetConvar; }
    };
    const dsn = 'mysql://u:p@localhost/db?charset=utf8mb4';
    assert.equal(load({ mysql_connection_string: dsn }).statementCache, 256);
    assert.equal(load({ mysql_connection_string: dsn, qbsql_statement_cache: '128' }).statementCache, 128);
    assert.equal(load({ mysql_connection_string: dsn, qbsql_statement_cache: '128', kora_sql_statement_cache: '64' }).statementCache, 64);
    assert.equal(load({ mysql_connection_string: dsn }).defaultCollate, 'utf8mb4_unicode_ci');
});
