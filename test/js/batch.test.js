// Golden SQL assertions for the batched-upsert builder. These are byte-for-byte
// string comparisons: the batch builder is where a silent data-corruption bug
// would live, so the exact wire text is pinned here and any drift fails loudly.
//
// Run with:  node --test  (from the resource root)

'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { build, buildUpdate, dialectFor, bucketFor } = require('../../server/js/batch.js');

const V8 = { isMariaDB: false, major: 8, minor: 0, patch: 34 };
const V8_OLD = { isMariaDB: false, major: 8, minor: 0, patch: 18 };
const MARIA = { isMariaDB: true, major: 10, minor: 11, patch: 14 };

test('dialectFor picks alias for MySQL >= 8.0.20', () => {
    assert.equal(dialectFor(V8), 'alias');
    assert.equal(dialectFor(V8_OLD), 'values');
    assert.equal(dialectFor(MARIA), 'values');
    assert.equal(dialectFor(undefined), 'values');
});

test('bucketFor quantises up to the next bucket', () => {
    assert.equal(bucketFor(1), 1);
    assert.equal(bucketFor(3), 4);
    assert.equal(bucketFor(5), 8);
    assert.equal(bucketFor(40), 64);
    assert.equal(bucketFor(200), 200);
});

test('assign / values dialect / no padding', () => {
    const rows = [
        { pk: 'ABC', cols: { money: '{"cash":1250}' } },
        { pk: 'DEF', cols: { money: '{"cash":90}' } },
    ];
    const { sql, params } = build('players', 'citizenid', ['money'], rows, { mode: 'assign', dialect: 'values', pad: false });
    assert.equal(
        sql,
        'INSERT INTO `players` (`citizenid`,`money`) VALUES (?,?),(?,?) ON DUPLICATE KEY UPDATE `money` = VALUES(`money`)'
    );
    assert.deepEqual(params, ['ABC', '{"cash":1250}', 'DEF', '{"cash":90}']);
});

test('assign / alias dialect / no padding', () => {
    const rows = [{ pk: 'ABC', cols: { money: 'm', position: 'p' } }];
    const { sql, params } = build('players', 'citizenid', ['money', 'position'], rows, { mode: 'assign', dialect: 'alias', pad: false });
    assert.equal(
        sql,
        'INSERT INTO `players` (`citizenid`,`money`,`position`) VALUES (?,?,?) AS `new` ' +
        'ON DUPLICATE KEY UPDATE `money` = `new`.`money`, `position` = `new`.`position`'
    );
    assert.deepEqual(params, ['ABC', 'm', 'p']);
});

test('assign / values / WITH padding to bucket 4 repeats an existing row', () => {
    const rows = [
        { pk: 'ABC', cols: { money: 'a' } },
        { pk: 'DEF', cols: { money: 'd' } },
        { pk: 'GHI', cols: { money: 'g' } },
    ];
    const { sql, params, rowCount } = build('players', 'citizenid', ['money'], rows, { mode: 'assign', dialect: 'values', pad: true });
    assert.equal(rowCount, 4, 'three rows pad up to bucket 4');
    assert.equal(
        sql,
        'INSERT INTO `players` (`citizenid`,`money`) VALUES (?,?),(?,?),(?,?),(?,?) ON DUPLICATE KEY UPDATE `money` = VALUES(`money`)'
    );
    // The 4th group repeats the first row (ABC) -- a genuine no-op under
    // last-write-wins assignment.
    assert.deepEqual(params, ['ABC', 'a', 'DEF', 'd', 'GHI', 'g', 'ABC', 'a']);
});

test('accumulate / values dialect', () => {
    const rows = [
        { pk: 'ABC', cols: { distance_driven: 12 } },
        { pk: 'DEF', cols: { distance_driven: 5 } },
    ];
    const { sql, params } = build('player_stats', 'citizenid', ['distance_driven'], rows, { mode: 'accumulate', dialect: 'values', pad: false });
    assert.equal(
        sql,
        'INSERT INTO `player_stats` (`citizenid`,`distance_driven`) VALUES (?,?),(?,?) ' +
        'ON DUPLICATE KEY UPDATE `distance_driven` = `distance_driven` + VALUES(`distance_driven`)'
    );
    assert.deepEqual(params, ['ABC', 12, 'DEF', 5]);
});

test('accumulate / alias dialect', () => {
    const rows = [{ pk: 'ABC', cols: { distance_driven: 12 } }];
    const { sql } = build('player_stats', 'citizenid', ['distance_driven'], rows, { mode: 'accumulate', dialect: 'alias', pad: false });
    assert.equal(
        sql,
        'INSERT INTO `player_stats` (`citizenid`,`distance_driven`) VALUES (?,?) AS `new` ' +
        'ON DUPLICATE KEY UPDATE `distance_driven` = `distance_driven` + `new`.`distance_driven`'
    );
});

test('padding + accumulate mode is a hard error (double-counting hazard)', () => {
    const rows = [{ pk: 'ABC', cols: { n: 1 } }];
    assert.throws(
        () => build('t', 'id', ['n'], rows, { mode: 'accumulate', pad: true }),
        /padding is not sound in accumulate mode/
    );
});

