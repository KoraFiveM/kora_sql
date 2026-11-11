'use strict';

const batch = require('./batch');
const log = require('./logger');
const crypto = require('crypto');
const { isIdent } = require('./ident');

function invalid(reason, message) {
    const err = new TypeError(message);
    err.reason = reason;
    return err;
}

const NULL_SENTINEL = '\u0000kora_sql:null\u0000';
function normalizeWriteParams(params) {
    return Array.from(params, (value) =>
        value === undefined || value === NULL_SENTINEL ? null : value);
}

function pkComponent(value) {
    if (typeof value === 'string') return value;
    if (typeof value === 'number') {
        if (Number.isFinite(value)) return String(value);
    } else if (typeof value === 'bigint') {
        return String(value);
    } else if (typeof value === 'boolean') {
        return value ? '1' : '0';
    }
    throw invalid('bad-pk', `kora_sql/queue: primary key values must be strings or finite numbers (got ${value === null || value === undefined ? 'nil' : typeof value === 'number' ? String(value) : typeof value})`);
}

function pkKey(pk) {
    return JSON.stringify(Array.isArray(pk) ? pk.map(pkComponent) : [pkComponent(pk)]);
}

const DEADLETTER_PK_MAX = 191;
function deadLetterPk(pk) {
    let text;
    try {
        text = Array.isArray(pk) ? JSON.stringify(pk.map(pkComponent)) : pkComponent(pk);
    } catch (_) {
        text = String(pk);
    }
    if (text.length <= DEADLETTER_PK_MAX) return text;
    const hash = crypto.createHash('sha256').update(text).digest('hex').slice(0, 40);
    return `${text.slice(0, DEADLETTER_PK_MAX - 45)}~sha:${hash}`;
}

function safeJson(value) {
    try {
        return JSON.stringify(value, (_k, v) => (typeof v === 'bigint' ? String(v) : v));
    } catch (err) {
        return JSON.stringify({ unserialisable: String(err && err.message) });
    }
}

const DECIMAL = /^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/;
function accumulateValue(table, column, value) {
    if (typeof value === 'number' && Number.isFinite(value)) return value;
    if (typeof value === 'string' && DECIMAL.test(value)) {
        const n = Number(value);
        if (Number.isFinite(n)) return n;
    }
    throw invalid('accumulate-value', `kora_sql/queue: accumulate mode needs a finite number for ${table}.${column} (got ${typeof value === 'string' ? `'${value.slice(0, 32)}'` : String(value)})`);
}

const STATEMENT_LEVEL_WRITE_ERRORS = new Set([
    'ER_BAD_FIELD_ERROR', 'ER_NO_SUCH_TABLE', 'ER_BAD_TABLE_ERROR', 'ER_PARSE_ERROR',
    'ER_WRONG_VALUE_COUNT_ON_ROW', 'ER_NON_UNIQ_ERROR',
    'ER_TABLEACCESS_DENIED_ERROR', 'ER_COLUMNACCESS_DENIED_ERROR',
]);
const NO_SUCH_TABLE_RETRIES = 2;
const NO_SUCH_TABLE_BACKOFF_MS = 1000;
const MAX_DEADLETTER_ATTEMPTS = 3;
const DETERMINISTIC_WRITE_ERRORS = new Set([
    ...STATEMENT_LEVEL_WRITE_ERRORS,
    'ER_DATA_TOO_LONG', 'ER_TRUNCATED_WRONG_VALUE', 'ER_TRUNCATED_WRONG_VALUE_FOR_FIELD',
    'ER_WARN_DATA_OUT_OF_RANGE', 'ER_DATA_OUT_OF_RANGE', 'WARN_DATA_TRUNCATED',
    'ER_BAD_NULL_ERROR', 'ER_NO_DEFAULT_FOR_FIELD', 'ER_DUP_ENTRY',
    'ER_NO_REFERENCED_ROW', 'ER_NO_REFERENCED_ROW_2', 'ER_ROW_IS_REFERENCED', 'ER_ROW_IS_REFERENCED_2',
    'ER_CHECK_CONSTRAINT_VIOLATED', 'ER_CONSTRAINT_FAILED', 'ER_INVALID_JSON_TEXT',
    'ER_INVALID_JSON_TEXT_IN_PARAM', 'ER_WRONG_VALUE_COUNT_ON_ROW', 'ER_WRONG_VALUE_FOR_TYPE',
    'ER_NON_UNIQ_ERROR', 'ER_TABLEACCESS_DENIED_ERROR', 'ER_COLUMNACCESS_DENIED_ERROR',
]);
function isRetryableWriteError(err) {
    if (!err || err.fatal) return true;
    return !DETERMINISTIC_WRITE_ERRORS.has(err.code);
}

