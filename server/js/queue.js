// The write-coalescing queue -- the heart of the performance thesis.
//
// Callers enqueue per-row writes; the queue merges them BY PRIMARY KEY, and at
// flush time groups rows by their column signature and emits one batched upsert
// per group. N player saves over a flush window collapse into a handful of
// round trips and (from Lua's side) a single boundary crossing.
//
// THE CORRECTNESS-CRITICAL DESIGN DECISION: the pending map is keyed by PK, and
// the column signature is computed only at flush time. The tempting alternative
// -- keying by `table|sortedColumns` -- is a data-corruption bug: a player
// enqueued once as {money} and again as {money,position} would land in two
// buckets, producing two statements for one row with no ordering guarantee
// between them. Keying by PK and Object.assign-ing the column maps gives
// per-column last-write-wins and exactly one row per PK per flush.

'use strict';

const batch = require('./batch');
const log = require('./logger');
const crypto = require('crypto');
const { isIdent } = require('./ident');

// A validation failure in enqueue input. `reason` is a short stable code used
// to log each (resource, reason) once instead of once per row per save tick.
function invalid(reason, message) {
    const err = new TypeError(message);
    err.reason = reason;
    return err;
}

// Queue writes bypass Executor.runOne(), where normal ad-hoc queries turn
// sparse Lua arrays and the public NULL sentinel into real JS nulls. Do that
// conversion here too: otherwise a missing value in an upsert reaches mysql2
// as `undefined` and retries can never succeed.
const NULL_SENTINEL = '\u0000qbsql:null\u0000';
function normalizeWriteParams(params) {
    return Array.from(params, (value) =>
        value === undefined || value === NULL_SENTINEL ? null : value);
}

// One PK component in canonical string form. Numbers (and booleans, which
// mysql2 binds as 1/0) deliberately share a key with their string spelling:
// `1` and `'1'` address the same MySQL row, so they must merge into one pending
// entry rather than race as two rows in one statement. Anything else (null,
// objects, NaN) is not a usable key and is refused instead of String()-coerced
// into a collision such as '[object Object]'.
function pkComponent(value) {
    if (typeof value === 'string') return value;
    if (typeof value === 'number') {
        if (Number.isFinite(value)) return String(value);
    } else if (typeof value === 'bigint') {
        return String(value);
    } else if (typeof value === 'boolean') {
        return value ? '1' : '0';
    }
    throw invalid('bad-pk', `qbsql/queue: primary key values must be strings or finite numbers (got ${value === null || value === undefined ? 'nil' : typeof value === 'number' ? String(value) : typeof value})`);
}

// Serialise a PK (which may be composite -- an array) to a Map key. JSON array
// encoding is injective: no choice of component text can make two different
// keys serialise identically (the old '\x1f'-joined form could).
function pkKey(pk) {
    return JSON.stringify(Array.isArray(pk) ? pk.map(pkComponent) : [pkComponent(pk)]);
}

// The dead-letter `pk` column (varchar(191)): a scalar key stays readable as
// itself; a composite key is a JSON array of its canonical component strings,
// so its components stay unambiguous. Built from pkComponent, so a BigInt key
// cannot throw. A value too long for the column keeps a readable prefix plus a
// sha256 of the whole text, so the insert cannot fail with ER_DATA_TOO_LONG.
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

// JSON for the dead-letter `cols_json` column; BigInt values become strings
// instead of making JSON.stringify throw.
function safeJson(value) {
    try {
        return JSON.stringify(value, (_k, v) => (typeof v === 'bigint' ? String(v) : v));
    } catch (err) {
        return JSON.stringify({ unserialisable: String(err && err.message) });
    }
}

// Accumulate mode adds values in memory AND in SQL (`col = col + ?`). A string
// would concatenate in JS ('5' + '3' = '53'), so only finite numbers are
// accepted. A plain decimal string is converted, because a single unmerged
// '5' always worked through SQL's numeric `+` and callers may rely on that.
const DECIMAL = /^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/;
function accumulateValue(table, column, value) {
    if (typeof value === 'number' && Number.isFinite(value)) return value;
    if (typeof value === 'string' && DECIMAL.test(value)) {
        const n = Number(value);
        if (Number.isFinite(n)) return n;
    }
    throw invalid('accumulate-value', `qbsql/queue: accumulate mode needs a finite number for ${table}.${column} (got ${typeof value === 'string' ? `'${value.slice(0, 32)}'` : String(value)})`);
}

