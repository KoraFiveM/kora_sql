// Export readiness contract.
//
// FiveM registers JS exports before qbsql's asynchronous pool boot completes.
// Legacy compatibility consumers can query immediately while loading, so the
// export boundary itself must retain those calls until the driver is ready.

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