function sortableComponent(value) {
    if (typeof value === 'number') return value;
    if (typeof value === 'string' && /^-?\d{1,15}$/.test(value)) return Number(value);
    return String(value);
}
function comparePk(a, b) {
    const pa = Array.isArray(a.pk) ? a.pk : [a.pk];
    const pb = Array.isArray(b.pk) ? b.pk : [b.pk];
    for (let i = 0; i < pa.length; i++) {
        const x = sortableComponent(pa[i]);
        const y = sortableComponent(pb[i]);
        if (x === y) continue;
        const xn = typeof x === 'number', yn = typeof y === 'number';
        if (xn !== yn) return xn ? -1 : 1;
        return x < y ? -1 : 1;
    }
    return 0;
}

function hasUniqueIndexOn(rows, keyCols) {
    const want = new Set(keyCols.map((c) => c.toLowerCase()));
    const indexes = new Map();
    for (const row of rows || []) {
        const name = row.INDEX_NAME;
        if (!indexes.has(name)) indexes.set(name, new Set());
        indexes.get(name).add(String(row.COLUMN_NAME).toLowerCase());
    }
    for (const cols of indexes.values()) {
        if (cols.size > 0 && [...cols].every((c) => want.has(c))) return true;
    }
    return false;
}

function colsEqual(a, b) {
    const ak = Object.keys(a);
    if (ak.length !== Object.keys(b).length) return false;
    for (const k of ak) {
        if (a[k] !== b[k]) return false;
    }
    return true;
}

class WriteQueue {
    constructor(executor, pools, stats, cfg) {
        this.executor = executor;
        this.pools = pools;
        this.stats = stats;
        this.cfg = cfg;

        this.pending = new Map();
        this.pendingRowCount = 0;

        this.timer = null;
        this.dialect = batch.dialectFor(pools.version);
        this.verifiedKeys = new Set();
        this.verifyFailures = new Map();
        this.warnedRejects = new Set();
    }

    _pool() {
        return this.pools.flush || this.pools.write;
    }

    _tableState(table, conflictKey, mode, writeMode) {
        let st = this.pending.get(table);
        if (!st) {
            st = {
                conflictKey, mode, writeMode, rows: new Map(),
                poison: new Map(),
                generation: 0, completedGeneration: 0, flushing: false, inFlight: null,
            };
            this.pending.set(table, st);
        } else if (st.mode !== mode || st.writeMode !== writeMode || JSON.stringify(st.conflictKey) !== JSON.stringify(conflictKey)) {
            if (st.rows.size > 0 || st.inFlight) {
                throw invalid('incompatible-options', `kora_sql/queue: incompatible queue options for table ${table} while writes are pending.`);
            }
            st.conflictKey = conflictKey;
            st.mode = mode;
            st.writeMode = writeMode;
        }
        this._verifyConflictKey(table, conflictKey);
        return st;
    }

    _verifyConflictKey(table, keyCols) {
        if (!this.cfg.verifyConflictKeys) return;
        const id = `${table}|${keyCols.join(',')}`;
        if (this.verifiedKeys.has(id)) return;
        this.verifiedKeys.add(id);
        const pool = this.pools.read || this.pools.write;
        Promise.resolve()
            .then(() => pool.query(
                'SELECT INDEX_NAME, COLUMN_NAME FROM information_schema.STATISTICS ' +
                'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND NON_UNIQUE = 0', [table]))
            .then(([rows]) => {
                if (hasUniqueIndexOn(rows, keyCols)) return;
                log.warn('queue',
                    `conflict key (${keyCols.join(', ')}) on ${table} is not a PRIMARY or UNIQUE index: ` +
                    'upserts will insert duplicate rows instead of updating, and update writes scan the table.');
            })
            .then(() => this.verifyFailures.delete(id))
            .catch((err) => {
                const failures = (this.verifyFailures.get(id) || 0) + 1;
                this.verifyFailures.set(id, failures);
                if (failures < 3) this.verifiedKeys.delete(id);
                log.debug('queue', `could not verify the conflict key of ${table}: ${err.message}`);
            });
    }

