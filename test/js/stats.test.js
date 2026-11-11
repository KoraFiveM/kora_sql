'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { Stats, fingerprint } = require('../../server/js/stats.js');

test('P2: concatenated literals collapse to one fingerprint', () => {
    const a = fingerprint("SELECT * FROM players WHERE citizenid = 'ABC123' AND cash > 500");
    const b = fingerprint("SELECT  *  FROM players\nWHERE citizenid = 'XYZ9''9' AND cash > 12.5");
    assert.equal(a, 'SELECT * FROM players WHERE citizenid = ? AND cash > ?');
    assert.equal(a, b);
    assert.equal(fingerprint('SELECT * FROM t WHERE id IN (1, 2, 3)'), fingerprint('SELECT * FROM t WHERE id IN (4,5)'));
    assert.equal(fingerprint('SELECT * FROM t WHERE x = 0x1F'), 'SELECT * FROM t WHERE x = ?');
});

test('P2: identifiers, placeholders and digits inside names are untouched', () => {
    assert.equal(fingerprint('SELECT `col1`, t2.x FROM `table 9` t2 WHERE a = ? AND b = :name'),
        'SELECT `col1`, t2.x FROM `table 9` t2 WHERE a = ? AND b = :name');
});

test('P2: the fingerprint map is capped and evictions are folded into <other>', () => {
    const stats = new Stats(1e9, 10, 3);
    for (let i = 0; i < 50; i++) stats.record(`SELECT * FROM t${i}`, 1, 1, false, 'res');
    assert.equal(stats.byFingerprint.size, 3);
    const summary = stats.summary({});
    assert.equal(summary.queries.total, 50, 'totals still count every query');
    assert.equal(summary.queries.evictedQueries, 47);
    assert.ok(summary.queries.topByTotalMs.some((t) => t.sql === '<other>' && t.count === 47));
    stats.reset();
    assert.equal(stats.summary({}).queries.total, 0);
});

test('P2: recently used fingerprints survive eviction (LRU)', () => {
    const stats = new Stats(1e9, 10, 2);
    stats.record('SELECT 1', 1, 0, false);
    stats.record('SELECT a FROM b', 1, 0, false);
    stats.record('SELECT 2', 1, 0, false);
    stats.record('SELECT c FROM d', 1, 0, false);
    assert.deepEqual([...stats.byFingerprint.keys()], ['SELECT ?', 'SELECT c FROM d']);
});

test('P2: summary keeps the top 10 by total time without sorting everything', () => {
    const stats = new Stats(1e9, 10, 100);
    for (let i = 0; i < 30; i++) stats.record(`SELECT x${i} FROM t`, i, 0, false);
    const top = stats.summary({}).queries.topByTotalMs;
    assert.equal(top.length, 10);
    assert.deepEqual(top.map((t) => t.totalMs), [29, 28, 27, 26, 25, 24, 23, 22, 21, 20]);
});
