'use strict';

// Reviewed stock reads only. Native housing remains the sole write authority;
// the original stock tables are an import archive, not a second live database.
function stockRead(sql, params) {
    if (typeof sql !== 'string') return null;
    const text = sql.trim().replace(/;$/, '').trim()
        .replace(/`(houselocations|player_houses|name|house|owned|identifier|citizenid)`/gi, '$1')
        .replace(/\s+/g, ' ').replace(/\s*=\s*/g, ' = ');
    const bind = '(\\?|:[A-Za-z_][A-Za-z0-9_]*)';
    const specs = [
        [/^SELECT \* FROM houselocations$/i, 'locations'],
        [new RegExp('^SELECT \\* FROM houselocations WHERE name = ' + bind + '$', 'i'), 'location'],
        [new RegExp('^SELECT owned FROM houselocations WHERE name = ' + bind + '$', 'i'), 'owned'],
        [new RegExp('^SELECT \\* FROM houselocations WHERE name LIKE ' + bind + ' ORDER BY LENGTH\\(name\\) desc, name DESC$', 'i'), 'locations_like'],
        [/^SELECT \* FROM player_houses$/i, 'owners'],
        [new RegExp('^SELECT \\* FROM player_houses WHERE house = ' + bind + '$', 'i'), 'house'],
        [new RegExp('^SELECT \\* FROM player_houses WHERE citizenid = ' + bind + '$', 'i'), 'citizen'],
        [new RegExp('^SELECT \\* FROM player_houses WHERE identifier = ' + bind + ' AND citizenid = ' + bind + '$', 'i'), 'identity'],
    ];
    for (const [pattern, operation] of specs) {
        const match = pattern.exec(text);
        if (!match) continue;
        const args = [];
        for (const token of match.slice(1)) {
            const value = token === '?' ? Array.isArray(params) && params[args.length]
                : params && !Array.isArray(params) && params[token.slice(1)];
            if (typeof value !== 'string' || !value.length || value.length > 255) return null;
            args.push(value);
        }
        if (Array.isArray(params) && params.length !== args.length) return null;
        return { operation, args };
    }
    return null;
}

function touchesStockTables(sql) {
    if (typeof sql !== 'string') return false;
    // Mask values/comments before looking for table identifiers, so ordinary
    // data mentioning a stock table never changes an unrelated query's route.
    const code = sql.replace(/'(?:\\.|''|[^'\\])*'|"(?:\\.|""|[^"\\])*"|\/\*[\s\S]*?\*\/|--[^\n]*(?:\n|$)|#[^\n]*(?:\n|$)/g, ' ');
    // Any mention of either table name in the remaining SQL text. Anchoring on
    // FROM/JOIN/UPDATE/INTO/TABLE missed `INSERT player_houses`, `REPLACE ...`,
    // `TRUNCATE player_houses` and comma joins. This fails closed: a column or
    // alias that happens to use one of these names is rejected rather than
    // let through, which is the right direction for a guard.
    return /\b(?:houselocations|player_houses)\b/i.test(code);
}

function createLegacyHousingBridge({ getState, request, onStop }) {
    const pending = new Set();
    let selected = false;
    onStop((name) => {
        if (name !== 'kora_housing' && name !== 'kora_sql') return;
        if (name === 'kora_housing') selected = true;
        for (const finish of [...pending]) finish(null, `${name} stopped during legacy housing read`);
    });
    return function legacyHousing(sql, params, resource) {
        // The original export caller. exports.js derives it from
        // GetInvokingResource() and only trusts a forwarded name when kora_sql's
        // own compat shims made the call, so another resource cannot claim to be
        // kora_housing. The owner must read its archive during import before it
        // becomes ready.
        if (resource === 'kora_housing' || !touchesStockTables(sql)) return null;
        const state = getState();
        if (state === 'started' || state === 'starting') selected = true;
        else if (!selected) return null;
        else return Promise.reject(new Error('Native housing stopped; stock tables are archival'));
        const read = stockRead(sql, params);
        if (!read) return Promise.reject(new Error('Unsupported stock housing SQL while native housing owns these records'));
        return new Promise((resolve, reject) => {
            let settled = false;
            const finish = (rows, error) => {
                if (settled) return;
                settled = true;
                pending.delete(finish);
                if (error !== undefined && error !== null) return reject(new Error(String(error)));
                // FiveM can marshal a Lua empty array as an empty object.
                if (rows && !Array.isArray(rows) && typeof rows === 'object' && Object.keys(rows).length === 0) rows = [];
                if (!Array.isArray(rows) || rows.some((row) => !row || typeof row !== 'object' || Array.isArray(row))) {
                    return reject(new Error('Native housing returned invalid SQL rows'));
                }
                resolve(rows);
            };
            pending.add(finish);
            try { request(read.operation, read.args, finish); }
            catch (error) { finish(null, error.message || String(error)); }
        });
    };
}

module.exports = { stockRead, touchesStockTables, createLegacyHousingBridge };
