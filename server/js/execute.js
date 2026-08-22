// Core query executors: the single code path every ad-hoc query flows through,
// with the prepared-statement fallback and stats recording centralised here.
//
// Every public executor (query/single/scalar/execute/insert/update) is a thin
// shape-adapter over runOne(). runOne() is where the prepare-or-fallback
// decision, the timing, and the stats recording live -- exactly once.

'use strict';

const { isUnpreparableError } = require('./statements');
const log = require('./logger');

class Executor {
    constructor(pools, statements, stats) {
        this.pools = pools;
        this.statements = statements;
        this.stats = stats;
    }

    // Choose the pool. Writes and anything ambiguous go to the write pool; only
    // statements that are unambiguously reads go to the read pool. A leading
    // SELECT or SHOW or WITH is the cheap, safe heuristic; a false negative
    // (a read sent to the write pool) costs nothing but a little scheduling.
    _poolFor(sql) {
        const head = sql.slice(0, 8).toLowerCase().trimStart();
        if (head.startsWith('select') || head.startsWith('show') || head.startsWith('with') || head.startsWith('desc')) {
            return this.pools.read;
        }
        return this.pools.write;
    }

    // The one true executor. Returns the raw mysql2 [rows|result, fields].
    async runOne(sql, params, resource) {
        const pool = this._poolFor(sql);
        const started = process.hrtime.bigint();
        let errored = false;
        let rowCount = 0;

        try {
            let result;
            if (this.statements.isPreparable(sql)) {
                try {
                    result = await pool.execute(sql, params || []);
                    this.statements.recordHit(sql);
                } catch (err) {
                    if (isUnpreparableError(err)) {
                        // Pay the failed prepare ONCE: remember this text is
                        // unpreparable, then fall back to the text protocol.
                        this.statements.markUnpreparable(sql);
                        log.debug('execute', `unpreparable, falling back to query(): ${sql}`);
                        result = await pool.query(sql, params || []);
                    } else {
                        throw err;
                    }
                }
            } else {
                result = await pool.query(sql, params || []);
                this.statements.recordMiss(sql);
            }

            const rows = result[0];
            rowCount = Array.isArray(rows) ? rows.length : 0;
            return rows;
        } catch (err) {
            errored = true;
            throw err;
        } finally {
            const ms = Number(process.hrtime.bigint() - started) / 1e6;
            this.stats.record(sql, ms, rowCount, errored, resource);
        }
    }

    async query(sql, params, resource) {
        const rows = await this.runOne(sql, params, resource);
        return Array.isArray(rows) ? rows : [];
    }

    async single(sql, params, resource) {
        const rows = await this.runOne(sql, params, resource);
        return Array.isArray(rows) && rows.length ? rows[0] : null;
    }

    // The first column of the first row -- oxmysql's `scalar`.
    async scalar(sql, params, resource) {
        const rows = await this.runOne(sql, params, resource);
        if (!Array.isArray(rows) || !rows.length) return null;
        const first = rows[0];
        const keys = Object.keys(first);
        return keys.length ? first[keys[0]] : null;
    }

    // execute() returns the OkPacket shape oxmysql callers expect.
    async execute(sql, params, resource) {
        const result = await this.runOne(sql, params, resource);
        // For a write, mysql2 returns an OkPacket (not an array) as result[0].
        if (Array.isArray(result)) {
            // It was actually a SELECT-shaped call; still hand back a rows-ish
            // shape so callers that misuse execute() for reads don't crash.
            return { affectedRows: 0, insertId: 0, changedRows: 0, warningStatus: 0, rows: result };
        }
        return {
            affectedRows: result.affectedRows || 0,
            insertId: result.insertId || 0,
            changedRows: result.changedRows || 0,
            warningStatus: result.warningStatus || 0,
        };
    }

    async insert(sql, params, resource) {
        const r = await this.execute(sql, params, resource);
        return r.insertId;
    }

    async update(sql, params, resource) {
        const r = await this.execute(sql, params, resource);
        return r.affectedRows;
    }
}

module.exports = { Executor };
