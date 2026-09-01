// Transaction and batch runners on a single pinned connection.
//
// oxmysql exposes two related shapes and this module backs both:
//   * transaction(statements)         -- run all inside BEGIN/COMMIT, rollback on any error
//   * transaction(sql, [paramsList])  -- one statement, many parameter sets, all in one txn
//   * batch(statements)               -- same connection, NO transaction wrapper
// The "one query, many param sets" form is the one people most often forget is
// supported (see docs.md); it maps cleanly onto looping the same prepared
// statement on the pinned connection.

'use strict';

const { normalizeParams, normalizeNamedPlaceholders } = require('./execute');

class TransactionRunner {
    constructor(pools) {
        this.pools = pools;
    }

    // Normalise oxmysql's two argument shapes into an array of {sql, params}.
    //
    // These run through conn.execute() on a pinned connection rather than the
    // Executor, so normalizeParams has to be applied here too -- otherwise a
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
        try {
            await conn.beginTransaction();
            for (const st of statements) {
                await conn.query(st.sql, st.params);
            }
            await conn.commit();
            return true;
        } catch (err) {
            try { await conn.rollback(); } catch (_) { /* connection may be dead */ }
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
            conn.release();
        }
    }

    // Experimental oxmysql startTransaction contract. The callback receives a
    // query function pinned to this connection and decides whether to commit
    // (anything except explicit false) or roll back (false). A 30s deadline
    // matches oxmysql and prevents a leaked callback from pinning a pool slot.
    async startTransaction(callback) {
        if (typeof callback !== 'function') throw new TypeError('startTransaction requires a callback');

        const conn = await this.pools.write.getConnection();
        let closed = false;
        const timeout = setTimeout(() => { closed = true; }, 30000);
        try {
            await conn.beginTransaction();
            const query = async (sql, params = []) => {
                if (closed) throw new Error('Connection used by transaction timed out after 30 seconds.');
                const normalized = normalizeNamedPlaceholders(sql, params);
                const [result] = await conn.query(normalized.sql, normalizeParams(normalized.params));
                return result;
            };
            const shouldCommit = await callback(query);
            if (closed) throw new Error('Transaction has timed out after 30 seconds.');
            if (shouldCommit === false) {
                await conn.rollback();
                return false;
            }
            await conn.commit();
            return true;
        } catch (err) {
            try { await conn.rollback(); } catch (_) { /* connection may be dead */ }
            console.error(`qbsql startTransaction failed: ${err.message}`);
            return false;
        } finally {
            clearTimeout(timeout);
            closed = true;
            conn.release();
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
                const [r] = await conn.execute(st.sql, st.params);
                results.push(r);
            }
            return results;
        } finally {
            conn.release();
        }
    }
}

module.exports = { TransactionRunner };
