'use strict';

const BINARY_CHARSET = 63;

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
