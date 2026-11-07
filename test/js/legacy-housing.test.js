'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { stockRead, touchesStockTables, createLegacyHousingBridge } = require('../../server/js/legacy-housing');
const { Executor } = require('../../server/js/execute');

function fixture(options = {}) {
    let state = options.state || 'started', stopped;
    const calls = [], requests = [];
    const bridge = createLegacyHousingBridge({ getState: () => state,
        request: options.request || ((operation, args, cb) => { requests.push({ operation, args }); cb([{ house: 'native_home', citizenid: 'NEW' }]); }),
        onStop: (fn) => { stopped = fn; } });
    const run = async (sql, params) => { calls.push({ sql, params }); return [[{ archive: true }], []]; };
    const pool = { execute: run, query: run };
    const executor = new Executor({ read: pool, write: pool }, { isPreparable: () => true, recordHit() {} }, { record() {} }, null, bridge);
    return { executor, calls, requests, stop() { state = 'stopped'; stopped('kora_housing'); } };
}

test('recognizes all pinned read forms with exact bindings', () => {
    const cases = [
        ['SELECT * FROM houselocations', [], 'locations'],
        ['SELECT * FROM `houselocations` WHERE `name`=?;', ['home'], 'location'],
        ['SELECT owned FROM houselocations WHERE name = ?', ['home'], 'owned'],
        ['SELECT * FROM houselocations WHERE name LIKE ? ORDER BY LENGTH(`name`) desc, `name` DESC', ['%street%'], 'locations_like'],
        ['SELECT * FROM player_houses', [], 'owners'],
        ['SELECT * FROM player_houses WHERE house = ?', ['home'], 'house'],
        ['SELECT * FROM player_houses WHERE citizenid = :cid', { cid: 'NEW' }, 'citizen'],
        ['SELECT * FROM player_houses WHERE identifier = ? AND citizenid = ?', ['license:new', 'NEW'], 'identity'],
    ];
    for (const [sql, params, operation] of cases) assert.equal(stockRead(sql, params)?.operation, operation, sql);
    for (const sql of ['SELECT * FROM player_houses WHERE citizenid = ? OR 1=1', 'SELECT * FROM db.player_houses', 'SELECT * FROM player_houses; DROP TABLE players']) assert.equal(stockRead(sql, ['NEW']), null);
    assert.equal(stockRead('SELECT * FROM player_houses WHERE citizenid=?', ['NEW', 'extra']), null);
    assert.equal(stockRead('SELECT * FROM player_houses WHERE citizenid=?', [42]), null);
});

test('query/single/scalar/prepare use native rows and named binds without archival SQL', async () => {
    const f = fixture();
    assert.deepEqual(await f.executor.query('SELECT * FROM player_houses WHERE citizenid=@cid', { '@cid': 'NEW' }, 'qb-spawn'), [{ house: 'native_home', citizenid: 'NEW' }]);
    assert.equal((await f.executor.single('SELECT * FROM houselocations WHERE name=?', ['home'], 'qb-garages')).house, 'native_home');
    assert.equal(await f.executor.scalar('SELECT owned FROM houselocations WHERE name=?', ['home'], 'consumer'), 'native_home');
    assert.equal(f.requests[0].operation, 'citizen');
    assert.deepEqual(f.requests[0].args, ['NEW']);
    assert.equal(f.calls.length, 0);
});

test('only the original owning resource bypasses projection during import', async () => {
    const f = fixture();
    await f.executor.query('SELECT * FROM houselocations', [], 'kora_housing');
    assert.equal(f.calls.length, 1);
    await f.executor.query('SELECT * FROM houselocations', [], 'other');
    assert.equal(f.calls.length, 1);
    assert.equal(f.requests.length, 1);
});

test('unsupported reads and stock writes reject while native authority is selected', async () => {
    for (const sql of ['UPDATE player_houses SET citizenid=? WHERE house=?', 'DELETE FROM player_houses WHERE citizenid=?', 'INSERT INTO houselocations (name) VALUES (?)', 'SELECT COUNT(*) FROM player_houses', 'SELECT * FROM other.houselocations']) {
        const f = fixture();
        await assert.rejects(f.executor.query(sql, ['NEW', 'home'], 'other'), /Unsupported stock housing SQL/);
        assert.equal(f.calls.length, 0);
    }
});

