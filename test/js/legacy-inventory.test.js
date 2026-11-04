'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { isPoliceTrashDelete, createLegacyInventoryBridge } = require('../../server/js/legacy-inventory');
const { Executor } = require('../../server/js/execute');
const { register } = require('../../server/js/exports');

const SQL = "DELETE FROM inventories WHERE identifier = 'policetrash'";
function fixture(options = {}) {
    let state = options.state || 'started';
    const listeners = [];
    const calls = [], stats = [];
    const bridge = createLegacyInventoryBridge({
        getState: () => state,
        request: options.request || ((callback) => queueMicrotask(() => callback(1, null))),
        onStop: (callback) => listeners.push(callback),
    });
    const pool = { execute: async (sql, params) => {
        calls.push({ sql, params });
        return [{ affectedRows: 7, insertId: 0 }, undefined];
    } };
    const executor = new Executor({ read: pool, write: pool }, {
        isPreparable: () => true, recordHit: () => {},
    }, { record: (...args) => stats.push(args) }, bridge);
    const registered = {};
    register({ ready: async () => true, isReady: () => true, version: () => ({}), executor },
        (name, fn) => { registered[name] = fn; });
    return { executor, registered, calls, stats, stop() {
        state = 'stopped';
        for (const callback of listeners) callback('kora_inventory');
    } };
}

test('matcher accepts only the single supported police-trash delete', () => {
    assert.ok(isPoliceTrashDelete(SQL, []));
    assert.ok(isPoliceTrashDelete(' delete FROM `inventories` WHERE `identifier` = ? ; ', ['policetrash']));
    assert.ok(isPoliceTrashDelete('DELETE FROM inventories WHERE identifier=:id', { id: 'policetrash' }));
    for (const sql of [
        "DELETE FROM inventories WHERE identifier = 'other'",
        SQL + ' OR 1=1', SQL + '; DELETE FROM players', SQL + ' /* extra */',
        "DELETE FROM kora_inventory_inventories WHERE inventory_id = 'policetrash'",
        "DELETE FROM `inventories WHERE identifier = 'policetrash'",
        "DELETE FROM app.inventories WHERE identifier = 'policetrash'",
    ]) assert.equal(isPoliceTrashDelete(sql, []), false, sql);
    assert.equal(isPoliceTrashDelete('DELETE FROM inventories WHERE identifier=?', ['policetrash', 'extra']), false);
});

test('all ad-hoc projections preserve header/count semantics without raw legacy SQL', async () => {
    const f = fixture();
    assert.equal((await f.executor.query(SQL, [], 'job')).affectedRows, 1);
    assert.deepEqual(await f.executor.execute(SQL, [], 'job'), {
        affectedRows: 1, insertId: 0, changedRows: 0, warningStatus: 0,
    });
    assert.equal(await f.executor.update('DELETE FROM inventories WHERE identifier=?', ['policetrash']), 1);
    assert.equal(await f.executor.prepare('DELETE FROM inventories WHERE identifier=@id', { '@id': 'policetrash' }), 1);
    assert.equal((await f.executor.rawExecute(SQL, [])).affectedRows, 1);
    assert.equal(f.calls.length, 0);
    assert.equal(f.stats.length, 5);
    assert.equal(f.stats[0][4], 'job');
});

test('standalone SQL and unrelated/native statements execute unchanged', async () => {
    for (const state of ['missing', 'stopped']) {
        const f = fixture({ state, request: () => assert.fail('provider must not be called') });
        assert.equal(await f.executor.update(SQL, []), 7);
        assert.equal(f.calls[0].sql, SQL);
    }
    const f = fixture();
    const native = 'DELETE FROM kora_inventory_inventories WHERE inventory_type=? AND inventory_id=?';
    await f.executor.update(native, ['stash', 'policetrash']);
    await f.executor.update("DELETE FROM inventories WHERE identifier='other'", []);
    assert.equal(f.calls.length, 2);
});

test('provider failures reject rather than falling back to stale storage or zero success', async () => {
    for (const request of [
        (callback) => callback(null, 'inventory persistence unavailable'),
        (callback) => callback(false, null),
        (callback) => callback(-1, null),
        (callback) => callback('1', null),
        () => { throw new Error('No such export deleteLegacyPoliceTrash'); },
    ]) {
        const f = fixture({ state: 'starting', request });
        await assert.rejects(f.executor.query(SQL, []));
        assert.equal(f.calls.length, 0);
        assert.equal(f.stats[0][3], true);
    }
});

test('export promise and callback paths each settle once on duplicate provider replies', async () => {
    const f = fixture({ request: (callback) => { callback(0, null); callback(null, 'late failure'); } });
    assert.equal((await f.registered.query(SQL, [], 'job')).affectedRows, 0);
    let replies = 0;
    await new Promise((resolve, reject) => {
        f.registered.execute(SQL, [], (value, error) => {
            replies++;
            try { assert.equal(error, null); assert.equal(value.affectedRows, 0); resolve(); }
            catch (err) { reject(err); }
        }, 'job');
    });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(replies, 1);
});

test('callback exports report provider errors exactly once', async () => {
    const f = fixture({ request: (callback) => { callback(null, 'blocked'); callback(1, null); } });
    const replies = [];
    await new Promise((resolve) => f.registered.update(SQL, [], (value, error) => {
        replies.push({ value, error }); resolve();
    }, 'job'));
    await new Promise((resolve) => setImmediate(resolve));
    assert.deepEqual(replies, [{ value: null, error: 'blocked' }]);
});

test('provider stop rejects a pending call and ignores its stale callback', async () => {
    let reply;
    const f = fixture({ request: (callback) => { reply = callback; } });
    const promise = f.executor.query(SQL, []);
    f.stop();
    await assert.rejects(promise, /kora_inventory stopped/);
    reply(1, null);
    assert.equal(f.calls.length, 0);
});

test('an in-flight provider operation waits for its actual durable result', async () => {
    let reply, settled = false;
    const f = fixture({ request: (callback) => { reply = callback; } });
    const result = f.executor.query(SQL, []).then((value) => { settled = true; return value; });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(settled, false);
    reply(1, null);
    assert.equal((await result).affectedRows, 1);
    assert.equal(f.calls.length, 0);
});