    _checkTarget(table, conflictKey, opts) {
        if (!isIdent(table)) throw invalid('bad-table', `kora_sql/queue: invalid table name '${table}'`);
        const keyCols = Array.isArray(conflictKey) ? conflictKey : [conflictKey];
        if (keyCols.length === 0 || !keyCols.every(isIdent)) {
            throw invalid('bad-key', `kora_sql/queue: invalid conflict key for ${table}`);
        }
        const mode = opts.mode || 'assign';
        if (mode !== 'assign' && mode !== 'accumulate') throw invalid('bad-mode', `kora_sql/queue: unsupported mode '${mode}'.`);
        const writeMode = opts.writeMode || 'upsert';
        if (writeMode !== 'upsert' && writeMode !== 'update') {
            throw invalid('bad-write-mode', `kora_sql/queue: unsupported writeMode '${writeMode}'.`);
        }
        let allowed = null;
        if (opts.allowedColumns !== undefined && opts.allowedColumns !== null) {
            if (!Array.isArray(opts.allowedColumns)) throw invalid('bad-allowed-columns', 'kora_sql/queue: allowedColumns must be a list of column names');
            allowed = new Set(opts.allowedColumns.map((c) => String(c).toLowerCase()));
        }
        return { keyCols, mode, writeMode, allowed };
    }

    _prepareRow(table, target, row) {
        if (!row || typeof row !== 'object' || !row.cols || typeof row.cols !== 'object' || Array.isArray(row.cols)) {
            throw invalid('bad-row', `kora_sql/queue: rows for ${table} must be { pk = ..., cols = { ... } }`);
        }
        const { keyCols, mode, allowed } = target;
        if (Array.isArray(row.pk) ? row.pk.length !== keyCols.length : keyCols.length !== 1) {
            throw invalid('pk-arity', `kora_sql/queue: ${table} needs ${keyCols.length} primary key value(s) per row`);
        }
        const key = pkKey(row.pk);
        const keySet = new Set(keyCols.map((c) => c.toLowerCase()));
        const cols = {};
        const names = Object.keys(row.cols);
        if (names.length === 0) throw invalid('no-columns', `kora_sql/queue: a row for ${table} has no columns to write`);
        for (const name of names) {
            if (!isIdent(name)) throw invalid('bad-column', `kora_sql/queue: invalid column name '${name}' for ${table}`);
            const lower = name.toLowerCase();
            if (keySet.has(lower)) throw invalid('key-column', `kora_sql/queue: ${table}.${name} is a conflict key column and cannot be written`);
            if (allowed && !allowed.has(lower)) throw invalid('not-allowed', `kora_sql/queue: column ${table}.${name} is not in allowedColumns`);
            cols[name] = mode === 'accumulate' ? accumulateValue(table, name, row.cols[name]) : row.cols[name];
        }
        return { key, pk: row.pk, cols };
    }

    _merge(table, target, prepared) {
        const st = this._tableState(table, target.keyCols, target.mode, target.writeMode);
        for (const row of prepared) {
            const existing = st.rows.get(row.key);
            if (existing) {
                if (target.mode === 'accumulate') {
                    for (const c of Object.keys(row.cols)) {
                        existing.cols[c] = (existing.cols[c] || 0) + row.cols[c];
                    }
                } else {
                    Object.assign(existing.cols, row.cols);
                }
            } else {
                st.rows.set(row.key, { pk: row.pk, cols: row.cols });
                this.pendingRowCount++;
            }
        }
    }

    _reject(resource, table, err, rows) {
        const reason = err.reason || 'error';
        if (this.stats.queue) this.stats.queue.rejectedRows = (this.stats.queue.rejectedRows || 0) + rows;
        const id = `${resource || '?'}|${reason}`;
        if (this.warnedRejects.has(id)) return;
        if (this.warnedRejects.size > 1000) this.warnedRejects.clear();
        this.warnedRejects.add(id);
        log.error('queue',
            `dropped ${rows} invalid row(s) for ${table} from ${resource || 'an unknown resource'}: ${err.message} ` +
            '(the rest of the call was queued; logged once per resource and reason)');
    }