// Codes that retrying the same statement cannot fix. STATEMENT-level codes
// (missing table/column, parse error, privileges, wrong value count) fail for
// every row of a column-signature group alike, so the whole chunk is
// dead-lettered at once; bisecting them would cost ~2N failing statements and
// N log lines. ROW-level codes (a value the column rejects, a constraint) are
// bisected so only the offending rows dead-letter. Everything else (deadlocks,
// lock waits, lost connections, unknown errors) keeps the backoff-and-retry path.
const STATEMENT_LEVEL_WRITE_ERRORS = new Set([
    'ER_BAD_FIELD_ERROR', 'ER_NO_SUCH_TABLE', 'ER_BAD_TABLE_ERROR', 'ER_PARSE_ERROR',
    'ER_WRONG_VALUE_COUNT_ON_ROW', 'ER_NON_UNIQ_ERROR',
    'ER_TABLEACCESS_DENIED_ERROR', 'ER_COLUMNACCESS_DENIED_ERROR',
]);
// ER_NO_SUCH_TABLE at boot is often a race with a concurrent ensureTable, so
// it gets a few slower retries (about 3 s in total) before it dead-letters.
const NO_SUCH_TABLE_RETRIES = 2;
const NO_SUCH_TABLE_BACKOFF_MS = 1000;
// A row whose dead-letter insert also fails stays pending and is retried on
// later flushes, at most this many times; then it is logged in full and dropped.
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

// Order rows by primary key so every flush (and every server sharing the
// database) takes row locks in the same order: unordered INSERT ... ON
// DUPLICATE KEY UPDATE batches deadlock against each other. Integer-looking
// components compare numerically; numbers sort before other text.
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

// True when some PRIMARY/UNIQUE index uses only conflict-key columns. An
// index on a subset still makes ON DUPLICATE KEY UPDATE fire (and keeps update
// mode's WHERE indexed), so only a key with no such index gets the warning.
// `rows` are information_schema.STATISTICS rows with NON_UNIQUE = 0.
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

