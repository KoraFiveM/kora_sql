// Connection-string parsing (REVIEW.md S1): TLS options are honoured and
// unknown options are reported rather than silently dropped.

'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const log = require('../../server/js/logger.js');
const { parseConnectionString } = require('../../server/js/config.js');

function captureWarnings(fn) {
    const warnings = [];
    const warn = log.warn;
    log.warn = (tag, msg) => warnings.push(msg);
    try { return { result: fn(), warnings }; } finally { log.warn = warn; }
}

test('S1: ?ssl= accepts oxmysql JSON and booleans', () => {
    const json = parseConnectionString('mysql://u:p@db.example.com/qb?ssl={"rejectUnauthorized":true,"ca":"PEM"}');
    assert.deepEqual(json.ssl, { rejectUnauthorized: true, ca: 'PEM' });
    assert.deepEqual(parseConnectionString('mysql://u:p@h/qb?ssl=true').ssl, {});
    assert.equal(parseConnectionString('mysql://u:p@h/qb?ssl=false').ssl, undefined);
    assert.equal(parseConnectionString('mysql://u:p@h/qb').ssl, undefined);
    assert.throws(() => parseConnectionString('mysql://u:p@h/qb?ssl={broken'), /ssl must be/);
});

test('S1: sslmode spellings map onto mysql2 ssl options', () => {
    assert.deepEqual(parseConnectionString('mysql://u:p@h/qb?sslmode=require').ssl, { rejectUnauthorized: false });
    assert.deepEqual(parseConnectionString('mysql://u:p@h/qb?sslmode=verify-full').ssl, { rejectUnauthorized: true });
    // mysql-async style semicolon strings often say SslMode=none: keep booting, unencrypted as before.
    const semicolon = parseConnectionString('server=127.0.0.1;database=es;userid=root;password=;SslMode=none');
    assert.equal(semicolon.ssl, undefined);
    assert.equal(semicolon.database, 'es');
    const { result, warnings } = captureWarnings(() => parseConnectionString('mysql://u:p@h/qb?sslmode=preferred'));
    assert.equal(result.ssl, undefined);
    assert.match(warnings[0], /NOT encrypted/);
    assert.throws(() => parseConnectionString('mysql://u:p@h/qb?sslmode=bogus'), /unsupported sslmode/);
});

test('S1: connectTimeout and charset are applied; other options warn instead of vanishing', () => {
    const { result, warnings } = captureWarnings(() =>
        parseConnectionString('mysql://u:p@h:3307/qb?charset=utf8mb4_general_ci&connectTimeout=5000&multipleStatements=true&waitForConnections=false'));
    assert.equal(result.charset, 'utf8mb4_general_ci');
    assert.equal(result.connectTimeout, 5000);
    assert.equal(result.port, 3307);
    assert.equal(warnings.length, 2);
    assert.match(warnings[0], /'multipleStatements' is not supported/);
    assert.match(warnings[1], /'waitForConnections' is not supported/);
});

test('S1: the semicolon form also reports unknown keys and accepts ssl', () => {
    const { result, warnings } = captureWarnings(() =>
        parseConnectionString('host=h;user=u;password=p;database=qb;ssl=true;pooling=true'));
    assert.deepEqual(result.ssl, {});
    assert.equal(warnings.length, 1);
    assert.match(warnings[0], /'pooling'/);
});

test('S1: ssl reaches the mysql2 pool options; plaintext stays the default', () => {
    const { poolOptions } = require('../../server/js/pool.js');
    const base = { statementCache: 16, poolQueueLimit: 10 };
    const tls = poolOptions({ ...base, connection: parseConnectionString('mysql://u:p@h/qb?ssl={"rejectUnauthorized":true}&connectTimeout=2500') }, 4);
    assert.deepEqual(tls.ssl, { rejectUnauthorized: true });
    assert.equal(tls.connectTimeout, 2500);
    assert.equal(tls.queueLimit, 10);
    const plain = poolOptions({ ...base, connection: parseConnectionString('mysql://u:p@h/qb') }, 4);
    assert.equal('ssl' in plain, false);
    assert.equal(plain.connectTimeout, 10000);
});
