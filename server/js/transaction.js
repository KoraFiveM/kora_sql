// Transaction and batch runners on a single pinned connection.
//
// oxmysql exposes two related shapes and this module backs both:
//   * transaction(statements)         -- run all inside BEGIN/COMMIT, rollback on any error
//   * transaction(sql, [paramsList])  -- one statement, many parameter sets, all in one txn
//   * batch(statements)               -- same connection, NO transaction wrapper
// The "one query, many param sets" form is the one people most often forget is
// supported (see docs.md); it maps cleanly onto looping the same prepared
// statement on the pinned connection.
//
// Every statement goes through execute.js's runOnConnection(): bound
// statements are prepared (cached per connection, bind values inert), with
// the shared unpreparable fallback; parameter-less statements use the text
// protocol, exactly as ad-hoc queries do.

'use strict';

const { normalizeParams, normalizeNamedPlaceholders, runOnConnection } = require('./execute');

class TransactionRunner {
    // opts.statements: the shared StatementCache (unpreparable marks).
    // opts.maxStartTransactions: concurrent startTransaction callbacks allowed
    // to pin a write connection; later callers wait for a slot.
    constructor(pools, opts = {}) {
        this.pools = pools;
        this.statements = opts.statements || null;
        this.checkedInFlight = new Map();
        this.startLimit = opts.maxStartTransactions > 0 ? opts.maxStartTransactions : Infinity;
        this.startActive = 0;
        this.startWaiters = [];
    }

    _run(conn, st) {
        return runOnConnection(conn, st.sql, st.params, this.statements);
    }

    // A slot-limited semaphore for startTransaction: each callback can hold a
    // write connection for up to 30 s, so an unbounded number of them could
    // occupy the whole write pool.
    _acquireStartSlot() {
        if (this.startActive < this.startLimit) {
            this.startActive++;
            return Promise.resolve();
        }
        return new Promise((resolve) => this.startWaiters.push(resolve));
    }

    _releaseStartSlot() {
        const next = this.startWaiters.shift();
        if (next) next();
        else this.startActive--;
    }

    // Expected row counts are business preconditions, not merely SQL success.
    transactionChecked(queries, operation) {
        if (!operation) return this._transactionChecked(queries);
        if (typeof operation.key !== 'string' || typeof operation.fingerprint !== 'string') {
            return Promise.reject(new TypeError('Checked operation needs key and fingerprint'));
        }
        const previous = this.checkedInFlight.get(operation.key);
        if (previous) {
            if (previous.fingerprint !== operation.fingerprint) {
                return Promise.resolve({ success: false, code: 'indeterminate', message: 'Another request owns this operation key' });
            }
            return previous.promise;
        }
        const promise = this._transactionChecked(queries);
        this.checkedInFlight.set(operation.key, { fingerprint: operation.fingerprint, promise, citizenids: Array.isArray(operation.citizenids) ? operation.citizenids : [] });
        promise.finally(() => {
            if (this.checkedInFlight.get(operation.key)?.promise === promise) this.checkedInFlight.delete(operation.key);
        }).catch(() => {});
        return promise;
    }

    hasActivePlayerOperation(citizenid) {
        for (const operation of this.checkedInFlight.values()) {
            if (operation.citizenids.includes(citizenid)) return true;
        }
        return false;
    }

    async awaitCheckedOperation(key, fingerprint) {
        const operation = this.checkedInFlight.get(key);
        if (!operation) return { active: false };
        if (fingerprint != null && operation.fingerprint !== fingerprint) {
            return { active: true, result: { success: false, code: 'indeterminate', message: 'Another request owns this operation key' } };
        }
        return { active: true, result: await operation.promise };
    }

    async awaitCheckedOperations(prefix) {
        if (typeof prefix !== 'string' || !prefix.length) throw new TypeError('An operation key prefix is required');
        const pending = [];
        for (const [key, operation] of this.checkedInFlight) {
            if (key.startsWith(prefix)) pending.push(operation.promise);
        }
        await Promise.all(pending);
        return { settled: pending.length };
    }

    async _transactionChecked(queries) {
        if (!Array.isArray(queries) || !queries.length) throw new TypeError('Checked transaction requires statements');
        const statements = this._normalise(queries);
        for (const q of queries) {
            if (q.expectedRows !== undefined && (!Number.isSafeInteger(q.expectedRows) || q.expectedRows < 0)) {
                throw new TypeError('expectedRows must be a non-negative integer');
            }
        }
        const conn = await this.pools.write.getConnection();
        const results = [];
        let committing = false;
        let unsafe = false;
        let index = 0;
        try {
            await conn.beginTransaction();
            for (; index < statements.length; index++) {
                const [result] = await this._run(conn, statements[index]);
                const count = Array.isArray(result) ? result.length : result.affectedRows;
                if (queries[index].expectedRows !== undefined && count !== queries[index].expectedRows) {
                    const err = new Error('Transaction precondition changed');
                    err.operationCode = queries[index].failureCode || 'conflict';
                    throw err;
                }
                results.push(result);
            }
            committing = true;
            await conn.commit();
            return { success: true, results };
        } catch (err) {
            if (committing) unsafe = true;
            try { await conn.rollback(); } catch (_) { unsafe = true; }
            return {
                success: false,
                code: committing || unsafe ? 'indeterminate' : err.operationCode || (err.code === 'ER_DUP_ENTRY' ? 'duplicate' : 'unavailable'),
                statement: index + 1,
                message: err.operationCode ? err.message : 'Database transaction could not be confirmed',
            };
        } finally {
            if (unsafe && typeof conn.destroy === 'function') conn.destroy();
            else conn.release();
        }
    }