    _enqueue(table, conflictKey, rows, opts, resource, strict) {
        let target;
        try {
            target = this._checkTarget(table, conflictKey, opts);
        } catch (err) {
            if (strict) throw err;
            this._reject(resource, table, err, rows.length);
            return { queued: 0, dropped: rows.length };
        }
        const prepared = [];
        let dropped = 0;
        for (const row of rows) {
            try {
                prepared.push(this._prepareRow(table, target, row));
            } catch (err) {
                if (strict) throw err;
                dropped++;
                this._reject(resource, table, err, 1);
            }
        }
        if (prepared.length === 0) return { queued: 0, dropped };
        try {
            this._merge(table, target, prepared);
        } catch (err) {
            if (strict) throw err;
            this._reject(resource, table, err, prepared.length);
            return { queued: 0, dropped: dropped + prepared.length };
        }
        this._scheduleOrTrip(opts.priority === 'immediate' ? table : null);
        return { queued: prepared.length, dropped };
    }

    enqueue(table, conflictKey, row, opts, resource) {
        return this._enqueue(table, conflictKey, [row], opts || {}, resource, false);
    }

    enqueueMany(table, conflictKey, rows, opts, resource) {
        opts = opts || {};
        const strict = opts.strict === true;
        this.stats.countCrossing();
        if (rows && !Array.isArray(rows) && typeof rows === 'object' && Object.keys(rows).length === 0) rows = [];
        if (!Array.isArray(rows)) {
            const err = invalid('not-a-list', `kora_sql/queue: enqueueMany for ${table} needs a list of rows`);
            if (strict) throw err;
            this._reject(resource, table, err, 1);
            return { queued: 0, dropped: 1 };
        }
        if (rows.length === 0) return { queued: 0, dropped: 0 };
        return this._enqueue(table, conflictKey, rows, opts, resource, strict);
    }

    _scheduleOrTrip(immediateTable) {
        if (immediateTable) {
            this.flush(immediateTable).catch((e) =>
                log.error('queue', `immediate flush failed: ${e.message}`));
            return;
        }
        if (this.pendingRowCount >= this.cfg.maxPendingRows) {
            this.flush().catch((e) => log.error('queue', `high-water flush failed: ${e.message}`));
            return;
        }
        this._ensureTimer();
    }

    _ensureTimer() {
        if (!this.timer) {
            this.timer = setTimeout(() => {
                this.timer = null;
                this.flush().catch((e) => log.error('queue', `interval flush failed: ${e.message}`));
            }, this.cfg.flushInterval);
            if (this.timer.unref) this.timer.unref();
        }
    }

    async flush(onlyTable) {
        const tables = onlyTable ? [onlyTable] : Array.from(this.pending.keys());
        let firstError;
        await Promise.all(tables.map((t) => this._flushTable(t).catch((err) => {
            if (!firstError) firstError = err;
        })));
        if (firstError) throw firstError;
    }

    async _flushTable(table) {
        const st = this.pending.get(table);
        if (!st) return;

        const target = st.generation + (st.rows.size > 0 ? 1 : 0);
        do {
            if (!st.inFlight) {
                if (st.rows.size === 0) return;
                const snapshot = st.rows;
                st.rows = new Map();
                st.generation++;
                st.flushing = true;
                this.pendingRowCount -= snapshot.size;

                st.inFlight = Promise.resolve()
                    .then(() => this._writeTable(table, st, snapshot))
                    .finally(() => {
                        st.inFlight = null;
                        if (st.rows.size > 0) this._ensureTimer();
                    });
            }
            await st.inFlight;
        } while (st.completedGeneration < target);
    }

    async _writeTable(table, st, snapshot) {
        const snapshotCount = snapshot.size;

        const started = process.hrtime.bigint();
        let statements = 0;
        let rowsWritten = 0;
        let firstError;

        try {
            const groups = new Map();
            for (const entry of snapshot.values()) {
                const columns = Object.keys(entry.cols).sort();
                const sig = columns.join(',');
                let g = groups.get(sig);
                if (!g) {
                    g = { columns, rows: [] };
                    groups.set(sig, g);
                }
                g.rows.push(entry);
            }

            const keyCount = Array.isArray(st.conflictKey) ? st.conflictKey.length : 1;
            for (const g of groups.values()) {
                g.rows.sort(comparePk);
                const perRow = st.writeMode === 'update'
                    ? g.columns.length * (keyCount + 1) + keyCount
                    : g.columns.length + keyCount;
                const perStatement = Math.min(
                    this.cfg.maxRowsPerStatement,
                    Math.max(1, Math.floor(this.cfg.maxPlaceholders / perRow))
                );
                for (let i = 0; i < g.rows.length; i += perStatement) {
                    const chunk = g.rows.slice(i, i + perStatement);
                    const result = await this._writeChunk(table, st, g.columns, chunk, perStatement);
                    statements += result.statements;
                    rowsWritten += result.rows;
                    if (result.error && !firstError) firstError = result.error;
                }
            }

            const ms = Number(process.hrtime.bigint() - started) / 1e6;
            this.stats.recordFlush(snapshotCount, rowsWritten, statements, ms);
            if (firstError) throw firstError;
            log.debug('queue', `flushed ${table}: ${snapshotCount} rows -> ${statements} statements in ${ms.toFixed(1)}ms`);
        } finally {
            st.completedGeneration = st.generation;
            st.flushing = false;
        }
    }

