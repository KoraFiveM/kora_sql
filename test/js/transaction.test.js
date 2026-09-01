'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { TransactionRunner } = require('../../server/js/transaction');

function harness(failQuery = false) {
    const calls = [];
    const connection = {
        beginTransaction: async () => calls.push(['begin']),
        query: async (sql, params) => {
            calls.push(['query', sql, params]);
            if (failQuery) throw new Error('query failed');
            return [[{ ok: 1 }], []];
        },
        execute: async (sql, params) => {
            calls.push(['execute', sql, params]);
            return [{ affectedRows: 1 }, []];
        },
        commit: async () => calls.push(['commit']),
        rollback: async () => calls.push(['rollback']),
        release: () => calls.push(['release']),
    };
    const runner = new TransactionRunner({ write: { getConnection: async () => connection } });
    return { runner, calls };
}

test('transaction accepts every oxmysql query shape and normalizes named binds', async () => {
    const { runner, calls } = harness();
    const ok = await runner.transaction([
        'UPDATE a SET value = @value',
        { query: 'UPDATE b SET value = :value', parameters: { ':value': 2 } },
        ['UPDATE c SET value = ?', [3]],
    ], { '@value': 1 }, 'consumer');

    assert.equal(ok, true);
    assert.deepEqual(calls, [
        ['begin'],
        ['query', 'UPDATE a SET value = :value', { '@value': 1, value: 1 }],
        ['query', 'UPDATE b SET value = :value', { ':value': 2, value: 2 }],
        ['query', 'UPDATE c SET value = ?', [3]],
        ['commit'],
        ['release'],
    ]);
});

test('transaction rolls back and emits the oxmysql error event', async () => {
    const { runner, calls } = harness(true);
    const previous = globalThis.TriggerEvent;
    let event;
    globalThis.TriggerEvent = (...args) => { event = args; };
    try {
        assert.equal(await runner.transaction(['DELETE FROM a'], [], 'consumer'), false);
        assert.deepEqual(calls.map((call) => call[0]), ['begin', 'query', 'rollback', 'release']);
        assert.equal(event[0], 'oxmysql:transaction-error');
        assert.equal(event[1].resource, 'consumer');
    } finally {
        globalThis.TriggerEvent = previous;
    }
});

test('startTransaction commits by default and rolls back on explicit false', async () => {
    const committed = harness();
    assert.equal(await committed.runner.startTransaction(async (query) => {
        assert.deepEqual(await query('SELECT @value AS value', { '@value': 4 }), [{ ok: 1 }]);
    }), true);
    assert.deepEqual(committed.calls.map((call) => call[0]), ['begin', 'query', 'commit', 'release']);
    assert.equal(committed.calls[1][1], 'SELECT :value AS value');

    const rolledBack = harness();
    assert.equal(await rolledBack.runner.startTransaction(async () => false), false);
    assert.deepEqual(rolledBack.calls.map((call) => call[0]), ['begin', 'rollback', 'release']);
});
