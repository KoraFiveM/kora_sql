// Public export surface, registered in one table-driven loop.
//
// Unlike kora_lib there is no `Kora`-style namespace table to walk with a finalise
// step -- the surface is JS-side, so it is enumerated explicitly here. Every
// data export takes a trailing `invokingResource` argument so the oxmysql/
// mysql-async compat shims can forward the REAL caller (captured via
// GetInvokingResource() at call time in the Lua shim) through to stats.js.
// Without that, every slow query would be attributed to "qbsql".
//
// CRITICAL FiveM DETAIL: FiveM's citizen `exports(name, fn)` registrar is the
// bare `exports` global ONLY in the resource ENTRY file. Inside a require()'d
// CommonJS sub-module (this file), bare `exports` is module.exports and is NOT
// callable -- which is exactly why oxmysql bundles to a single file. Rather than
// bundle, index.js captures the citizen registrar in the entry scope and passes
// it in here as `registerExport`. We never touch bare `exports` in this module.
//
// Callbacks arriving from Lua are invoked as fn(...args, cb); the Lua side
// passes its callback last. The promise-returning path (no cb) is a bonus for
// same-host callers; the Lua wrappers always use the cb path.

'use strict';

const log = require('./logger');

// A Lua resource can stop after it invokes an async export but before kora_sql
// settles it. FiveM then throws when the stale function reference is called.
// Never let that transport-level race become an unhandled Node rejection.
function reply(name, cb, ...args) {
    if (!cb) return;
    try {
        cb(...args);
    } catch (err) {
        log.warn('exports', `${name} reply dropped because the caller stopped: ${err.message}`);
    }
}