test('composite conflict key emits all key columns first', () => {
    const rows = [{ pk: ['veh1', 'trunk'], cols: { items: 'x' } }];
    const { sql, params } = build('inventories', ['identifier', 'kind'], ['items'], rows, { mode: 'assign', dialect: 'values', pad: false });
    assert.equal(
        sql,
        'INSERT INTO `inventories` (`identifier`,`kind`,`items`) VALUES (?,?,?) ON DUPLICATE KEY UPDATE `items` = VALUES(`items`)'
    );
    assert.deepEqual(params, ['veh1', 'trunk', 'x']);
});

test('update-only writes partial rows without attempting an insert', () => {
    const rows = [
        { pk: 'ABC', cols: { position: 'p1' } },
        { pk: 'DEF', cols: { position: 'p2' } },
    ];
    const { sql, params } = buildUpdate('players', 'citizenid', ['position'], rows, { mode: 'assign', pad: false });
    assert.equal(
        sql,
        'UPDATE `players` SET `position` = CASE WHEN `citizenid` = ? THEN ? WHEN `citizenid` = ? THEN ? ELSE `position` END WHERE `citizenid` IN (?,?)'
    );
    assert.deepEqual(params, ['ABC', 'p1', 'DEF', 'p2', 'ABC', 'DEF']);
});

test('update-only accumulate adds to the current value and keeps one IN list', () => {
    const rows = [
        { pk: 'ABC', cols: { bank: 5, cash: 1 } },
        { pk: 'DEF', cols: { bank: -2, cash: 0 } },
    ];
    const { sql, params } = buildUpdate('players', 'citizenid', ['bank', 'cash'], rows, { mode: 'accumulate', pad: false });
    assert.equal(
        sql,
        'UPDATE `players` SET ' +
        '`bank` = CASE WHEN `citizenid` = ? THEN `bank` + ? WHEN `citizenid` = ? THEN `bank` + ? ELSE `bank` END, ' +
        '`cash` = CASE WHEN `citizenid` = ? THEN `cash` + ? WHEN `citizenid` = ? THEN `cash` + ? ELSE `cash` END ' +
        'WHERE `citizenid` IN (?,?)'
    );
    assert.deepEqual(params, ['ABC', 5, 'DEF', -2, 'ABC', 1, 'DEF', 0, 'ABC', 'DEF']);
});

test('update-only padding repeats a row inside the IN list (assign only)', () => {
    const rows = [
        { pk: 'A', cols: { v: 1 } },
        { pk: 'B', cols: { v: 2 } },
        { pk: 'C', cols: { v: 3 } },
    ];
    const { sql, params, rowCount } = buildUpdate('t', 'id', ['v'], rows, { mode: 'assign', pad: true });
    assert.equal(rowCount, 4);
    assert.equal(sql,
        'UPDATE `t` SET `v` = CASE WHEN `id` = ? THEN ? WHEN `id` = ? THEN ? WHEN `id` = ? THEN ? WHEN `id` = ? THEN ? ELSE `v` END ' +
        'WHERE `id` IN (?,?,?,?)');
    assert.deepEqual(params, ['A', 1, 'B', 2, 'C', 3, 'A', 1, 'A', 'B', 'C', 'A']);
    assert.throws(() => buildUpdate('t', 'id', ['v'], rows, { mode: 'accumulate', pad: true }), /padding is not sound/);
});

test('update-only supports a composite conflict key', () => {
    const rows = [{ pk: ['veh1', 'trunk'], cols: { items: 'x' } }];
    const { sql, params } = buildUpdate('inventories', ['identifier', 'kind'], ['items'], rows, { mode: 'assign', pad: false });
    assert.equal(
        sql,
        'UPDATE `inventories` SET `items` = CASE WHEN `identifier` = ? AND `kind` = ? THEN ? ELSE `items` END WHERE (`identifier`,`kind`) IN ((?,?))'
    );
    assert.deepEqual(params, ['veh1', 'trunk', 'x', 'veh1', 'trunk']);
});

test('update-only composite keys use a row-constructor IN list, not an OR chain', () => {
    const rows = [
        { pk: ['veh1', 'trunk'], cols: { items: 'x' } },
        { pk: ['veh2', 'glovebox'], cols: { items: 'y' } },
    ];
    const { sql, params } = buildUpdate('inventories', ['identifier', 'kind'], ['items'], rows, { mode: 'assign', pad: false });
    assert.equal(
        sql,
        'UPDATE `inventories` SET `items` = CASE WHEN `identifier` = ? AND `kind` = ? THEN ? WHEN `identifier` = ? AND `kind` = ? THEN ? ELSE `items` END ' +
        'WHERE (`identifier`,`kind`) IN ((?,?),(?,?))'
    );
    assert.doesNotMatch(sql, / OR /);
    assert.deepEqual(params, ['veh1', 'trunk', 'x', 'veh2', 'glovebox', 'y', 'veh1', 'trunk', 'veh2', 'glovebox']);
});
