// Core query executors: the single code path every ad-hoc query flows through,
// with the prepared-statement fallback and stats recording centralised here.
//
// Every public executor (query/single/scalar/execute/insert/update) is a thin
// shape-adapter over runOne(). runOne() is where the prepare-or-fallback
// decision, the timing, and the stats recording live -- exactly once.

'use strict';

const { isUnpreparableError } = require('./statements');
const log = require('./logger');
const { typeCast, typeCastExecute } = require('./typecast');

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

// True when a call supplies no bind values at all. Such SQL is either
// placeholder-free (usually a literal-concatenated legacy statement) or broken
// either way, so it goes over the text protocol: one round trip instead of
// PREPARE + EXECUTE, and no per-connection prepared-statement cache entry for
// a text that may never be seen again.
function hasNoBinds(params) {
    return Array.isArray(params) && params.length === 0;
}

// Run one statement on a pinned connection (transactions, batch). Same
// policy as Executor.runRaw: bound statements use the binary protocol, where
// bind values are inert, with the unpreparable fallback paid once per text;
// parameter-less statements use the text protocol. The text path runs with
// the pools' `stringifyObjects`, so an object bind is never expanded into
// `col = value` assignments.
async function runOnConnection(conn, sql, params, statements) {
    if (!hasNoBinds(params) && (!statements || statements.isPreparable(sql))) {
        try {
            const result = await conn.execute(sql, params);
            if (statements) statements.recordHit(sql);
            return result;
        } catch (err) {
            if (!isUnpreparableError(err)) throw err;
            if (statements) statements.markUnpreparable(sql);
            log.debug('execute', `unpreparable, falling back to query(): ${sql}`);
        }
    }
    return conn.query(sql, params);
}

// oxmysql's prepare/rawExecute accept one parameter list or an array of lists.
function toParamSets(params) {
    const normal = normalizeParams(params);
    return Array.isArray(normal) && normal.length > 0 && normal.every(Array.isArray)
        ? normal.map(normalizeParams)
        : [normal];
}

class Executor {
    constructor(pools, statements, stats, legacyInventory = null, legacyHousing = null) {
        this.pools = pools;
        this.statements = statements;
        this.stats = stats;
        this.legacyInventory = legacyInventory;
        this.legacyHousing = legacyHousing;
        // Client-side timeout (ms) for statements routed to the READ pool; 0
        // disables it. Writes are never timed out client-side: the caller
        // would be told "failed" while the write may still commit.
        this.readTimeout = 0;
    }

    // A view of this executor whose queries apply oxmysql's typeCast (booleans,
    // date-as-ms, binary blobs, JSON strings). Only the oxmysql compatibility
    // export path uses it; the native executor's result shapes are unchanged.
    // WARNING: the view is Object.create(this), so reads fall through to the
    // base executor but any instance-field WRITE (this.x = ...) made while
    // running on the view lands on the view and is invisible to the base (and
    // vice versa for later replacement). Executor methods must mutate shared
    // state only through objects (pools/statements/stats), never by assigning
    // new values to fields on `this`.
    withOxTypeCast() {
        if (!this._oxView) {
            this._oxView = Object.create(this);
            this._oxView._oxTypeCast = true;
        }
        return this._oxView;
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

    // Build mysql2's call arguments. The positional form is kept when no
    // per-call option applies, so plain calls stay identical to before.
    _args(pool, sql, params, cast) {
        const timeout = pool === this.pools.read && this.readTimeout > 0 ? this.readTimeout : 0;
        if (!cast && !timeout) return [sql, params];
        const options = { sql, values: params };
        if (cast) options.typeCast = cast;
        if (timeout) options.timeout = timeout;
        return [options];
    }

    // Text protocol. `cast` defaults to the full oxmysql text typeCast, which
    // the unpreparable fallback has always used.
    _query(pool, sql, params, cast) {
        return pool.query(...this._args(pool, sql, params, this._oxTypeCast ? (cast || typeCast) : null));
    }

    _execute(pool, sql, params) {
        return pool.execute(...this._args(pool, sql, params, this._oxTypeCast ? typeCastExecute : null));
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
            } else if (hasNoBinds(params)) {
                // Text protocol, no StatementCache entry (see hasNoBinds). The
                // execute-path cast keeps oxmysql result shapes identical to
                // what the same statement returned when it was prepared.
                result = await this._query(pool, sql, params, typeCastExecute);
            } else if (this.statements.isPreparable(sql)) {
                try {
                    result = await this._execute(pool, sql, params);
                    this.statements.recordHit(sql);
                } catch (err) {
                    if (isUnpreparableError(err)) {
                        // Pay the failed prepare ONCE: remember this text is
                        // unpreparable, then fall back to the text protocol.
                        this.statements.markUnpreparable(sql);
                        log.debug('execute', `unpreparable, falling back to query(): ${sql}`);
                        result = await this._query(pool, sql, params);
                    } else {
                        throw err;
                    }
                }
            } else {
                result = await this._query(pool, sql, params);
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
        const sets = toParamSets(params);
        const responses = [];

        for (const values of sets) {
            const result = await this.runOne(sql, values, resource);
            const verb = sql.trimStart().split(/\s+/, 1)[0].toUpperCase();
            if (verb === 'INSERT') responses.push(result.insertId || 0);
            else if (verb === 'UPDATE' || verb === 'DELETE') responses.push(result.affectedRows || 0);
            // Like oxmysql, a multi-row SELECT returns every row, not just the first.
            else if (Array.isArray(result) && result.length > 1) responses.push(...result);
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
        const sets = toParamSets(params);
        const responses = [];

        for (const values of sets) {
            const result = await this.runOne(sql, values, resource);
            if (Array.isArray(result) && result.length > 1) responses.push(...result);
            else responses.push(result);
        }
        return responses.length === 1 ? responses[0] : responses;
    }
}

module.exports = { Executor, normalizeParams, normalizeNamedPlaceholders, runOnConnection, hasNoBinds, NULL_SENTINEL };
