'use strict';

const OTHER = '<other>';
const TOP_N = 10;

const LITERALS = /(`(?:[^`]|``)*`)|'(?:\\.|''|[^'\\])*'|"(?:\\.|""|[^"\\])*"|\b0x[0-9a-f]+\b|\b\d+(?:\.\d+)?(?:e[+-]?\d+)?\b/gi;
function fingerprint(sql) {
    if (typeof sql !== 'string') return String(sql);
    return sql
        .replace(LITERALS, (match, ident) => (ident !== undefined ? ident : '?'))
        .replace(/\s+/g, ' ')
        .replace(/\(\s*\?(?:\s*,\s*\?)+\s*\)/g, '(?+)')
        .trim();
}

function blankAggregate() {
    return {
        count: 0, totalMs: 0, maxMs: 0, minMs: Infinity,
        errors: 0, rowsReturned: 0, lastSeenAt: 0,
    };
}

function mergeInto(target, agg) {
    target.count += agg.count;
    target.totalMs += agg.totalMs;
    target.maxMs = Math.max(target.maxMs, agg.maxMs);
    target.minMs = Math.min(target.minMs, agg.minMs);
    target.errors += agg.errors;
    target.rowsReturned += agg.rowsReturned;
    target.lastSeenAt = Math.max(target.lastSeenAt, agg.lastSeenAt);
}

class Stats {
    constructor(slowThreshold, slowRing, maxFingerprints) {
        this.slowThreshold = slowThreshold;
        this.slowRingSize = slowRing;
        this.maxFingerprints = Math.max(1, maxFingerprints || 2000);

        this.byFingerprint = new Map();
        this.fingerprintCache = new Map();
        this.other = null;

        this.slow = [];
        this.slowHead = 0;

        this.queue = {
            boundaryCrossings: 0,
            rowsEnqueued: 0,
            rowsWritten: 0,
            statementsIssued: 0,
            flushes: 0,
            flushDurationMs: [],
            deadLettered: 0,
            retries: 0,
        };
    }

    _fingerprint(sql) {
        let fp = this.fingerprintCache.get(sql);
        if (fp === undefined) {
            fp = fingerprint(sql);
            if (this.fingerprintCache.size >= 1000) this.fingerprintCache.clear();
            this.fingerprintCache.set(sql, fp);
        }
        return fp;
    }

    record(sql, ms, rows, errored, resource) {
        const fp = this._fingerprint(sql);
        let agg = this.byFingerprint.get(fp);
        if (agg) {
            this.byFingerprint.delete(fp);
            this.byFingerprint.set(fp, agg);
        } else {
            agg = blankAggregate();
            this.byFingerprint.set(fp, agg);
            if (this.byFingerprint.size > this.maxFingerprints) {
                const [oldest, evicted] = this.byFingerprint.entries().next().value;
                this.byFingerprint.delete(oldest);
                if (!this.other) this.other = blankAggregate();
                mergeInto(this.other, evicted);
            }
        }
        agg.count++;
        agg.totalMs += ms;
        if (ms > agg.maxMs) agg.maxMs = ms;
        if (ms < agg.minMs) agg.minMs = ms;
        if (errored) agg.errors++;
        agg.rowsReturned += rows || 0;
        agg.lastSeenAt = Date.now();

        if (ms >= this.slowThreshold) {
            const entry = { ms, sql, rows: rows || 0, resource: resource || 'unknown', at: Date.now() };
            if (this.slow.length < this.slowRingSize) {
                this.slow.push(entry);
            } else {
                this.slow[this.slowHead] = entry;
                this.slowHead = (this.slowHead + 1) % this.slowRingSize;
            }
        }
    }

    recordFlush(rowsEnqueued, rowsWritten, statements, durationMs) {
        const q = this.queue;
        q.rowsEnqueued += rowsEnqueued;
        q.rowsWritten += rowsWritten;
        q.statementsIssued += statements;
        q.flushes++;
        q.flushDurationMs.push(durationMs);
        if (q.flushDurationMs.length > 100) q.flushDurationMs.shift();
    }

    countCrossing() {
        this.queue.boundaryCrossings++;
    }

    slowQueries(limit) {
        const ordered = this.slow.slice().sort((a, b) => b.at - a.at);
        return ordered.slice(0, limit || 20);
    }

    summary(statementCache) {
        let totalCount = 0, totalMs = 0, totalErrors = 0;
        const top = [];
        const consider = (sql, agg) => {
            totalCount += agg.count;
            totalMs += agg.totalMs;
            totalErrors += agg.errors;
            if (top.length === TOP_N && agg.totalMs <= top[TOP_N - 1].totalMs) return;
            const entry = { sql, ...agg, avgMs: agg.count ? agg.totalMs / agg.count : 0 };
            let i = top.length;
            while (i > 0 && top[i - 1].totalMs < entry.totalMs) i--;
            top.splice(i, 0, entry);
            if (top.length > TOP_N) top.pop();
        };
        for (const [sql, agg] of this.byFingerprint) consider(sql, agg);
        if (this.other) consider(OTHER, this.other);

        const q = this.queue;
        const flushDurations = q.flushDurationMs;
        const avgFlush = flushDurations.length
            ? flushDurations.reduce((a, b) => a + b, 0) / flushDurations.length
            : 0;

        return {
            queries: {
                total: totalCount,
                errors: totalErrors,
                avgMs: totalCount ? totalMs / totalCount : 0,
                distinctFingerprints: this.byFingerprint.size,
                evictedQueries: this.other ? this.other.count : 0,
                slowCount: this.slow.length,
                slowThreshold: this.slowThreshold,
                topByTotalMs: top,
            },
            queue: {
                boundaryCrossings: q.boundaryCrossings,
                rowsEnqueued: q.rowsEnqueued,
                rowsWritten: q.rowsWritten,
                coalesceRatio: q.rowsWritten ? q.rowsEnqueued / q.rowsWritten : 0,
                statementsIssued: q.statementsIssued,
                statementsPerFlush: q.flushes ? q.statementsIssued / q.flushes : 0,
                flushes: q.flushes,
                avgFlushMs: avgFlush,
                deadLettered: q.deadLettered,
                retries: q.retries,
            },
            statementCache,
        };
    }

    reset() {
        this.byFingerprint.clear();
        this.fingerprintCache.clear();
        this.other = null;
        this.slow = [];
        this.slowHead = 0;
        this.queue = {
            boundaryCrossings: 0, rowsEnqueued: 0, rowsWritten: 0,
            statementsIssued: 0, flushes: 0, flushDurationMs: [],
            deadLettered: 0, retries: 0,
        };
    }
}

module.exports = { Stats, fingerprint };