    async _writeChunk(table, st, columns, chunk, perStatement) {
        const builder = st.writeMode === 'update' ? batch.buildUpdate : batch.build;
        const { sql, params, rowCount } = builder(
            table, st.conflictKey, columns, chunk,
            {
                mode: st.mode,
                dialect: this.dialect,
                pad: this.cfg.padToBuckets && st.mode === 'assign' && batch.bucketFor(chunk.length) <= perStatement,
            }
        );
        try {
            await this._writeWithRetry(table, sql, params, chunk, st.mode);
            return { statements: 1, rows: rowCount, error: null };
        } catch (err) {
            if (!err.bisect) return { statements: 0, rows: 0, error: err };
            const mid = Math.ceil(chunk.length / 2);
            const out = { statements: 0, rows: 0, error: null };
            for (const half of [chunk.slice(0, mid), chunk.slice(mid)]) {
                const result = await this._writeChunk(table, st, columns, half, perStatement);
                out.statements += result.statements;
                out.rows += result.rows;
                if (result.error && !out.error) out.error = result.error;
            }
            return out;
        }
    }

    _hedge(table, chunk, reMerged) {
        const st = this.pending.get(table);
        for (const entry of chunk) {
            const key = pkKey(entry.pk);
            if (!st.rows.has(key)) {
                const staleCols = { ...entry.cols };
                st.rows.set(key, { pk: entry.pk, cols: { ...staleCols } });
                this.pendingRowCount++;
                if (!reMerged) reMerged = new Map();
                reMerged.set(key, staleCols);
            }
        }
        return reMerged;
    }

    _clearReMerged(table, reMerged, mode) {
        if (!reMerged || !reMerged.size) return;
        const st = this.pending.get(table);
        if (!st) return;

        for (const [key, staleCols] of reMerged) {
            const current = st.rows.get(key);
            if (!current) continue;
            if (colsEqual(current.cols, staleCols)) {
                st.rows.delete(key);
                this.pendingRowCount--;
            } else if (mode === 'accumulate') {
                for (const c of Object.keys(staleCols)) {
                    if (c in current.cols) {
                        current.cols[c] -= staleCols[c];
                        if (current.cols[c] === 0) delete current.cols[c];
                    }
                }
                if (Object.keys(current.cols).length === 0) {
                    st.rows.delete(key);
                    this.pendingRowCount--;
                }
            }
        }
    }

    _clearPoison(table, chunk) {
        const st = this.pending.get(table);
        if (!st || !st.poison || st.poison.size === 0) return;
        for (const entry of chunk) st.poison.delete(pkKey(entry.pk));
    }

    async _deadLetterAndRelease(table, chunk, err, reMerged, mode) {
        const failed = await this._deadLetter(table, chunk, err);
        this.stats.queue.deadLettered += chunk.length - failed.length;
        const st = this.pending.get(table);
        const keep = new Set();
        for (const entry of chunk) {
            const key = pkKey(entry.pk);
            if (!failed.includes(entry)) {
                if (st && st.poison) st.poison.delete(key);
                continue;
            }
            const count = ((st && st.poison && st.poison.get(key)) || 0) + 1;
            if (count >= MAX_DEADLETTER_ATTEMPTS) {
                if (st && st.poison) st.poison.delete(key);
                log.error('queue',
                    `DROPPED ${table} row ${deadLetterPk(entry.pk)} after ${count} failed dead-letter attempts ` +
                    `(${err && err.code}): cols_json=${safeJson(entry.cols)}`);
            } else {
                if (st && st.poison) st.poison.set(key, count);
                keep.add(key);
                log.warn('queue', `${table} row ${deadLetterPk(entry.pk)} stays pending; dead-letter attempt ${count}/${MAX_DEADLETTER_ATTEMPTS} failed`);
            }
        }
        if (reMerged && keep.size) {
            for (const key of keep) reMerged.delete(key);
        }
        this._clearReMerged(table, reMerged, mode);
        return failed.length;
    }

