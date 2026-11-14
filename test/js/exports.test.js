'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { register } = require('../../server/js/exports.js');

function deferred() {
    let resolve, reject;
    const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
    return { promise, resolve, reject };
}

function harness(gate) {
    const registered = {};
    const api = {
        isReady: () => false,
        ready: () => gate.promise,
        version: () => ({ driver: 'test' }),
    };
    register(api, (name, fn) => { registered[name] = fn; });
    return { api, registered };
}

test('a data export issued during boot waits for the executor', async () => {
    const gate = deferred();
    const { api, registered } = harness(gate);
    let calls = 0;

    const resultPromise = registered.query('SELECT 1', [], 'consumer');
    await Promise.resolve();
    assert.equal(calls, 0);

    api.executor = {
        query: async (sql, params, resource) => {
            calls++;
            assert.equal(sql, 'SELECT 1');
            assert.deepEqual(params, []);
            assert.equal(resource, 'consumer');
            return [{ value: 1 }];
        },
    };
    gate.resolve(true);

    assert.deepEqual(await resultPromise, [{ value: 1 }]);
    assert.equal(calls, 1);
});

test('flush issued during boot waits for the queue', async () => {
    const gate = deferred();
    const { api, registered } = harness(gate);
    let flushed = false;

    const result = new Promise((resolve) => {
        registered.flush('players', (ok, err) => resolve({ ok, err }));
    });

    api.queue = {
        flush: async (table) => {
            assert.equal(table, 'players');
            flushed = true;
        },
    };
    assert.equal(flushed, false);
    gate.resolve(true);

    assert.deepEqual(await result, { ok: true, err: null });
    assert.equal(flushed, true);
});

test('fire-and-forget enqueues submitted during boot are retained in order', async () => {
    const gate = deferred();
    const { api, registered } = harness(gate);
    const rows = [];

    registered.enqueue('players', 'citizenid', { citizenid: 'a' }, {});
    registered.enqueue('players', 'citizenid', { citizenid: 'b' }, {});
    api.queue = {
        enqueue: (_table, _key, row) => rows.push(row.citizenid),
    };
    gate.resolve(true);
    await gate.promise;
    await Promise.resolve();

    assert.deepEqual(rows, ['a', 'b']);
});

test('a boot failure reaches callback callers as the real startup error', async () => {
    const gate = deferred();
    const { registered } = harness(gate);

    const result = new Promise((resolve) => {
        registered.query('SELECT 1', [], (value, err) => resolve({ value, err }));
    });
    gate.reject(new Error('database unavailable'));

    assert.deepEqual(await result, { value: null, err: 'database unavailable' });
});

test('S5: the trailing resource is trusted only from kora_sql itself; others are identified by GetInvokingResource', async () => {
    let invoker = 'kora_sql';
    const seen = [];
    const registered = {};
    const api = {
        isReady: () => true,
        ready: async () => true,
        version: () => ({}),
        executor: { query: async (sql, params, resource) => { seen.push(resource); return []; } },
        txn: { startTransaction: async () => true },
    };
    register(api, (name, fn) => { registered[name] = fn; }, { getInvokingResource: () => invoker, currentResource: 'kora_sql' });

    await registered.query('SELECT 1', [], 'real_consumer');
    invoker = 'spoofer';
    await registered.query('SELECT 1', [], 'kora_housing');
    await registered.query('SELECT 1', []);
    invoker = null;
    await registered.query('SELECT 1', [], 'internal');
    assert.deepEqual(seen, ['real_consumer', 'spoofer', 'spoofer', 'internal']);
});

test('S6: fire-and-forget enqueues retained before readiness are bounded (dropped and logged, never thrown)', async () => {
    const gate = deferred();
    const { api, registered } = harness(gate);
    const log = require('../../server/js/logger.js');
    const errors = [];
    const error = log.error;
    log.error = (_tag, m) => errors.push(m);
    try {
        for (let i = 0; i < 100005; i++) {
            assert.doesNotThrow(() => registered.enqueue('players', 'citizenid', { pk: `P${i}`, cols: { v: i } }, {}));
        }
        assert.equal(errors.length, 1, 'one log for the overflow, not one per call');
        assert.match(errors[0], /100000 writes are already waiting/);
        let drained = 0;
        api.queue = { enqueue: () => { drained++; } };
        gate.resolve(true);
        await gate.promise;
        await new Promise((resolve) => setImmediate(resolve));
        assert.equal(drained, 100000, 'every accepted write is still delivered');
        assert.ok(errors.some((m) => /5 fire-and-forget write\(s\) were dropped/.test(m)));
    } finally {
        log.error = error;
    }
});

