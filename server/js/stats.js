// Observability: per-fingerprint aggregates + a slow-query ring buffer + the
// queue counters that prove the write-coalescing thesis.
//
// The FINGERPRINT is the SQL text itself, because this driver always
// parameterises -- there are no literal values baked into the SQL to strip, so
// the text is already a stable fingerprint. That is a direct consequence of the
// prepared-statement design and is what makes attribution cheap.

'use strict';

class Stats {
    constructor(slowThreshold, slowRing) {
        this.slowThreshold = slowThreshold;
        this.slowRingSize = slowRing;

        // fingerprint -> aggregate
        this.byFingerprint = new Map();

        // Ring buffer of slow queries.
        this.slow = [];
        this.slowHead = 0;

        // Queue counters -- the numbers that demonstrate coalescing works.
        this.queue = {
            boundaryCrossings: 0,   // enqueue/enqueueMany calls from Lua
            rowsEnqueued: 0,        // rows handed in
            rowsWritten: 0,        // rows actually sent to MySQL (post-merge)
            statementsIssued: 0,
            flushes: 0,
            flushDurationMs: [],    // recent flush durations
            deadLettered: 0,
            retries: 0,
        };
    }

    record(sql, ms, rows, errored, resource) {
        let agg = this.byFingerprint.get(sql);
        if (!agg) {
            agg = {
                count: 0, totalMs: 0, maxMs: 0, minMs: Infinity,
                errors: 0, rowsReturned: 0, lastSeenAt: 0,
            };
            this.byFingerprint.set(sql, agg);
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

    countCrossing(rows) {
        this.queue.boundaryCrossings++;
        // rowsEnqueued is counted at flush time from the actual snapshot so a
        // row enqueued and then superseded before flush is not double-counted;
        // here we only bump the crossing count.
    }

    slowQueries(limit) {
        // Return newest-first.
        const ordered = this.slow.slice().sort((a, b) => b.at - a.at);
        return ordered.slice(0, limit || 20);
    }

    summary(statementCache) {
        let totalCount = 0, totalMs = 0, totalErrors = 0;
        const top = [];
        for (const [sql, agg] of this.byFingerprint) {
            totalCount += agg.count;
            totalMs += agg.totalMs;
            totalErrors += agg.errors;
            top.push({ sql, ...agg, avgMs: agg.count ? agg.totalMs / agg.count : 0 });
        }
        top.sort((a, b) => b.totalMs - a.totalMs);

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
                slowCount: this.slow.length,
                slowThreshold: this.slowThreshold,
                topByTotalMs: top.slice(0, 10),
            },
            queue: {
                boundaryCrossings: q.boundaryCrossings,
                rowsEnqueued: q.rowsEnqueued,
                rowsWritten: q.rowsWritten,
                // The headline number: rows callers handed us vs rows we
                // actually wrote. > 1.0 means coalescing saved round trips.
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
        this.slow = [];
        this.slowHead = 0;
        this.queue = {
            boundaryCrossings: 0, rowsEnqueued: 0, rowsWritten: 0,
            statementsIssued: 0, flushes: 0, flushDurationMs: [],
            deadLettered: 0, retries: 0,
        };
    }
}

module.exports = { Stats };