// Shallow value-equality over a `cols` map (flat column -> primitive/JSON
// string). Used to tell whether a re-merged stale hedge copy in `pending` is
// still exactly what we put there, or whether a newer enqueue() has since
// merged into it in place.
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

        // Each table owns its pending rows and one serialized in-flight write.
        this.pending = new Map();
        this.pendingRowCount = 0;

        this.timer = null;
        this.dialect = batch.dialectFor(pools.version);
        // table|key columns already checked against information_schema (P7).
        this.verifiedKeys = new Set();
        // table|key -> failed verification attempts (retried a few times).
        this.verifyFailures = new Map();
        // `resource|reason` pairs already logged for rejected enqueue input.
        this.warnedRejects = new Set();
    }

    // The flush writes on its own pool when one is configured, so ad-hoc
    // writes and long transactions cannot starve the save path.
    _pool() {
        return this.pools.flush || this.pools.write;
    }

    _tableState(table, conflictKey, mode, writeMode) {
        let st = this.pending.get(table);
        if (!st) {
            st = {
                conflictKey, mode, writeMode, rows: new Map(),
                // pk key -> dead-letter attempts that failed (see M2 cap).
                poison: new Map(),
                generation: 0, completedGeneration: 0, flushing: false, inFlight: null,
            };
            this.pending.set(table, st);
        } else if (st.mode !== mode || st.writeMode !== writeMode || JSON.stringify(st.conflictKey) !== JSON.stringify(conflictKey)) {
            // The options are only locked while rows are pending or a write is in
            // flight; an idle table takes the new caller's options.
            if (st.rows.size > 0 || st.inFlight) {
                throw invalid('incompatible-options', `qbsql/queue: incompatible queue options for table ${table} while writes are pending.`);
            }
            st.conflictKey = conflictKey;
            st.mode = mode;
            st.writeMode = writeMode;
        }
        this._verifyConflictKey(table, conflictKey);
        return st;
    }

    // Warn (once per table and key) when the conflict key is not exactly a
    // PRIMARY/UNIQUE index: ON DUPLICATE KEY UPDATE would then never fire and
    // every flush would INSERT duplicate rows, and update mode would scan.
    // Fire-and-forget so enqueue() stays synchronous.
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
                // A failed check (e.g. a read-pool timeout at boot) is retried
                // on a later enqueue, a few times at most.
                const failures = (this.verifyFailures.get(id) || 0) + 1;
                this.verifyFailures.set(id, failures);
                if (failures < 3) this.verifiedKeys.delete(id);
                log.debug('queue', `could not verify the conflict key of ${table}: ${err.message}`);
            });
    }

    // Validate a call's table, key and options. Returns the normalised key
    // column list. Throws synchronously, before anything is queued.
    _checkTarget(table, conflictKey, opts) {
        if (!isIdent(table)) throw invalid('bad-table', `qbsql/queue: invalid table name '${table}'`);
        const keyCols = Array.isArray(conflictKey) ? conflictKey : [conflictKey];
        if (keyCols.length === 0 || !keyCols.every(isIdent)) {
            throw invalid('bad-key', `qbsql/queue: invalid conflict key for ${table}`);
        }
        const mode = opts.mode || 'assign';
        if (mode !== 'assign' && mode !== 'accumulate') throw invalid('bad-mode', `qbsql/queue: unsupported mode '${mode}'.`);
        const writeMode = opts.writeMode || 'upsert';
        if (writeMode !== 'upsert' && writeMode !== 'update') {
            throw invalid('bad-write-mode', `qbsql/queue: unsupported writeMode '${writeMode}'.`);
        }
        let allowed = null;
        if (opts.allowedColumns !== undefined && opts.allowedColumns !== null) {
            if (!Array.isArray(opts.allowedColumns)) throw invalid('bad-allowed-columns', 'qbsql/queue: allowedColumns must be a list of column names');
            allowed = new Set(opts.allowedColumns.map((c) => String(c).toLowerCase()));
        }
        return { keyCols, mode, writeMode, allowed };
    }

    // Validate one { pk, cols } row and return its merge key and a private copy
    // of its columns. Column names are identifiers, never key columns, and
    // (with opts.allowedColumns) only the columns the caller allowed.
    _prepareRow(table, target, row) {
        if (!row || typeof row !== 'object' || !row.cols || typeof row.cols !== 'object' || Array.isArray(row.cols)) {
            throw invalid('bad-row', `qbsql/queue: rows for ${table} must be { pk = ..., cols = { ... } }`);
        }
        const { keyCols, mode, allowed } = target;
        if (Array.isArray(row.pk) ? row.pk.length !== keyCols.length : keyCols.length !== 1) {
            throw invalid('pk-arity', `qbsql/queue: ${table} needs ${keyCols.length} primary key value(s) per row`);
        }
        const key = pkKey(row.pk);
        const keySet = new Set(keyCols.map((c) => c.toLowerCase()));
        const cols = {};
        const names = Object.keys(row.cols);
        if (names.length === 0) throw invalid('no-columns', `qbsql/queue: a row for ${table} has no columns to write`);
        for (const name of names) {
            if (!isIdent(name)) throw invalid('bad-column', `qbsql/queue: invalid column name '${name}' for ${table}`);
            const lower = name.toLowerCase();
            if (keySet.has(lower)) throw invalid('key-column', `qbsql/queue: ${table}.${name} is a conflict key column and cannot be written`);
            if (allowed && !allowed.has(lower)) throw invalid('not-allowed', `qbsql/queue: column ${table}.${name} is not in allowedColumns`);
            cols[name] = mode === 'accumulate' ? accumulateValue(table, name, row.cols[name]) : row.cols[name];
        }
        return { key, pk: row.pk, cols };
    }

    // Merge validated rows into the table's pending set.
    _merge(table, target, prepared) {
        const st = this._tableState(table, target.keyCols, target.mode, target.writeMode);
        for (const row of prepared) {
            const existing = st.rows.get(row.key);
            if (existing) {
                if (target.mode === 'accumulate') {
                    // Sum overlapping columns rather than overwrite.
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

    // Log a rejected enqueue input once per (resource, reason), and count it.
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

    // Validate and merge rows. Valid rows are queued; invalid rows are dropped
    // and logged (never thrown) so one bad row -- e.g. a player whose key is
    // not loaded yet -- cannot cost every other row in the save batch, nor
    // raise into the caller's save loop. With opts.strict (the awaited
    // upsert export) validation is all-or-nothing and the first error throws.
    // Returns { queued, dropped }.
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
            // Only incompatible table options can fail here, before any row merges.
            if (strict) throw err;
            this._reject(resource, table, err, prepared.length);
            return { queued: 0, dropped: dropped + prepared.length };
        }
        this._scheduleOrTrip(opts.priority === 'immediate' ? table : null);
        return { queued: prepared.length, dropped };
    }

    // Enqueue one row. Fire-and-forget: never returns a promise the caller
    // waits on, and never throws. `row` is { pk, cols }.
    enqueue(table, conflictKey, row, opts, resource) {
        return this._enqueue(table, conflictKey, [row], opts || {}, resource, false);
    }

    // Enqueue many rows in one call -- the single-boundary-crossing path.
    // Valid rows are queued even when others in the call are invalid (see
    // _enqueue). Scheduling happens once, so an 'immediate' batch is one
    // flush rather than one per row. opts.strict: all-or-nothing, throws.
    enqueueMany(table, conflictKey, rows, opts, resource) {
        opts = opts || {};
        const strict = opts.strict === true;
        this.stats.countCrossing();
        // An empty Lua table can arrive as an empty object.
        if (rows && !Array.isArray(rows) && typeof rows === 'object' && Object.keys(rows).length === 0) rows = [];
        if (!Array.isArray(rows)) {
            const err = invalid('not-a-list', `qbsql/queue: enqueueMany for ${table} needs a list of rows`);
            if (strict) throw err;
            this._reject(resource, table, err, 1);
            return { queued: 0, dropped: 1 };
        }
        if (rows.length === 0) return { queued: 0, dropped: 0 };
        return this._enqueue(table, conflictKey, rows, opts, resource, strict);
    }

    _scheduleOrTrip(immediateTable) {
        if (immediateTable) {
            // Fire an immediate flush for the one table, out of band.
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

    // Arm the shared interval timer if it is not already running. Idempotent.
    _ensureTimer() {
        if (!this.timer) {
            this.timer = setTimeout(() => {
                this.timer = null;
                this.flush().catch((e) => log.error('queue', `interval flush failed: ${e.message}`));
            }, this.cfg.flushInterval);
            // Do not keep the process alive solely for the flush timer.
            if (this.timer.unref) this.timer.unref();
        }
    }

    // Wait for the writes covered by this call, including already active writes.
    // Tables can flush in parallel, but writes to one table remain serialized.
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

        // Later enqueues must not keep an explicit flush waiting indefinitely.
        const target = st.generation + (st.rows.size > 0 ? 1 : 0);
        do {
            if (!st.inFlight) {
                if (st.rows.size === 0) return;
                const snapshot = st.rows;
                st.rows = new Map();
                st.generation++;
                st.flushing = true;
                this.pendingRowCount -= snapshot.size;

                // Publish the promise before a provider can re-enter enqueue().
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
            // Group by signature = sorted column set.
            const groups = new Map();   // signature -> { columns, rows: [] }
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
                // A stable lock order across writers (see comparePk).
                g.rows.sort(comparePk);
                // The batched UPDATE binds every key once per column CASE branch plus once in WHERE.
                const perRow = st.writeMode === 'update'
                    ? g.columns.length * (keyCount + 1) + keyCount
                    : g.columns.length + keyCount;
                const perStatement = Math.min(
                    this.cfg.maxRowsPerStatement,
                    Math.max(1, Math.floor(this.cfg.maxPlaceholders / perRow))
                );
                for (let i = 0; i < g.rows.length; i += perStatement) {
                    const chunk = g.rows.slice(i, i + perStatement);
                    // Other chunks are independent; do not discard their detached rows.
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

    // Build and write one chunk. A deterministic failure (bad value, missing
    // column, constraint) in a multi-row chunk is bisected so only the
    // offending row(s) dead-letter instead of every row sharing the statement.
    // Resolves to { statements, rows, error } and never rejects.
    async _writeChunk(table, st, columns, chunk, perStatement) {
        const builder = st.writeMode === 'update' ? batch.buildUpdate : batch.build;
        const { sql, params, rowCount } = builder(
            table, st.conflictKey, columns, chunk,
            {
                mode: st.mode,
                dialect: this.dialect,
                // Padding must not push a wide chunk past the placeholder budget.
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

    // Re-merge failed rows into the live pending set (see _writeWithRetry).
    // Returns the map of hedge copies so a later outcome can clear them.
    _hedge(table, chunk, reMerged) {
        const st = this.pending.get(table);
        for (const entry of chunk) {
            const key = pkKey(entry.pk);
            if (!st.rows.has(key)) {
                // Only requeue columns not since superseded: if the row is
                // already back in pending, its newer values win and we skip.
                // Keep an independent snapshot of the stale cols (not the
                // same object we store live) so a later success can tell
                // whether the live copy is still untouched.
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

    // Forget dead-letter failure counts of rows that were written.
    _clearPoison(table, chunk) {
        const st = this.pending.get(table);
        if (!st || !st.poison || st.poison.size === 0) return;
        for (const entry of chunk) st.poison.delete(pkKey(entry.pk));
    }

    // Dead-letter `chunk` (whose rows are already hedged into pending), then
    // clear the hedge for every row that is now safely recorded. A row whose
    // dead-letter insert failed stays pending for a later flush, at most
    // MAX_DEADLETTER_ATTEMPTS times; after that it is logged in full and
    // dropped so a poison row cannot loop forever.
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

    // The error a dead-lettered chunk reports to flush() callers.
    _deadLetterError(table, what, chunk, failed) {
        return new Error(failed
            ? `qbsql: write to ${table} failed ${what}; failed to dead-letter ${failed}/${chunk.length} row(s)`
            : `qbsql: write to ${table} failed ${what}; ${chunk.length} row(s) were dead-lettered`);
    }

    async _writeWithRetry(table, sql, params, chunk, mode, attempt, reMerged) {
        attempt = attempt || 0;
        try {
            await this._pool().execute(sql, normalizeWriteParams(params));
            // A prior failed attempt (below) may have re-merged some of these
            // rows' stale, pre-retry values back into the live pending set as
            // a hedge. The direct retry we just ran used the ORIGINAL stale
            // `params`, and it succeeded -- so that hedge copy must now be
            // cleared, or it survives to the next flush and re-sends the same
            // stale values a second time (silent double-counting in
            // accumulate mode). Only clear it if it still holds exactly what
            // we re-merged: if a newer enqueue() landed on top of it in the
            // meantime (merged in place -- see enqueue()), that is a
            // legitimate write that was never sent and must be preserved.
            this._clearReMerged(table, reMerged, mode);
            this._clearPoison(table, chunk);
        } catch (err) {
            this.stats.queue.retries++;
            const noSuchTableRetry = err && err.code === 'ER_NO_SUCH_TABLE' && !err.fatal && attempt < NO_SUCH_TABLE_RETRIES;
            if (!isRetryableWriteError(err) && !noSuchTableRetry) {
                // Retrying the same statement cannot succeed. Row-level errors
                // in a multi-row chunk are split by _writeChunk; any hedge
                // copies from earlier transient attempts are cleared first
                // because the halves are written (or dead-lettered) from these
                // same stale rows. Statement-level errors fail for every row
                // alike, so the whole chunk dead-letters at once.
                const statementLevel = STATEMENT_LEVEL_WRITE_ERRORS.has(err.code);
                if (chunk.length > 1 && !statementLevel) {
                    this._clearReMerged(table, reMerged, mode);
                    const split = new Error(`qbsql: write to ${table} failed (${err.code}); bisecting ${chunk.length} rows`);
                    split.bisect = true;
                    split.cause = err;
                    throw split;
                }
                // Hedge before dead-lettering, so a failed dead-letter insert
                // still leaves the rows pending rather than losing them.
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
            // Re-merge the failed rows into the live pending set so a newer
            // in-memory value can still supersede this stale retry -- a naive
            // retry of `params` would resurrect an old balance. enqueue()'s
            // last-write-wins merge does exactly the right thing here.
            reMerged = this._hedge(table, chunk, reMerged);
            const backoff = noSuchTableRetry
                ? NO_SUCH_TABLE_BACKOFF_MS * (attempt + 1)
                : Math.min(2000, 50 * Math.pow(2, attempt));
            log.warn('queue', `write failed on ${table} (attempt ${attempt + 1}), retrying in ${backoff}ms: ${err.message}`);
            await new Promise((r) => setTimeout(r, backoff));
            // Rebuild from the (possibly merged) live set on the next flush;
            // here we retry the same chunk once more directly for promptness.
            await this._writeWithRetry(table, sql, params, chunk, mode, attempt + 1, reMerged);
        }
    }

    // Best-effort persistence of unwriteable rows so they are recoverable.
    // One multi-row INSERT; if that fails (e.g. one oversized value), fall
    // back to row by row so one bad row cannot sink the rest. Never throws:
    // resolves to the entries that could NOT be dead-lettered.
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