    // Normalise oxmysql's two argument shapes into an array of {sql, params}.
    //
    // These run on a pinned connection rather than through the Executor, so
    // normalizeParams has to be applied here too -- otherwise a
    // holed Lua param array reaches mysql2 as undefined inside a transaction,
    // where the failure also rolls back every sibling statement.
    _normalise(queries, maybeParams) {
        if (typeof queries === 'string') {
            // transaction(sql, [ [p1], [p2], ... ]) -- one statement, many param sets.
            const sql = queries;
            const paramSets = Array.isArray(maybeParams) ? maybeParams : [maybeParams || []];
            return paramSets.map((params) => {
                const normalized = normalizeNamedPlaceholders(sql, params);
                return { sql: normalized.sql, params: normalizeParams(normalized.params) };
            });
        }
        if (!Array.isArray(queries)) {
            throw new TypeError(`Transaction queries must be array, received '${typeof queries}'.`);
        }
        // Current oxmysql accepts all three established transaction shapes:
        //   { 'SQL', 'SQL' }, sharedParams
        //   { { query = 'SQL', values|parameters = {...} }, ... }
        //   { { 'SQL', {...} }, ... }
        return queries.map((q) => {
            let sql, params;
            if (Array.isArray(q)) {
                sql = q[0];
                params = q[1];
            } else if (typeof q === 'string') {
                sql = q;
                params = maybeParams;
            } else if (q && typeof q === 'object') {
                sql = q.query || q.sql;
                params = q.parameters ?? q.values ?? q.params ?? maybeParams;
            }
            if (typeof sql !== 'string') throw new TypeError('Transaction query must be a string');
            const normalized = normalizeNamedPlaceholders(sql, params);
            return { sql: normalized.sql, params: normalizeParams(normalized.params) };
        });
    }

    async transaction(queries, maybeParams, resource) {
        const statements = this._normalise(queries, maybeParams);
        const conn = await this.pools.write.getConnection();
        let discard = false;
        try {
            await conn.beginTransaction();
            for (const st of statements) {
                await this._run(conn, st);
            }
            await conn.commit();
            return true;
        } catch (err) {
            // A connection whose ROLLBACK failed may still hold the open
            // transaction; never hand it back to the pool.
            try { await conn.rollback(); } catch (_) { discard = true; }
            console.error(`qbsql transaction rolled back: ${err.message}`);
            if (typeof globalThis.TriggerEvent === 'function') {
                globalThis.TriggerEvent('oxmysql:transaction-error', {
                    query: statements.map((st) => `${st.sql} ${JSON.stringify(st.params)}`).join('\n'),
                    parameters: maybeParams,
                    message: err.message,
                    err,
                    resource: resource || 'unknown',
                });
            }
            return false;
        } finally {
            if (discard && typeof conn.destroy === 'function') conn.destroy();
            else conn.release();
        }
    }

    // Experimental oxmysql startTransaction contract. The callback receives a
    // query function pinned to this connection and decides whether to commit
    // (anything except explicit false) or roll back (false). A 30s deadline
    // matches oxmysql and prevents a leaked callback from pinning a pool slot.
    async startTransaction(callback) {
        if (typeof callback !== 'function') throw new TypeError('startTransaction requires a callback');

        await this._acquireStartSlot();
        try {
            return await this._startTransaction(callback);
        } finally {
            this._releaseStartSlot();
        }
    }

    async _startTransaction(callback) {
        const conn = await this.pools.write.getConnection();
        let closed = false;
        let discard = false;
        let rollbackAttempted = false;
        let timeout;
        const deadline = new Promise((_, reject) => {
            timeout = setTimeout(() => {
                closed = true;
                discard = true;
                reject(new Error('Transaction has timed out after 30 seconds.'));
            }, 30000);
        });
        try {
            await Promise.race([conn.beginTransaction(), deadline]);
            if (closed) throw new Error('Transaction has timed out after 30 seconds.');
            const query = async (sql, params = []) => {
                if (closed) throw new Error('Connection used by transaction timed out after 30 seconds.');
                const normalized = normalizeNamedPlaceholders(sql, params);
                const [result] = await Promise.race([
                    this._run(conn, { sql: normalized.sql, params: normalizeParams(normalized.params) }), deadline,
                ]);
                if (closed) throw new Error('Connection used by transaction timed out after 30 seconds.');
                return result;
            };
            const shouldCommit = await Promise.race([callback(query), deadline]);
            if (closed) throw new Error('Transaction has timed out after 30 seconds.');
            closed = true;
            if (shouldCommit === false) {
                rollbackAttempted = true;
                await Promise.race([conn.rollback(), deadline]);
                return false;
            }
            await Promise.race([conn.commit(), deadline]);
            return true;
        } catch (err) {
            closed = true;
            if (!discard && !rollbackAttempted) {
                rollbackAttempted = true;
                try {
                    await Promise.race([conn.rollback(), deadline]);
                } catch (_) {
                    discard = true;
                }
            } else {
                discard = true;
            }
            console.error(`qbsql startTransaction failed: ${err.message}`);
            return false;
        } finally {
            clearTimeout(timeout);
            closed = true;
            // A stalled command can block ROLLBACK too; disconnect rather than reuse it.
            if (discard) conn.destroy();
            else conn.release();
        }
    }

    // batch: same pinned connection, sequential, NO transaction. Returns the
    // per-statement results.
    async batch(queries, maybeParams) {
        const statements = this._normalise(queries, maybeParams);
        const conn = await this.pools.write.getConnection();
        const results = [];
        try {
            for (const st of statements) {
                const [r] = await this._run(conn, st);
                results.push(r);
            }
            return results;
        } finally {
            conn.release();
        }
    }
}

module.exports = { TransactionRunner };
