'use strict';

const { isUnpreparableError } = require('./statements');
const log = require('./logger');
const { typeCast, typeCastExecute } = require('./typecast');

const NULL_SENTINEL = '\u0000qbsql:null\u0000';

function normalizeParams(params) {
    if (params === null || params === undefined) return [];

    let arr = params;
    if (!Array.isArray(params)) {
        if (typeof params !== 'object') return [params];
        const keys = Object.keys(params);
        if (keys.length === 0) return [];
        if (!keys.every((k) => /^[0-9]+$/.test(k))) return params;
        const max = Math.max(...keys.map(Number));
        arr = new Array(max).fill(null);
        for (const k of keys) arr[Number(k) - 1] = params[k];
    }

    return Array.from(arr, (v) => (v === undefined || v === NULL_SENTINEL ? null : v));
}

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

function hasNoBinds(params) {
    return Array.isArray(params) && params.length === 0;
}

function isPlainObject(v) {
    if (v === null || typeof v !== 'object') return false;
    const proto = Object.getPrototypeOf(v);
    return proto === Object.prototype || proto === null;
}
function needsTextProtocol(params) {
    if (!params || typeof params !== 'object') return false;
    const values = Array.isArray(params) ? params : Object.values(params);
    return values.some((v) => Array.isArray(v) || isPlainObject(v));
}

function encodeTextValue(v, depth) {
    if (isPlainObject(v)) return JSON.stringify(v);
    if (Array.isArray(v) && depth < 2) return v.map((x) => encodeTextValue(x, depth + 1));
    return v;
}
function textParams(params) {
    if (Array.isArray(params)) return params.map((v) => encodeTextValue(v, 0));
    if (isPlainObject(params)) {
        const out = {};
        for (const [k, v] of Object.entries(params)) out[k] = encodeTextValue(v, 0);
        return out;
    }
    return params;
}

async function runOnConnection(conn, sql, params, statements) {
    if (!hasNoBinds(params) && !needsTextProtocol(params) && (!statements || statements.isPreparable(sql))) {
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
    return conn.query(sql, textParams(params));
}

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
        this.readTimeout = 0;
    }

    withOxTypeCast() {
        if (!this._oxView) {
            this._oxView = Object.create(this);
            this._oxView._oxTypeCast = true;
        }
        return this._oxView;
    }

    _poolFor(sql) {
        const head = sql.slice(0, 8).toLowerCase().trimStart();
        if (head.startsWith('select') || head.startsWith('show') || head.startsWith('with') || head.startsWith('desc')) {
            return this.pools.read;
        }
        return this.pools.write;
    }

    _args(pool, sql, params, cast) {
        const timeout = pool === this.pools.read && this.readTimeout > 0 ? this.readTimeout : 0;
        if (!cast && !timeout) return [sql, params];
        const options = { sql, values: params };
        if (cast) options.typeCast = cast;
        if (timeout) options.timeout = timeout;
        return [options];
    }

    _query(pool, sql, params, cast) {
        return pool.query(...this._args(pool, sql, textParams(params), this._oxTypeCast ? (cast || typeCast) : null));
    }

    _execute(pool, sql, params) {
        return pool.execute(...this._args(pool, sql, params, this._oxTypeCast ? typeCastExecute : null));
    }

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
                result = await this._query(pool, sql, params, typeCastExecute);
            } else if (this.statements.isPreparable(sql)) {
                try {
                    result = await this._execute(pool, sql, params);
                    this.statements.recordHit(sql);
                } catch (err) {
                    if (isUnpreparableError(err)) {
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
        return rows ?? null;
    }

    async single(sql, params, resource) {
        const rows = await this.runOne(sql, params, resource);
        return Array.isArray(rows) && rows.length ? rows[0] : null;
    }

    async scalar(sql, params, resource) {
        const rows = await this.runOne(sql, params, resource);
        if (!Array.isArray(rows) || !rows.length) return null;
        const first = rows[0];
        const keys = Object.keys(first);
        return keys.length ? first[keys[0]] : null;
    }

    async execute(sql, params, resource) {
        const result = await this.runOne(sql, params, resource);
        if (Array.isArray(result)) {
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

    async prepare(sql, params, resource) {
        const sets = toParamSets(params);
        const responses = [];

        for (const values of sets) {
            const result = await this.runOne(sql, values, resource);
            const verb = sql.trimStart().split(/\s+/, 1)[0].toUpperCase();
            if (verb === 'INSERT') responses.push(result.insertId || 0);
            else if (verb === 'UPDATE' || verb === 'DELETE') responses.push(result.affectedRows || 0);
            else if (Array.isArray(result) && result.length > 1) responses.push(...result);
            else if (Array.isArray(result)) {
                const row = result[0] || null;
                if (row && Object.keys(row).length === 1) responses.push(Object.values(row)[0]);
                else responses.push(row);
            } else responses.push(result);
        }

        return responses.length === 1 ? responses[0] : responses;
    }

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

module.exports = { Executor, normalizeParams, normalizeNamedPlaceholders, runOnConnection, hasNoBinds, needsTextProtocol, textParams, NULL_SENTINEL };