test('H2: enqueue/enqueueMany never throw into the caller, before or after ready', async () => {
    const gate = deferred();
    const { api, registered } = harness(gate);
    const log = require('../../server/js/logger.js');
    const errors = [];
    const error = log.error;
    log.error = (_tag, m) => errors.push(m);
    try {
        api.queue = {
            enqueue: () => { throw new Error('boom-enqueue'); },
            enqueueMany: () => { throw new Error('boom-many'); },
        };
        assert.doesNotThrow(() => registered.enqueueMany('players', 'citizenid', [{ pk: null }], {}));
        gate.resolve(true);
        await gate.promise;
        await new Promise((resolve) => setImmediate(resolve));
        api.isReady = () => true;
        assert.doesNotThrow(() => registered.enqueueMany('players', 'citizenid', [{ pk: null }], {}));
        assert.doesNotThrow(() => registered.enqueue('players', 'citizenid', { pk: null }, {}));
        assert.equal(errors.filter((m) => /boom-many/.test(m)).length, 2);
        assert.equal(errors.filter((m) => /boom-enqueue/.test(m)).length, 1);
    } finally {
        log.error = error;
    }
});

test('oxmysql async aliases are genuine JS promise exports', async () => {
    const provided = {};
    const previousOn = globalThis.on;
    globalThis.on = (name, handler) => {
        handler((fn) => { provided[name] = fn; });
    };
    try {
        const gate = deferred();
        const { api } = harness(gate);
        api.executor = { query: async () => [{ value: 1 }], withOxTypeCast() { return this; } };
        gate.resolve(true);

        for (const name of ['query_async', 'execute_async', 'fetch_async', 'rawExecute_async', 'store_async']) {
            assert.equal(typeof provided[`__cfx_export_oxmysql_${name}`], 'function', `missing ${name}`);
        }
        assert.ok(provided.__cfx_export_oxmysql_query_async('SELECT 1', []) instanceof Promise);
        assert.deepEqual(await provided.__cfx_export_oxmysql_query_async('SELECT 1', []), [{ value: 1 }]);
        assert.equal(await provided.__cfx_export_oxmysql_store_async('SELECT 42'), 'SELECT 42');
    } finally {
        globalThis.on = previousOn;
    }
});

test('Lua wrapper argument shapes reach the impl with the caller resource', async () => {
    const gate = deferred();
    const { api, registered } = harness(gate);
    const seen = {};
    api.executor = {
        query: async (sql, params, resource) => { seen.query = [sql, params, resource]; return []; },
    };
    api.txn = {
        batch: async (queries, params) => { seen.batch = [queries, params]; return true; },
        transaction: async (queries, params, resource) => { seen.transaction = [queries, params, resource]; return true; },
    };
    gate.resolve(true);
    const call = (name, ...args) => new Promise((resolve) => registered[name](...args, (res, err) => resolve({ res, err })));

    // Kora.sql.query(sql, nil) -> (sql, null, resource, cb)
    assert.equal((await call('query', 'SELECT 1', null, 'kora_housing')).err, null);
    assert.deepEqual(seen.query, ['SELECT 1', null, 'kora_housing']);
    // Kora.sql.batch(statements) -> (statements, null, resource, cb)
    await call('batch', [{ query: 'UPDATE a' }], null, 'kora_housing');
    assert.deepEqual(seen.batch, [[{ query: 'UPDATE a' }], null]);
    // Kora.sql.transaction(queries) -> (queries, null, resource, cb)
    await call('transaction', ['UPDATE a'], null, 'kora_housing');
    assert.deepEqual(seen.transaction, [['UPDATE a'], null, 'kora_housing']);
});