// Wrap an async impl so it can be called two ways from Lua:
//   * exports.kora_sql:queryAsync(sql, params, cb, resource) -> cb(result, errString)
//   * exports.kora_sql:query(sql, params, resource)          -> returns a JS promise
//     (FiveM marshals a resolved promise back to a Citizen.Await on the Lua side)
// The last argument is treated as `invokingResource` when it is a string, and as
// a callback when it is callable.
function register(api, exports) {
    // `exports` here is the citizen registrar injected by index.js (the entry
    // file), NOT this module's module.exports -- see the header note.
    if (typeof exports !== 'function') throw new Error('qbsql/exports: registrar not supplied');
    // A data call: (sql, params, [cb], [resource]) in any trailing combination.
    function dataExport(name, impl) {
        const exported = function (...args) {
            // Peel trailing cb / resource off the argument list.
            let cb = null, resource = null;
            while (args.length) {
                const last = args[args.length - 1];
                if (typeof last === 'function' && !cb) { cb = args.pop(); continue; }
                if (typeof last === 'string' && resource === null && args.length > implArity(impl)) {
                    resource = args.pop(); continue;
                }
                break;
            }
            // Export registration happens before the asynchronous pool boot
            // completes. Compatibility consumers commonly issue their first
            // query while their own server script is loading, so every data
            // call must queue behind readiness rather than dereference an
            // executor/transaction/queue that does not exist yet.
            const p = Promise.resolve()
                .then(() => api.ready())
                .then(() => impl(...args, resource))
                .then((res) => { reply(name, cb, res, null); return res; })
                .catch((err) => {
                    // Match oxmysql's useful failure diagnostics: identify the
                    // consumer and SQL without dumping bind values (which may
                    // contain passwords, identifiers, or character data).
                    const sql = typeof args[0] === 'string'
                        ? args[0].replace(/\s+/g, ' ').trim().slice(0, 500)
                        : '<non-SQL call>';
                    log.error('exports', `${name} failed for ${resource || 'unknown'}: ${err.message}; SQL: ${sql}`);
                    if (cb) { reply(name, cb, null, String(err.message)); return null; }
                    // No callback: rethrow so a Citizen.Await on the Lua side rejects.
                    throw err;
                });
            if (!cb) {
                // Fire-and-forget is a legitimate calling pattern here: some
                // Lua callers never attach/await the returned promise. If `p`
                // rejects and nothing ever consumes it, Node reports an
                // unhandled rejection. Attach a no-op catch to `p` itself (not
                // to a derived promise) purely so it counts as "handled";
                // this does not change what `p` resolves/rejects with, so a
                // caller that DOES await/consume it still sees the real
                // result or error.
                p.catch(() => {});
                return p;
            }
        };
        exports(name, exported);
        return exported;
    }

    // oxmysql's `_async` exports are registered by its JS host and return a
    // genuine JS promise. A Lua identity shim cannot safely recreate that
    // cross-runtime promise, so publish only those aliases directly under the
    // provided resource identity. The normal/callback exports remain in the
    // Lua bridge where compatibility convars and the multi-statement guard live.
    function provideForeign(resource, name, fn) {
        if (typeof globalThis.on !== 'function') return;
        globalThis.on(`__cfx_export_${resource}_${name}`, (setCb) => setCb(fn));
    }

    function oxAsync(name, exported) {
        provideForeign('oxmysql', `${name}_async`, (...args) => exported(...args));
    }

    // Best-effort arity of the impl minus its trailing `resource` param, so the
    // resource-peeling above doesn't eat a legitimate string SQL argument.
    function implArity(impl) {
        return Math.max(0, impl.length - 1);
    }

    // Preserve enqueue's synchronous, fire-and-forget hot path once booted,
    // while retaining writes submitted during the short startup window.
    function enqueueWhenReady(name, impl) {
        if (api.isReady()) {
            impl();
            return;
        }
        api.ready()
            .then(impl)
            .catch((err) => log.error('exports', `${name} failed before qbsql became ready: ${err.message}`));
    }

    // --- readiness / version ---
    const isReady = () => api.isReady();
    exports('isReady', isReady);
    exports('version', () => api.version());
    const awaitConnection = function () {
        return Promise.resolve().then(() => api.ready()).then(() => true);
    };
    exports('awaitConnection', awaitConnection);
    provideForeign('oxmysql', 'isReady_async', () => Promise.resolve(isReady()));
    provideForeign('oxmysql', 'awaitConnection_async', awaitConnection);
    exports('awaitReady', function (cb) {
        api.ready().then(() => reply('awaitReady', cb, true, null)).catch((e) => reply('awaitReady', cb, false, String(e.message)));
    });

    // --- core data path ---
    const query = dataExport('query', (sql, params, resource) => api.executor.query(sql, params, resource));
    const single = dataExport('single', (sql, params, resource) => api.executor.single(sql, params, resource));
    const scalar = dataExport('scalar', (sql, params, resource) => api.executor.scalar(sql, params, resource));
    const execute = dataExport('execute', (sql, params, resource) => api.executor.execute(sql, params, resource));
    const insert = dataExport('insert', (sql, params, resource) => api.executor.insert(sql, params, resource));
    const update = dataExport('update', (sql, params, resource) => api.executor.update(sql, params, resource));
    const prepare = dataExport('prepare', (sql, params, resource) => api.executor.prepare(sql, params, resource));

    oxAsync('query', query);
    oxAsync('fetch', query);
    oxAsync('execute', query);
    oxAsync('single', single);
    oxAsync('scalar', scalar);
    oxAsync('insert', insert);
    oxAsync('update', update);
    oxAsync('prepare', prepare);

    // --- transaction / batch ---
    const transaction = dataExport('transaction', (queries, params, resource) => api.txn.transaction(queries, params, resource));
    dataExport('transactionChecked', (queries, operation, resource) => api.txn.transactionChecked(queries, operation));
    dataExport('awaitCheckedOperation', (key, fingerprint, resource) => api.txn.awaitCheckedOperation(key, fingerprint));
    dataExport('awaitCheckedOperations', (prefix, resource) => api.txn.awaitCheckedOperations(prefix));
    exports('hasActivePlayerOperation', (citizenid) => api.txn ? api.txn.hasActivePlayerOperation(citizenid) : false);
    dataExport('batch', (queries, params, resource) => api.txn.batch(queries, params));
    oxAsync('transaction', transaction);

    // --- prepared handle store (in-memory, does NOT survive a restart) ---
    const store = (sql, cb) => {
        const handle = api.store.put(sql);
        reply('store', cb, handle);
        return handle;
    };
    exports('store', store);
    // oxmysql's compatibility store returns the SQL text unchanged. Keep
    // kora_sql's numeric handle store private to the kora_sql identity.
    provideForeign('oxmysql', 'store_async', (sql) => Promise.resolve(sql));
    const rawExecute = dataExport('rawExecute', (handle, params, resource) => {
        const sql = typeof handle === 'number' ? api.store.get(handle) : handle;
        if (typeof sql !== 'string') {
            log.warn('exports', `rawExecute called with unknown store handle ${handle} -- did the resource restart?`);
            return Promise.resolve(null);
        }
        return api.executor.rawExecute(sql, params, resource);
    });
    oxAsync('rawExecute', rawExecute);

    const startTransaction = function (callback, resource) {
        const p = Promise.resolve()
            .then(() => api.ready())
            .then(() => api.txn.startTransaction(callback, resource));
        p.catch(() => {});
        return p;
    };
    exports('startTransaction', startTransaction);
    provideForeign('oxmysql', 'startTransaction_async', startTransaction);

    // --- the coalescing write path ---
    exports('enqueue', (table, key, row, opts) => {
        enqueueWhenReady('enqueue', () => api.queue.enqueue(table, key, row, opts));
    });
    exports('enqueueMany', (table, key, rows, opts) => {
        enqueueWhenReady('enqueueMany', () => api.queue.enqueueMany(table, key, rows, opts));
    });
    dataExport('upsert', (table, key, rows, opts, resource) => {
        // Immediate awaited batched upsert -- same builder as the queue, but
        // flushed now and its result returned.
        api.queue.enqueueMany(table, key, rows, Object.assign({}, opts, { priority: 'normal' }));
        return api.queue.flush(table).then(() => rows.length);
    });
    exports('flush', function (table, cb) {
        if (typeof table === 'function') { cb = table; table = undefined; }
        api.ready()
            .then(() => api.queue.flush(table))
            .then(() => reply('flush', cb, true, null))
            .catch((e) => reply('flush', cb, false, String(e.message)));
    });

    // --- migrations ---
    dataExport('migrate', (resource, migrations) => api.migrator.migrate(resource, migrations));
    dataExport('prepareWarm', (sqlList) => api.prepareWarm(sqlList));

    // --- observability ---
    exports('stats', (cb) => { const s = api.stats.summary(api.statements.summary()); if (cb) cb(s); return s; });
    exports('slowQueries', (limit, cb) => { const s = api.stats.slowQueries(limit); if (cb) cb(s); return s; });
    exports('resetStats', () => api.stats.reset());
}

module.exports = { register };
