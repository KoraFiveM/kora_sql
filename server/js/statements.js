// Prepared-statement bookkeeping.
//
// mysql2 already keeps a per-connection prepared-statement cache (sized by
// `maxPreparedStatements`), so when we call pool.execute() a repeated SQL text
// skips the parse/prepare round trip automatically. What mysql2 does NOT do is
// remember that a given SQL text CANNOT be prepared -- and that is the failure
// mode this module exists to eliminate.
//
// THE PROBLEM: not every statement is preparable. Placeholders in identifier
// position, some SET/DDL forms, and a few others make the server reject
// COM_STMT_PREPARE with ER_UNSUPPORTED_PS / ER_WRONG_ARGUMENTS. If we naively
// retried execute() every time, every call to such a statement would pay a
// failed-prepare round trip before falling back to query(). This LRU records
// the unpreparable set so the failed prepare is paid at most ONCE per SQL text.

'use strict';

class StatementCache {
    constructor(maxSize) {
        this.maxSize = maxSize;
        // Map keyed by exact SQL text. Insertion-order iteration + delete/set
        // on touch gives LRU eviction with no extra structure.
        this.entries = new Map();
    }

    // Returns the record for a SQL text, creating it on first sight. Touching
    // it (delete + set) moves it to the most-recently-used end.
    touch(sql) {
        let rec = this.entries.get(sql);
        if (rec) {
            this.entries.delete(sql);
            this.entries.set(sql, rec);
            return rec;
        }
        rec = { preparable: true, hits: 0, misses: 0 };
        this.entries.set(sql, rec);
        if (this.entries.size > this.maxSize) {
            // Evict the least-recently-used (first) entry. Losing the
            // "unpreparable" flag on eviction only costs one more failed
            // prepare if that SQL text ever comes back -- acceptable, and the
            // LRU is sized so hot statements never evict.
            const oldest = this.entries.keys().next().value;
            this.entries.delete(oldest);
        }
        return rec;
    }

    isPreparable(sql) {
        const rec = this.entries.get(sql);
        return rec ? rec.preparable : true;
    }

    markUnpreparable(sql) {
        const rec = this.touch(sql);
        rec.preparable = false;
    }

    recordHit(sql) {
        this.touch(sql).hits++;
    }

    recordMiss(sql) {
        this.touch(sql).misses++;
    }

    // Aggregate stats for /qbsql stats. preparedHitRate here is a coarse proxy
    // (hits vs misses across cached statements); the precise per-flush prepared
    // hit rate lives in stats.js.
    summary() {
        let hits = 0, misses = 0, unpreparable = 0;
        for (const rec of this.entries.values()) {
            hits += rec.hits;
            misses += rec.misses;
            if (!rec.preparable) unpreparable++;
        }
        return {
            size: this.entries.size,
            maxSize: this.maxSize,
            hits,
            misses,
            unpreparable,
        };
    }
}

// Error codes the MySQL/MariaDB server returns when a statement cannot be
// prepared. mysql2 surfaces these as err.code strings.
const UNPREPARABLE_CODES = new Set([
    'ER_UNSUPPORTED_PS',
    'ER_WRONG_ARGUMENTS',
    'ER_PARSE_ERROR_IN_PS',        // some servers report a generic parse error only at prepare time
]);

function isUnpreparableError(err) {
    return err && UNPREPARABLE_CODES.has(err.code);
}

module.exports = { StatementCache, isUnpreparableError };
