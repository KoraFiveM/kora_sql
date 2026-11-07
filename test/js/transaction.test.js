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
        destroy: () => calls.push(['destroy']),
    };
    const runner = new TransactionRunner({ write: { getConnection: async () => connection } });
    return { runner, calls, connection };
}

function deferred() {
    let resolve;
    const promise = new Promise((done) => { resolve = done; });
    return { promise, resolve };
}

const nextTurn = () => new Promise((resolve) => setImmediate(resolve));

test('checked transaction rejects a zero-row precondition before dependent writes', async () => {
    const { runner, calls, connection } = harness();
    connection.query = async (sql) => { calls.push(['query', sql]); return [{ affectedRows: 0 }, []]; };
    const result = await runner.transactionChecked([
        { query: 'UPDATE balance SET amount = amount - 100 WHERE amount >= 100', expectedRows: 1, failureCode: 'insufficient_funds' },
        { query: 'INSERT INTO ownership VALUES (1)' },
    ]);
    assert.equal(result.success, false);
    assert.equal(result.code, 'insufficient_funds');
    assert.deepEqual(calls.map(([kind]) => kind), ['begin', 'query', 'rollback', 'release']);
});

test('checked transaction returns results only after confirmed commit', async () => {
    const { runner, calls, connection } = harness();
    connection.query = async () => [{ affectedRows: 1, insertId: 7 }, []];
    const result = await runner.transactionChecked([{ query: 'INSERT INTO receipt VALUES (1)', expectedRows: 1 }]);
    assert.equal(result.success, true);
    assert.equal(result.results[0].insertId, 7);
    assert.deepEqual(calls.map(([kind]) => kind), ['begin', 'commit', 'release']);
});

test('checked transaction preserves commit uncertainty and discards its connection', async () => {
    const { runner, calls, connection } = harness();
    connection.commit = async () => { calls.push(['commit']); throw new Error('reply lost after commit'); };
    const result = await runner.transactionChecked([{ query: 'INSERT INTO receipt VALUES (1)' }]);
    assert.equal(result.success, false);
    assert.equal(result.code, 'indeterminate');
    assert.equal(calls.at(-1)[0], 'destroy');
});

test('a restarted provider joins an in-flight checked operation without executing twice', async () => {
    const { runner, calls, connection } = harness();
    const blocked = deferred();
    connection.query = async () => { calls.push(['query']); return blocked.promise; };
    const operation = { key: 'bank:resource:key', fingerprint: 'immutable terms' };
    const first = runner.transactionChecked([{ query: 'INSERT INTO receipt VALUES (1)' }], operation);
    await nextTurn();
    const retried = runner.transactionChecked([{ query: 'INSERT INTO receipt VALUES (1)' }], operation);
    assert.equal(first, retried);
    const changed = await runner.transactionChecked([], { ...operation, fingerprint: 'changed terms' });
    assert.equal(changed.code, 'indeterminate');
    blocked.resolve([{ affectedRows: 1 }, []]);
    assert.equal((await retried).success, true);
    assert.equal(calls.filter(([kind]) => kind === 'query').length, 1);
    assert.equal(calls.filter(([kind]) => kind === 'commit').length, 1);
});

test('receipt recovery waits for an old driver worker without submitting new SQL', async () => {
    const { runner, calls, connection } = harness();
    const blocked = deferred();
    connection.query = async () => { calls.push(['query']); return blocked.promise; };
    const operation = { key: 'inventory:claim', fingerprint: 'source revision and destination', citizenids: ['CITIZEN'] };
    const transaction = runner.transactionChecked([{ query: 'UPDATE recovery receipt', expectedRows: 1 }], operation);
    await nextTurn();
    assert.equal(runner.hasActivePlayerOperation('CITIZEN'), true);
    let allResolved = false;
    const all = runner.awaitCheckedOperations('inventory:').then((value) => { allResolved = true; return value; });
    let resolved = false;
    const recovery = runner.awaitCheckedOperation(operation.key, operation.fingerprint).then((result) => { resolved = true; return result; });
    await nextTurn();
    assert.equal(allResolved, false);
    assert.equal(resolved, false, 'a pending receipt is unsafe until the old worker settles');
    assert.equal((await runner.awaitCheckedOperation(operation.key, 'changed')).result.code, 'indeterminate');
    blocked.resolve([{ affectedRows: 1 }, []]);
    await transaction;
    assert.equal((await all).settled, 1);
    assert.deepEqual(await runner.awaitCheckedOperations('inventory:'), { settled: 0 });
    assert.equal((await recovery).result.success, true);
    assert.equal(calls.filter(([kind]) => kind === 'query').length, 1);
    assert.deepEqual(await runner.awaitCheckedOperation(operation.key), { active: false });
    assert.equal(runner.hasActivePlayerOperation('CITIZEN'), false);
});

