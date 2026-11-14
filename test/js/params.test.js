'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { normalizeParams, padParams, countPlaceholders, NULL_SENTINEL } = require('../../server/js/execute.js');

test('a hole in the middle of an array becomes SQL NULL', () => {
    const params = ['ABC123', 'police', undefined, 'police', 100, 1000, 1000];
    assert.deepEqual(normalizeParams(params), ['ABC123', 'police', null, 'police', 100, 1000, 1000]);
});

test('a numeric-keyed map is rebuilt as a dense array', () => {
    assert.deepEqual(normalizeParams({ 1: 'a', 2: 'b', 4: 'd' }), ['a', 'b', null, 'd']);
});

test('the NULL sentinel becomes SQL NULL', () => {
    assert.deepEqual(normalizeParams(['a', NULL_SENTINEL, 'c']), ['a', null, 'c']);
});

test('the sentinel is also mapped inside a rebuilt map', () => {
    assert.deepEqual(normalizeParams({ 1: NULL_SENTINEL, 2: 'b' }), [null, 'b']);
});

test('missing params normalise to an empty array', () => {
    assert.deepEqual(normalizeParams(null), []);
    assert.deepEqual(normalizeParams(undefined), []);
    assert.deepEqual(normalizeParams({}), []);
});

test('a well-formed array is passed through unchanged', () => {
    assert.deepEqual(normalizeParams(['a', 1, true, null]), ['a', 1, true, null]);
});

test('named-placeholder objects are left alone', () => {
    const named = { id: 7, name: 'x' };
    assert.deepEqual(normalizeParams(named), named);
});

test('a trailing hole is preserved, not truncated', () => {
    assert.deepEqual(normalizeParams({ 1: 'a', 3: 'c' }), ['a', null, 'c']);
});

test('normalised output never contains undefined', () => {
    for (const input of [['a', undefined], { 1: 'a', 3: 'c' }, [undefined, undefined]]) {
        const out = normalizeParams(input);
        assert.ok(Array.isArray(out), 'expected an array');
        assert.ok(!out.some((v) => v === undefined), 'undefined survived normalisation');
    }
});

test('trailing missing params are padded with NULL to the placeholder count', () => {
    const sql = `INSERT INTO products VALUES (${new Array(18).fill('?').join(',')})`;
    const params = new Array(15).fill('x');
    const out = padParams(sql, params);
    assert.equal(out.length, 18);
    assert.deepEqual(out.slice(15), [null, null, null]);
    assert.equal(params.length, 15, 'input must not be mutated');
});

test('an empty params array is padded when the SQL has placeholders', () => {
    assert.deepEqual(padParams('SELECT ?, ?', []), [null, null]);
});

test('extra params are not trimmed and full arrays pass through', () => {
    assert.deepEqual(padParams('SELECT ?', ['a', 'b']), ['a', 'b']);
    const full = ['a', 'b'];
    assert.equal(padParams('SELECT ?, ?', full), full);
});

test('question marks in strings, identifiers and comments are not counted', () => {
    assert.equal(countPlaceholders("SELECT '?', \"?\", `a?b`, ? -- ?\n, ? /* ? */ , ?"), 3);
    assert.equal(countPlaceholders("SELECT 'it\\'s ?', ?"), 1);
    assert.equal(countPlaceholders("SELECT 'it''s ?', ?"), 1);
});

test('named-param objects are never padded', () => {
    const named = { id: 1 };
    assert.equal(padParams('SELECT :id, ?', named), named);
});
