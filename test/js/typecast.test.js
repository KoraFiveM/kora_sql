'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { typeCast, typeCastExecute } = require('../../server/js/typecast');
const { Executor } = require('../../server/js/execute');
const { register } = require('../../server/js/exports.js');

const NEXT = Symbol('next');
function field(type, { str = null, buf = null, length = 1, charset = 224 } = {}) {
    return { type, length, charset, string: () => str, buffer: () => buf };
}
const cast = (f) => typeCast(f, () => NEXT);

test('dates become ms timestamps; empty dates become null', () => {
    assert.equal(cast(field('DATETIME', { str: '2024-01-02 03:04:05' })), new Date('2024-01-02 03:04:05').getTime());
    assert.equal(cast(field('TIMESTAMP', { str: '2024-01-02 03:04:05' })), new Date('2024-01-02 03:04:05').getTime());
    assert.equal(cast(field('DATE', { str: '2024-01-02' })), new Date('2024-01-02 00:00:00').getTime());
    assert.equal(cast(field('DATETIME', { str: null })), null);
    assert.equal(cast(field('DATE', { str: '' })), null);
});

test('TINYINT(1) is boolean, other TINY widths fall through', () => {
    assert.equal(cast(field('TINY', { str: '1', length: 1 })), true);
    assert.equal(cast(field('TINY', { str: '0', length: 1 })), false);
    assert.equal(cast(field('TINY', { str: null, length: 1 })), null);
    assert.equal(cast(field('TINY', { str: '5', length: 4 })), NEXT);
});

test('BIT(1) is boolean, wider BIT is the first byte, null stays null', () => {
    assert.equal(cast(field('BIT', { buf: Buffer.from([1]) })), true);
    assert.equal(cast(field('BIT', { buf: Buffer.from([0]) })), false);
    assert.equal(cast(field('BIT', { buf: Buffer.from([7, 1]) })), 7);
    assert.equal(cast(field('BIT', { buf: null })), null);
});

test('binary BLOBs become byte arrays, text BLOBs strings', () => {
    assert.deepEqual(cast(field('BLOB', { buf: Buffer.from([1, 2, 3]), charset: 63 })), [1, 2, 3]);
    assert.deepEqual(cast(field('BLOB', { buf: null, charset: 63 })), [null]);
    assert.equal(cast(field('LONG_BLOB', { str: 'text', charset: 224 })), 'text');
});

test('JSON is returned as its string; other types fall through', () => {
    assert.equal(cast(field('JSON', { str: '{"a":1}' })), '{"a":1}');
    assert.equal(cast(field('VAR_STRING', { str: 'x' })), NEXT);
});

test('execute typeCast converts dates and JSON only (no TINY/BIT/BLOB changes)', () => {
    const exec = (f) => typeCastExecute(f, () => NEXT);
    assert.equal(exec(field('DATETIME', { str: '2024-01-02 03:04:05' })), new Date('2024-01-02 03:04:05').getTime());
    assert.equal(exec(field('DATE', { str: '2024-01-02' })), new Date('2024-01-02 00:00:00').getTime());
    assert.equal(exec(field('JSON', { str: '[]' })), '[]');
    assert.equal(exec(field('TINY', { str: '1', length: 1 })), NEXT);
    assert.equal(exec(field('BLOB', { buf: Buffer.from([1]), charset: 63 })), NEXT);
});

function harness({ preparable }) {
    const calls = [];
    const pool = {
        execute: async (...a) => { calls.push(['execute', ...a]); return [[{ v: 1 }], []]; },
        query: async (...a) => { calls.push(['query', ...a]); return [[{ v: 1 }], []]; },
    };
    const statements = {
        isPreparable: () => preparable,
        recordHit: () => {},
        recordMiss: () => {},
        markUnpreparable: () => {},
    };
    return { executor: new Executor({ read: pool, write: pool }, statements, { record: () => {} }), calls };
}

test('native executor keeps the positional mysql2 call (no typeCast)', async () => {
    for (const preparable of [true, false]) {
        const { executor, calls } = harness({ preparable });
        await executor.query('SELECT ?', [1]);
        assert.equal(calls[0][1], 'SELECT ?');
        assert.deepEqual(calls[0][2], [1]);
    }
});

test('ox view passes typeCast on the execute and query paths; base is unaffected', async () => {
    const exec = harness({ preparable: true });
    await exec.executor.withOxTypeCast().query('SELECT ?', [1]);
    assert.equal(exec.calls[0][0], 'execute');
    assert.equal(exec.calls[0][1].sql, 'SELECT ?');
    assert.deepEqual(exec.calls[0][1].values, [1]);
    assert.equal(exec.calls[0][1].typeCast, typeCastExecute);

    const qry = harness({ preparable: false });
    await qry.executor.withOxTypeCast().scalar('SELECT ?', [1]);
    assert.equal(qry.calls[0][0], 'query');
    assert.equal(qry.calls[0][1].typeCast, typeCast);

    await qry.executor.query('SELECT ?', [1]);
    assert.equal(qry.calls[1][1], 'SELECT ?');
});

function exportsHarness(cfg) {
    const registered = {};
    const views = [];
    const executor = {
        query: async () => 'native',
        withOxTypeCast() { views.push(1); return { query: async () => 'ox' }; },
    };
    const api = { isReady: () => true, ready: async () => true, version: () => ({}), executor, cfg };
    register(api, (name, fn) => { registered[name] = fn; });
    return { registered, views };
}

test('oxQuery export uses the ox view by default and honours kora_sql_ox_typecast=false', async () => {
    const on = exportsHarness({ oxTypeCast: true });
    assert.equal(await on.registered.oxQuery('SELECT 1', [], 'r'), 'ox');
    assert.equal(await on.registered.query('SELECT 1', [], 'r'), 'native');

    const unset = exportsHarness(undefined);
    assert.equal(await unset.registered.oxQuery('SELECT 1', [], 'r'), 'ox');

    const off = exportsHarness({ oxTypeCast: false });
    assert.equal(await off.registered.oxQuery('SELECT 1', [], 'r'), 'native');
    assert.equal(off.views.length, 0);
});

test('a nil callback hole between params and resource is dropped (attribution kept)', async () => {
    const seen = [];
    const registered = {};
    const api = {
        isReady: () => true, ready: async () => true, version: () => ({}),
        executor: { query: async (sql, params, resource) => { seen.push([sql, params, resource]); return []; } },
    };
    register(api, (name, fn) => { registered[name] = fn; });
    await registered.query('SELECT 1', [], null, 'consumer');
    assert.deepEqual(seen[0], ['SELECT 1', [], 'consumer']);
});

test('kora_sql_ox_typecast convar defaults to true and can be disabled', () => {
    const cfgLoader = require('../../server/js/config');
    const run = (convars) => {
        globalThis.GetConvar = (name, def) => (name in convars ? convars[name] : def);
        try { return cfgLoader.load().oxTypeCast; } finally { delete globalThis.GetConvar; }
    };
    const base = { mysql_connection_string: 'mysql://u:p@localhost/db' };
    assert.equal(run(base), true);
    assert.equal(run({ ...base, kora_sql_ox_typecast: 'false' }), false);
    assert.equal(run({ ...base, kora_sql_ox_typecast: 'true' }), true);
});