test('transaction accepts every oxmysql query shape and normalizes named binds', async () => {
    const { runner, calls } = harness();
    const ok = await runner.transaction([
        'UPDATE a SET value = @value',
        { query: 'UPDATE b SET value = :value', parameters: { ':value': 2 } },
        ['UPDATE c SET value = ?', [3]],
    ], { '@value': 1 }, 'consumer');

    assert.equal(ok, true);
    // Bound statements run prepared (binary protocol), like ad-hoc queries.
    assert.deepEqual(calls, [
        ['begin'],
        ['execute', 'UPDATE a SET value = :value', { '@value': 1, value: 1 }],
        ['execute', 'UPDATE b SET value = :value', { ':value': 2, value: 2 }],
        ['execute', 'UPDATE c SET value = ?', [3]],
        ['commit'],
        ['release'],
    ]);
});

test('S8/P9: transactions prepare bound statements, fall back once for unpreparable text, and keep parameter-less SQL on query()', async () => {
    const { StatementCache } = require('../../server/js/statements');
    const statements = new StatementCache(16);
    const calls = [];
    const connection = {
        beginTransaction: async () => calls.push(['begin']),
        execute: async (sql, params) => {
            calls.push(['execute', sql]);
            if (/^SET/.test(sql)) { const e = new Error('unsupported'); e.code = 'ER_UNSUPPORTED_PS'; throw e; }
            return [{ affectedRows: 1 }, []];
        },
        query: async (sql) => { calls.push(['query', sql]); return [{ affectedRows: 1 }, []]; },
        commit: async () => calls.push(['commit']),
        rollback: async () => calls.push(['rollback']),
        release: () => calls.push(['release']),
    };
    const runner = new TransactionRunner({ write: { getConnection: async () => connection } }, { statements });
    const sql = 'SET @kora_test = ?';
    assert.equal(await runner.transaction([[sql, [1]], ['UPDATE a SET v = 1', []], ['UPDATE b SET v = ?', [2]]], [], 'consumer'), true);
    assert.equal(await runner.transaction([[sql, [2]]], [], 'consumer'), true);
    assert.deepEqual(calls.filter(([kind]) => kind === 'execute' || kind === 'query'), [
        ['execute', sql], ['query', sql],                 // failed prepare paid once...
        ['query', 'UPDATE a SET v = 1'],                  // parameter-less: text protocol
        ['execute', 'UPDATE b SET v = ?'],
        ['query', sql],                                   // ...and remembered afterwards
    ]);
    assert.equal(statements.isPreparable(sql), false);

    // batch() gets the same fallback instead of failing on an unpreparable statement.
    const results = await runner.batch([[sql, [3]]]);
    assert.equal(results.length, 1);
});

test('S8: object binds are never expanded into SET assignments on the text protocol', () => {
    const { poolOptions } = require('../../server/js/pool');
    const options = poolOptions({ connection: { host: 'h', port: 3306, user: 'u', password: '', database: 'd', charset: 'utf8mb4' }, statementCache: 16 }, 4);
    assert.equal(options.stringifyObjects, true);
    const { format } = require('mysql2');
    assert.equal(format('UPDATE players SET ? WHERE id = ?', [{ money: 1e9 }, 1], options.stringifyObjects),
        "UPDATE players SET '[object Object]' WHERE id = 1");
});

test('P3: startTransaction callbacks beyond the cap wait for a slot instead of pinning more connections', async () => {
    const { runner } = harness();
    const capped = new TransactionRunner(runner.pools, { maxStartTransactions: 1 });
    const gate = deferred();
    let secondStarted = false;
    const first = capped.startTransaction(async () => { await gate.promise; });
    const second = capped.startTransaction(async () => { secondStarted = true; });
    await nextTurn();
    assert.equal(secondStarted, false, 'the second callback must wait for the first slot');
    gate.resolve();
    assert.deepEqual(await Promise.all([first, second]), [true, true]);
    assert.equal(secondStarted, true);
    assert.equal(capped.startActive, 0);
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
        assert.deepEqual(await query('SELECT @value AS value', { '@value': 4 }), { affectedRows: 1 });
        assert.deepEqual(await query('SELECT 1'), [{ ok: 1 }]);
    }), true);
    assert.deepEqual(committed.calls.map((call) => call[0]), ['begin', 'execute', 'query', 'commit', 'release']);
    assert.equal(committed.calls[1][1], 'SELECT :value AS value');

    const rolledBack = harness();
    assert.equal(await rolledBack.runner.startTransaction(async () => false), false);
    assert.deepEqual(rolledBack.calls.map((call) => call[0]), ['begin', 'rollback', 'release']);
});

