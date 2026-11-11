'use strict';

const { normalizeParams, normalizeNamedPlaceholders, runOnConnection } = require('./execute');

class TransactionRunner {
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

    _normalise(queries, maybeParams) {
        if (typeof queries === 'string') {
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
            try { await conn.rollback(); } catch (_) { discard = true; }
            console.error(`kora_sql transaction rolled back: ${err.message}`);
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
            console.error(`kora_sql startTransaction failed: ${err.message}`);
            return false;
        } finally {
            clearTimeout(timeout);
            closed = true;
            if (discard) conn.destroy();
            else conn.release();
        }
    }

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
