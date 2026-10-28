// The pinned qb-policejob clears this one stash with raw SQL at startup.
// Delegate that exact contract so native cached/dirty inventories cannot revive it.
'use strict';

const DELETE_TRASH = /^\s*DELETE\s+FROM\s+(?:inventories|`inventories`)\s+WHERE\s+(?:identifier|`identifier`)\s*=\s*(?:'([^']*)'|\?|:([A-Za-z_][A-Za-z0-9_]*))\s*;?\s*$/i;

function isPoliceTrashDelete(sql, params) {
    const match = typeof sql === 'string' && DELETE_TRASH.exec(sql);
    if (!match) return false;
    if (match[1] !== undefined) return match[1] === 'policetrash';
    if (match[2]) return params && !Array.isArray(params) && params[match[2]] === 'policetrash';
    return Array.isArray(params) && params.length === 1 && params[0] === 'policetrash';
}

// request must invoke callback(affectedRows, error), never return a Lua promise.
function createLegacyInventoryBridge({ getState, request, onStop }) {
    const pending = new Set();
    onStop((name) => {
        if (name !== 'kora_inventory' && name !== 'kora_sql') return;
        for (const finish of [...pending]) finish(null, `${name} stopped during legacy police trash cleanup`);
    });
    return function legacyInventory(sql, params) {
        if (!isPoliceTrashDelete(sql, params)) return null;
        const state = getState();
        if (state !== 'started' && state !== 'starting') return null;
        // The provider bounds readiness/lock waits. Once durable SQL is in
        // flight, wait for its actual outcome rather than timing out a commit.
        return new Promise((resolve, reject) => {
            let settled = false;
            const finish = (affectedRows, error) => {
                if (settled) return;
                settled = true;
                pending.delete(finish);
                if (error !== undefined && error !== null) return reject(new Error(String(error)));
                if (!Number.isSafeInteger(affectedRows) || affectedRows < 0) {
                    return reject(new Error('qbinventory returned an invalid police trash delete count'));
                }
                resolve({ fieldCount: 0, affectedRows, insertId: 0, info: '', serverStatus: 2,
                    warningStatus: 0, changedRows: 0 });
            };
            pending.add(finish);
            try { request(finish); } catch (error) { finish(null, error.message || String(error)); }
        });
    };
}

module.exports = { isPoliceTrashDelete, createLegacyInventoryBridge };
