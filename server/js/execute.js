// Core query executors: the single code path every ad-hoc query flows through,
// with the prepared-statement fallback and stats recording centralised here.
//
// Every public executor (query/single/scalar/execute/insert/update) is a thin
// shape-adapter over runOne(). runOne() is where the prepare-or-fallback
// decision, the timing, and the stats recording live -- exactly once.

'use strict';

const { isUnpreparableError } = require('./statements');
const log = require('./logger');

// Keep in sync with Kora.sql.NULL in ../../init.lua.
const NULL_SENTINEL = '\u0000qbsql:null\u0000';

// Lua cannot store nil in a table, so an optional bind value leaves a gap.
// Depending on whether `#t` sees past it, msgpack delivers that gap either as
// a JS array containing `undefined` -- which mysql2 rejects outright with
// "Bind parameters must not contain undefined" -- or as a MAP keyed by the
// surviving 1-based indices. Normalise both shapes into a dense array here,
// at the single point every executor funnels through, so no caller can
// reintroduce the bug by forgetting a sentinel.
function normalizeParams(params) {
    if (params === null || params === undefined) return [];

    let arr = params;
    if (!Array.isArray(params)) {
        if (typeof params !== 'object') return [params];
        // A numeric-keyed map from a holed Lua array: rebuild it densely up to
        // the highest index so placeholders keep their positions.
        const keys = Object.keys(params);
        if (keys.length === 0) return [];
        if (!keys.every((k) => /^[0-9]+$/.test(k))) return params; // named placeholders
        const max = Math.max(...keys.map(Number));
        arr = new Array(max).fill(null);
        for (const k of keys) arr[Number(k) - 1] = params[k];
    }

    // Array.from, not arr.map: map() SKIPS holes in a sparse array, so a hole
    // would survive normalisation and reach mysql2 as undefined -- the exact
    // failure this function exists to prevent.
    return Array.from(arr, (v) => (v === undefined || v === NULL_SENTINEL ? null : v));
}

// oxmysql/mysql-async accept both :name and @name placeholders, including
// parameter maps whose keys themselves start with @/:. mysql2's native named
// placeholder compiler only understands :name. Convert @name outside quoted
// strings/comments and expose unprefixed keys without touching the caller's
// object.
function normalizeNamedPlaceholders(sql, params) {
    if (!params || Array.isArray(params) || typeof params !== 'object') {
        return { sql, params };
    }

    let out = sql;
    if (sql.includes('@')) {
        out = '';
        let state = 'code';
        for (let i = 0; i < sql.length; i++) {
            let c = sql[i];
            const next = sql[i + 1];
            if (state === 'code') {
                if (c === "'") state = 'single';
                else if (c === '"') state = 'double';
                else if (c === '`') state = 'backtick';
                else if (c === '-' && next === '-') state = 'line';
                else if (c === '#') state = 'line';
                else if (c === '/' && next === '*') state = 'block';
                else if (c === '@' && sql[i - 1] !== '@' && /[A-Za-z_]/.test(next || '')) c = ':';
            } else if (state === 'single' && c === "'" && sql[i - 1] !== '\\') state = 'code';
            else if (state === 'double' && c === '"' && sql[i - 1] !== '\\') state = 'code';
            else if (state === 'backtick' && c === '`') state = 'code';
            else if (state === 'line' && (c === '\n' || c === '\r')) state = 'code';
            else if (state === 'block' && c === '*' && next === '/') {
                out += '*/';
                i++;
                state = 'code';
                continue;
            }
            out += c;
        }
    }

    const normalized = { ...params };
    for (const [key, value] of Object.entries(params)) {
        if (key[0] === '@' || key[0] === ':') normalized[key.slice(1)] = value;
    }
    return { sql: out, params: normalized };
}

class Executor {
    constructor(pools, statements, stats, legacyInventory = null, legacyHousing = null) {
        this.pools = pools;
        this.statements = statements;
        this.stats = stats;
        this.legacyInventory = legacyInventory;
        this.legacyHousing = legacyHousing;
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

    // The one true executor. Returns mysql2's raw [rows|result, fields] pair.
    // Keeping the pair until the final shape adapter is important for
    // oxmysql.rawExecute, whose public contract deliberately exposes the raw
    // response rather than parseResponse's query/single/scalar projections.
    async runRaw(sql, params, resource) {
        ({ sql, params } = normalizeNamedPlaceholders(sql, params));
        params = normalizeParams(params);
        const pool = this._poolFor(sql);
        const started = process.hrtime.bigint();
        let errored = false;
        let rowCount = 0;

        try {
            let result;
            const legacy = (this.legacyHousing && this.legacyHousing(sql, params, resource))
                || (this.legacyInventory && this.legacyInventory(sql, params));
            if (legacy) {
                result = [await legacy, undefined];
            } else if (this.statements.isPreparable(sql)) {
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
            return result;
        } catch (err) {
            errored = true;
            throw err;
        } finally {
            const ms = Number(process.hrtime.bigint() - started) / 1e6;
            this.stats.record(sql, ms, rowCount, errored, resource);
        }
    }

    async runOne(sql, params, resource) {
        const result = await this.runRaw(sql, params, resource);
        return result[0];
    }

    async query(sql, params, resource) {
        const rows = await this.runOne(sql, params, resource);
        // oxmysql.query is not SELECT-only: INSERT/UPDATE/DELETE return their
        // ResultSetHeader. The old [] coercion silently discarded insertId and
        // affectedRows for legacy callers using query/execute/fetch aliases.
        return rows ?? null;
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

    // oxmysql's prepare API accepts either one parameter list or an array of
    // parameter lists, executes each set, and unpacks each response. This is
    // distinct from kora_sql's execute() OkPacket-shaped modern API.
    async prepare(sql, params, resource) {
        const normal = normalizeParams(params);
        const sets = Array.isArray(normal) && normal.length > 0 && normal.every(Array.isArray)
            ? normal.map(normalizeParams)
            : [normal];
        const responses = [];

        for (const values of sets) {
            const result = await this.runOne(sql, values, resource);
            const verb = sql.trimStart().split(/\s+/, 1)[0].toUpperCase();
            if (verb === 'INSERT') responses.push(result.insertId || 0);
            else if (verb === 'UPDATE' || verb === 'DELETE') responses.push(result.affectedRows || 0);
            else if (Array.isArray(result)) {
                const row = result[0] || null;
                if (row && Object.keys(row).length === 1) responses.push(Object.values(row)[0]);
                else responses.push(row);
            } else responses.push(result);
        }

        return responses.length === 1 ? responses[0] : responses;
    }

    // oxmysql.rawExecute is prepare without response unpacking. oxmysql's
    // connection wrapper has already removed mysql2's fields metadata by this
    // point, so expose result values (rows/ResultSetHeader), not our internal
    // [result, fields] transport pair. Multiple row/result sets are flattened
    // the same way upstream appends them to its response array.
    async rawExecute(sql, params, resource) {
        const normal = normalizeParams(params);
        const sets = Array.isArray(normal) && normal.length > 0 && normal.every(Array.isArray)
            ? normal.map(normalizeParams)
            : [normal];
        const responses = [];

        for (const values of sets) {
            const result = await this.runOne(sql, values, resource);
            if (Array.isArray(result) && result.length > 1) responses.push(...result);
            else responses.push(result);
        }
        return responses.length === 1 ? responses[0] : responses;
    }
}

module.exports = { Executor, normalizeParams, normalizeNamedPlaceholders, NULL_SENTINEL };