test('unrelated SQL/data and standalone stock installations remain unchanged', async () => {
    const f = fixture({ state: 'missing' });
    await f.executor.query('SELECT * FROM houselocations', [], 'stock');
    assert.equal(f.calls.length, 1);
    const sql = "SELECT * FROM messages WHERE body='FROM player_houses'";
    assert.equal(touchesStockTables(sql), false);
    assert.equal(touchesStockTables('SELECT * FROM kora_housing_properties'), false);
    await fixture().executor.query(sql, [], 'other');
});

test('S5: writes and reads that dodge the old FROM/JOIN/UPDATE/INTO/TABLE anchor are still caught', () => {
    for (const sql of [
        "INSERT player_houses (house, citizenid) VALUES ('h', 'c')",
        "REPLACE player_houses (house, citizenid) VALUES ('h', 'c')",
        'REPLACE INTO `houselocations` (name) VALUES (?)',
        'TRUNCATE player_houses',
        'TRUNCATE `houselocations`',
        'UPDATE players p, player_houses h SET h.citizenid = p.citizenid',
        'SELECT * FROM players, player_houses',
        'SELECT * FROM players p\nJOIN\n`player_houses` h ON 1',
        'DELETE h FROM player_houses AS h',
        'SELECT * FROM qb.player_houses',
    ]) {
        assert.equal(touchesStockTables(sql), true, sql);
    }
    // Data and comments still never trigger the guard.
    assert.equal(touchesStockTables("SELECT 'player_houses' AS label"), false);
    assert.equal(touchesStockTables('SELECT 1 -- player_houses\n'), false);
    assert.equal(touchesStockTables('SELECT 1 /* houselocations */'), false);
    assert.equal(touchesStockTables('SELECT * FROM player_houses_backup'), false);
});

test('S5: comma-join and INTO-less writes reject while native housing owns the tables', async () => {
    for (const sql of ['INSERT player_houses (house) VALUES (?)', 'TRUNCATE player_houses', 'UPDATE players p, player_houses h SET h.house = ?']) {
        const f = fixture();
        await assert.rejects(f.executor.query(sql, ['x'], 'other'), /Unsupported stock housing SQL/, sql);
        assert.equal(f.calls.length, 0, sql);
    }
});

test('S5: a resource cannot claim to be kora_housing through the trailing resource argument', async () => {
    const { register } = require('../../server/js/exports');
    const f = fixture();
    const registered = {};
    let invoker = 'evil_resource';
    register({ ready: async () => true, isReady: () => true, version: () => ({}), executor: f.executor },
        (name, fn) => { registered[name] = fn; },
        { getInvokingResource: () => invoker, currentResource: 'kora_sql' });

    // A foreign caller passing 'kora_housing' is treated as itself: the guard applies.
    await assert.rejects(registered.query('TRUNCATE player_houses', [], 'kora_housing'), /Unsupported stock housing SQL/);
    assert.equal(f.calls.length, 0);

    // kora_sql's own compat shims forward the real caller, which is honoured.
    invoker = 'kora_sql';
    await registered.query('SELECT * FROM houselocations', [], 'kora_housing');
    assert.equal(f.calls.length, 1, 'the verified owner reads its archive');

    // kora_housing calling directly is itself.
    invoker = 'kora_housing';
    await registered.query('SELECT * FROM houselocations', []);
    assert.equal(f.calls.length, 2);
});

test('stopped native provider never falls back to old archive, even after pending reply', async () => {
    let reply;
    const f = fixture({ request: (_, __, cb) => { reply = cb; } });
    const waiting = f.executor.query('SELECT * FROM player_houses', [], 'other');
    f.stop();
    await assert.rejects(waiting, /stopped/);
    reply([{ house: 'late' }]);
    await assert.rejects(f.executor.query('SELECT * FROM player_houses', [], 'other'), /archival/);
    assert.equal(f.calls.length, 0);
});

test('provider errors, invalid replies and thrown exports reject exactly once', async () => {
    for (const request of [(_, __, cb) => { cb(null, 'unmapped'); cb([]); }, (_, __, cb) => cb(false), () => { throw new Error('missing export'); }]) {
        const f = fixture({ request });
        await assert.rejects(f.executor.query('SELECT * FROM houselocations', [], 'other'));
        assert.equal(f.calls.length, 0);
    }
    const empty = fixture({ request: (_, __, cb) => cb({}) });
    assert.deepEqual(await empty.executor.query('SELECT * FROM player_houses', [], 'other'), []);
});
