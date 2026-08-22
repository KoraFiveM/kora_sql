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

// Serialise a PK (which may be composite -- an array) to a Map key.
function pkKey(pk) {
    return Array.isArray(pk) ? pk.map((v) => '\x1f' + v).join('') : String(pk);
}

class WriteQueue {
    constructor(executor, pools, stats, cfg) {
        this.executor = executor;
        this.pools = pools;
        this.stats = stats;
        this.cfg = cfg;

        // table -> { conflictKey, mode, rows: Map<pkKey, {pk, cols}>, generation, flushing }
        this.pending = new Map();
        this.pendingRowCount = 0;

        this.timer = null;
        this.dialect = batch.dialectFor(pools.version);
    }

    _tableState(table, conflictKey, mode) {
        let st = this.pending.get(table);
        if (!st) {
            st = { conflictKey, mode, rows: new Map(), generation: 0, flushing: false };
            this.pending.set(table, st);
        }
        return st;
    }

    // Enqueue one row. Fire-and-forget: never returns a promise the caller
    // waits on. `row` is { pk, cols }.
    enqueue(table, conflictKey, row, opts) {
        opts = opts || {};
        const mode = opts.mode || 'assign';
        const st = this._tableState(table, conflictKey, mode);

        const key = pkKey(row.pk);
        const existing = st.rows.get(key);
        if (existing) {
            if (mode === 'accumulate') {
                // Sum overlapping columns rather than overwrite.
                for (const c of Object.keys(row.cols)) {
                    existing.cols[c] = (existing.cols[c] || 0) + row.cols[c];
                }
            } else {
                Object.assign(existing.cols, row.cols);
            }
        } else {
            st.rows.set(key, { pk: row.pk, cols: { ...row.cols } });
            this.pendingRowCount++;
        }

        this._scheduleOrTrip(opts.priority === 'immediate' ? table : null);
    }

    // Enqueue many rows in one call -- the single-boundary-crossing path.
    enqueueMany(table, conflictKey, rows, opts) {
        opts = opts || {};
        this.stats.countCrossing(rows.length);
        for (const row of rows) {
            this.enqueue(table, conflictKey, row, opts);
        }
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
        if (!this.timer) {
            this.timer = setTimeout(() => {
                this.timer = null;
                this.flush().catch((e) => log.error('queue', `interval flush failed: ${e.message}`));
            }, this.cfg.flushInterval);
            // Do not keep the process alive solely for the flush timer.
            if (this.timer.unref) this.timer.unref();
        }
    }

    // Flush one table (or all). Returns a promise that resolves once the write
    // has been attempted. One flush in flight per table, EVER -- this is what
    // prevents interleaved writes to the same row.
    async flush(onlyTable) {
        const tables = onlyTable ? [onlyTable] : Array.from(this.pending.keys());
        await Promise.all(tables.map((t) => this._flushTable(t)));
    }

    async _flushTable(table) {
        const st = this.pending.get(table);
        if (!st || st.rows.size === 0) return;
        if (st.flushing) return;               // one in flight per table
        st.flushing = true;

        // Snapshot + swap: rows arriving during this flush go into a fresh Map
        // (the next generation), so they are never interleaved with this write.
        const snapshot = st.rows;
        const snapshotCount = snapshot.size;
        st.rows = new Map();
        st.generation++;
        this.pendingRowCount -= snapshotCount;

        const started = process.hrtime.bigint();
        let statements = 0;
        let rowsWritten = 0;

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

            for (const g of groups.values()) {
                const perStatement = Math.min(
                    this.cfg.maxRowsPerStatement,
                    Math.max(1, Math.floor(this.cfg.maxPlaceholders / (g.columns.length + 1)))
                );
                for (let i = 0; i < g.rows.length; i += perStatement) {
                    const chunk = g.rows.slice(i, i + perStatement);
                    const { sql, params, rowCount } = batch.build(
                        table, st.conflictKey, g.columns, chunk,
                        {
                            mode: st.mode,
                            dialect: this.dialect,
                            pad: this.cfg.padToBuckets && st.mode === 'assign',
                        }
                    );
                    await this._writeWithRetry(table, sql, params, chunk, st.mode, g.columns);
                    statements++;
                    rowsWritten += rowCount;
                }
            }

            const ms = Number(process.hrtime.bigint() - started) / 1e6;
            this.stats.recordFlush(snapshotCount, rowsWritten, statements, ms);
            log.debug('queue', `flushed ${table}: ${snapshotCount} rows -> ${statements} statements in ${ms.toFixed(1)}ms`);
        } finally {
            st.flushing = false;
        }
    }

    async _writeWithRetry(table, sql, params, chunk, mode, columns, attempt) {
        attempt = attempt || 0;
        try {
            await this.pools.write.execute(sql, params);
        } catch (err) {
            this.stats.queue.retries++;
            if (attempt >= 5) {
                this.stats.queue.deadLettered += chunk.length;
                log.error('queue',
                    `DEAD-LETTER after ${attempt} retries on ${table} (${chunk.length} rows): ${err.message}`);
                await this._deadLetter(table, chunk, err).catch(() => {});
                return;
            }
            // Re-merge the failed rows into the live pending set so a newer
            // in-memory value can still supersede this stale retry -- a naive
            // retry of `params` would resurrect an old balance. enqueue()'s
            // last-write-wins merge does exactly the right thing here.
            const st = this.pending.get(table);
            for (const entry of chunk) {
                const key = pkKey(entry.pk);
                if (!st.rows.has(key)) {
                    // Only requeue columns not since superseded: if the row is
                    // already back in pending, its newer values win and we skip.
                    st.rows.set(key, { pk: entry.pk, cols: { ...entry.cols } });
                    this.pendingRowCount++;
                }
            }
            const backoff = Math.min(2000, 50 * Math.pow(2, attempt));
            log.warn('queue', `write failed on ${table} (attempt ${attempt + 1}), retrying in ${backoff}ms: ${err.message}`);
            await new Promise((r) => setTimeout(r, backoff));
            // Rebuild from the (possibly merged) live set on the next flush;
            // here we retry the same chunk once more directly for promptness.
            await this._writeWithRetry(table, sql, params, chunk, mode, columns, attempt + 1);
        }
    }

    async _deadLetter(table, chunk, err) {
        // Best-effort persistence of unwriteable rows so they are recoverable.
        const sql =
            'INSERT INTO `qbsql_deadletter` (`table_name`,`pk`,`cols_json`,`error`,`failed_at`) ' +
            'VALUES (?,?,?,?,NOW())';
        for (const entry of chunk) {
            const pk = Array.isArray(entry.pk) ? entry.pk.join('\x1f') : String(entry.pk);
            try {
                await this.pools.write.execute(sql, [table, pk, JSON.stringify(entry.cols), String(err.message).slice(0, 500)]);
            } catch (e) {
                log.error('queue', `dead-letter insert itself failed for ${table}/${pk}: ${e.message}`);
            }
        }
    }

    depth() {
        const out = {};
        for (const [table, st] of this.pending) {
            out[table] = { rows: st.rows.size, generation: st.generation, flushing: st.flushing };
        }
        return out;
    }
}

module.exports = { WriteQueue, pkKey };
