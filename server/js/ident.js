// Shared SQL identifier validation.
//
// quoteIdent() (batch.js) escapes backticks, so an unvalidated name is not SQL
// injection -- but it still lets a caller choose WHICH table/column a write
// lands in (e.g. a client-forwarded `cols` map containing `money`), and accepts
// strings such as `players.money` as a single identifier. Every identifier that
// reaches generated SQL from a caller (schema specs, write-queue tables,
// conflict keys and column maps) is checked against this one pattern.

'use strict';

// Unquoted MySQL identifier subset: ASCII letters, digits and underscore, 1-64
// characters (MySQL's identifier length limit).
const IDENT = /^[A-Za-z0-9_]{1,64}$/;

function isIdent(value) {
    return typeof value === 'string' && IDENT.test(value);
}

// Throws `<prefix>: invalid <what> '<value>'` for anything that is not a plain identifier.
function assertIdent(value, what, prefix) {
    if (!isIdent(value)) throw new Error(`${prefix || 'qbsql'}: invalid ${what} '${value}'`);
}

module.exports = { IDENT, isIdent, assertIdent };