for (const stage of ['begin', 'callback', 'query', 'commit', 'rollback', 'error cleanup']) {
    test(`startTransaction deadline frees a connection held by a hung ${stage}`, async (t) => {
        t.mock.timers.enable({ apis: ['setTimeout'] });
        const { runner, calls, connection } = harness();
        const entered = deferred();
        const blocked = deferred();
        t.after(() => blocked.resolve([[{ ok: 1 }], []]));
        const operation = stage === 'begin' ? 'beginTransaction' : stage === 'error cleanup' ? 'rollback' : stage;
        if (stage !== 'callback') {
            connection[operation] = async () => {
                calls.push([stage === 'begin' ? 'begin' : operation]);
                entered.resolve();
                return blocked.promise;
            };
        }

        let retainedQuery;
        let queryError;
        let callbackCalls = 0;
        let result;
        const completion = runner.startTransaction(async (query) => {
            callbackCalls++;
            retainedQuery = query;
            if (stage === 'callback') {
                entered.resolve();
                await blocked.promise;
                await query('UPDATE a SET value = 2');
            }
            if (stage === 'query') {
                const pending = query('SELECT 1');
                pending.catch((err) => { queryError = err; });
                await pending;
            }
            if (stage === 'error cleanup') throw new Error('callback failed');
            return stage === 'rollback' ? false : true;
        }).then((value) => { result = value; });
        await entered.promise;
        t.mock.timers.tick(29999);
        await nextTurn();
        assert.equal(result, undefined, 'keep the existing 30-second deadline');
        t.mock.timers.tick(1);
        await nextTurn();
        assert.equal(result, false, 'the deadline must settle the transaction despite the blocked operation');
        await completion;
        assert.equal(calls.filter(([name]) => name === 'destroy').length, 1);
        assert.equal(calls.filter(([name]) => name === 'release').length, 0, 'never recycle an unsafe connection');
        assert.equal(calls.filter(([name]) => name === 'rollback').length,
            stage === 'rollback' || stage === 'error cleanup' ? 1 : 0);
        if (stage === 'query') assert.match(queryError.message, /timed out after 30 seconds/);
        const before = calls.length;
        if (retainedQuery) {
            await assert.rejects(retainedQuery('UPDATE a SET value = 3'), /timed out after 30 seconds/);
            assert.equal(calls.length, before, 'a retained query must not touch the discarded connection');
        }
        blocked.resolve([[{ ok: 1 }], []]);
        await nextTurn();
        assert.equal(calls.length, before, 'late provider or callback completion must not commit or clean up again');
        if (stage === 'begin') assert.equal(callbackCalls, 0);
    });
}

for (const explicitFalse of [false, true]) {
    test(`startTransaction discards a connection after one failed rollback (explicit false: ${explicitFalse})`, async (t) => {
        t.mock.timers.enable({ apis: ['setTimeout'] });
        const { runner, calls, connection } = harness();
        connection.rollback = async () => {
            calls.push(['rollback']);
            throw new Error('rollback failed');
        };
        assert.equal(await runner.startTransaction(() => {
            if (explicitFalse) return false;
            throw new Error('callback failed');
        }), false);
        assert.deepEqual(calls.map(([name]) => name), ['begin', 'rollback', 'destroy']);
        t.mock.timers.tick(30000);
        await nextTurn();
        assert.equal(calls.length, 3, 'finished transactions must clear their deadline');
    });
}

test('transaction discards a connection whose rollback failed instead of returning it to the pool', async () => {
    const { runner, calls, connection } = harness(true);
    connection.rollback = async () => { calls.push(['rollback']); throw new Error('rollback failed'); };
    const previous = globalThis.TriggerEvent;
    globalThis.TriggerEvent = () => {};
    try {
        assert.equal(await runner.transaction(['DELETE FROM a'], [], 'consumer'), false);
        assert.deepEqual(calls.map((call) => call[0]), ['begin', 'query', 'rollback', 'destroy']);
    } finally {
        globalThis.TriggerEvent = previous;
    }
});
