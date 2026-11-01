// oxmysql-compatible mysql2 typeCast functions, ported from oxmysql's
// src/utils/typeCast.ts. Applied ONLY on the oxmysql compatibility path (the
// Executor's `oxTypeCast` view, see execute.js); kora's native API keeps mysql2's
// default shapes.
//
// One deliberate addition: JSON columns are returned as strings. Upstream gets
// that from the mysql2 connection option `jsonStrings: true`, which is a
// per-pool setting; doing it in the typeCast keeps kora's pools (and the native
// API) untouched while oxmysql callers still receive the raw JSON text.

'use strict';

const BINARY_CHARSET = 63;

// Execute (prepared statement) path: dates -> ms since epoch, nothing else.
function typeCastExecute(field, next) {
    switch (field.type) {
        case 'DATETIME':
        case 'DATETIME2':
        case 'TIMESTAMP':
        case 'TIMESTAMP2':
        case 'NEWDATE': {
            const value = field.string();
            return value ? new Date(value).getTime() : null;
        }
        case 'DATE': {
            const value = field.string();
            return value ? new Date(value + ' 00:00:00').getTime() : null;
        }
        case 'JSON':
            return field.string();
        default:
            return next();
    }
}

// Query (text protocol) path: mysql-async compatible typecasting.
function typeCast(field, next) {
    switch (field.type) {
        case 'DATETIME':
        case 'DATETIME2':
        case 'TIMESTAMP':
        case 'TIMESTAMP2':
        case 'NEWDATE': {
            const value = field.string();
            return value ? new Date(value).getTime() : null;
        }
        case 'DATE': {
            const value = field.string();
            return value ? new Date(value + ' 00:00:00').getTime() : null;
        }
        case 'TINY': {
            if (field.length !== 1) return next();
            const value = field.string();
            return value === null ? null : value === '1';
        }
        case 'BIT': {
            const buffer = field.buffer();
            if (!buffer) return null;
            return buffer.length === 1 ? buffer[0] === 1 : buffer[0];
        }
        case 'TINY_BLOB':
        case 'MEDIUM_BLOB':
        case 'LONG_BLOB':
        case 'BLOB': {
            if (field.charset === BINARY_CHARSET) {
                const value = field.buffer();
                if (value === null) return [value];
                return [...value];
            }
            return field.string();
        }
        case 'JSON':
            return field.string();
        default:
            return next();
    }
}

module.exports = { typeCast, typeCastExecute, BINARY_CHARSET };
