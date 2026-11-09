'use strict';

class StatementCache {
    constructor(maxSize) {
        this.maxSize = maxSize;
        this.entries = new Map();
    }

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

const UNPREPARABLE_CODES = new Set([
    'ER_UNSUPPORTED_PS',
    'ER_WRONG_ARGUMENTS',
    'ER_PARSE_ERROR_IN_PS',
]);

function isUnpreparableError(err) {
    return err && UNPREPARABLE_CODES.has(err.code);
}

module.exports = { StatementCache, isUnpreparableError };
