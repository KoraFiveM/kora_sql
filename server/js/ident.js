'use strict';

const IDENT = /^[A-Za-z0-9_]{1,64}$/;

function isIdent(value) {
    return typeof value === 'string' && IDENT.test(value);
}

function assertIdent(value, what, prefix) {
    if (!isIdent(value)) throw new Error(`${prefix || 'qbsql'}: invalid ${what} '${value}'`);
}

module.exports = { IDENT, isIdent, assertIdent };