    _deadLetterError(table, what, chunk, failed) {
        return new Error(failed
            ? `kora_sql: write to ${table} failed ${what}; failed to dead-letter ${failed}/${chunk.length} row(s)`
            : `kora_sql: write to ${table} failed ${what}; ${chunk.length} row(s) were dead-lettered`);
    }

    async _writeWithRetry(table, sql, params, chunk, mode, attempt, reMerged) {
        attempt = attempt || 0;
        try {
            await this._pool().execute(sql, normalizeWriteParams(params));
            this._clearReMerged(table, reMerged, mode);
            this._clearPoison(table, chunk);
        } catch (err) {
            this.stats.queue.retries++;
            const noSuchTableRetry = err && err.code === 'ER_NO_SUCH_TABLE' && !err.fatal && attempt < NO_SUCH_TABLE_RETRIES;
            if (!isRetryableWriteError(err) && !noSuchTableRetry) {
                const statementLevel = STATEMENT_LEVEL_WRITE_ERRORS.has(err.code);
                if (chunk.length > 1 && !statementLevel) {
                    this._clearReMerged(table, reMerged, mode);
                    const split = new Error(`kora_sql: write to ${table} failed (${err.code}); bisecting ${chunk.length} rows`);
                    split.bisect = true;
                    split.cause = err;
                    throw split;
                }
                reMerged = this._hedge(table, chunk, reMerged);
                log.error('queue', `DEAD-LETTER on ${table} (${chunk.length} row(s), ${err.code} is not retryable): ${err.message}`);
                const failed = await this._deadLetterAndRelease(table, chunk, err, reMerged, mode);
                throw this._deadLetterError(table, `(${err.code})`, chunk, failed);
            }
            if (attempt >= 5) {
                log.error('queue',
                    `DEAD-LETTER after ${attempt} retries on ${table} (${chunk.length} rows): ${err.message}`);
                reMerged = this._hedge(table, chunk, reMerged);
                const failed = await this._deadLetterAndRelease(table, chunk, err, reMerged, mode);
                throw this._deadLetterError(table, `after ${attempt} retries`, chunk, failed);
            }
            reMerged = this._hedge(table, chunk, reMerged);
            const backoff = noSuchTableRetry
                ? NO_SUCH_TABLE_BACKOFF_MS * (attempt + 1)
                : Math.min(2000, 50 * Math.pow(2, attempt));
            log.warn('queue', `write failed on ${table} (attempt ${attempt + 1}), retrying in ${backoff}ms: ${err.message}`);
            await new Promise((r) => setTimeout(r, backoff));
            await this._writeWithRetry(table, sql, params, chunk, mode, attempt + 1, reMerged);
        }
    }

    async _deadLetter(table, chunk, err) {
        const head =
            'INSERT INTO `kora_sql_deadletter` (`table_name`,`pk`,`cols_json`,`error`,`failed_at`) VALUES ';
        const group = '(?,?,?,?,NOW())';
        const message = String(err && err.message).slice(0, 500);
        const rows = chunk.map((entry) => [String(table).slice(0, 64), deadLetterPk(entry.pk), safeJson(entry.cols), message]);
        if (rows.length > 1) {
            try {
                await this._pool().execute(head + rows.map(() => group).join(','), rows.flat());
                return [];
            } catch (e) {
                log.warn('queue', `multi-row dead-letter insert for ${table} failed (${e.message}); retrying row by row`);
            }
        }
        const failed = [];
        for (let i = 0; i < rows.length; i++) {
            try {
                await this._pool().execute(head + group, rows[i]);
            } catch (e) {
                log.error('queue', `dead-letter insert itself failed for ${table}/${rows[i][1]}: ${e.message}`);
                failed.push(chunk[i]);
            }
        }
        return failed;
    }

    depth() {
        const out = {};
        for (const [table, st] of this.pending) {
            out[table] = { rows: st.rows.size, generation: st.generation, flushing: st.flushing };
        }
        return out;
    }
}

module.exports = { WriteQueue, pkKey, comparePk, hasUniqueIndexOn, isRetryableWriteError, deadLetterPk, STATEMENT_LEVEL_WRITE_ERRORS };
