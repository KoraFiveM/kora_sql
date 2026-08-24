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

const { normalizeParams } = require('./execute');

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
            return paramSets.map((params) => ({ sql, params: normalizeParams(params) }));
        }
        // transaction([ {query|sql, values|params}, ... ])
        return queries.map((q) => ({
            sql: q.query || q.sql,
            params: normalizeParams(q.values || q.params),
        }));
    }

    async transaction(queries, maybeParams) {
        const statements = this._normalise(queries, maybeParams);
        const conn = await this.pools.write.getConnection();
        try {
            await conn.beginTransaction();
            for (const st of statements) {
                await conn.execute(st.sql, st.params);
            }
            await conn.commit();
            return true;
        } catch (err) {
            try { await conn.rollback(); } catch (_) { /* connection may be dead */ }
            throw err;
        } finally {
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
