// Public export surface, registered in one table-driven loop.
//
// Unlike qblib there is no `QB`-style namespace table to walk with a finalise
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

// A Lua resource can stop after it invokes an async export but before qbsql
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
//   * exports.qbsql:queryAsync(sql, params, cb, resource) -> cb(result, errString)
//   * exports.qbsql:query(sql, params, resource)          -> returns a JS promise
//     (FiveM marshals a resolved promise back to a Citizen.Await on the Lua side)
// The last argument is treated as `invokingResource` when it is a string, and as
// a callback when it is callable.
function register(api, exports) {
    // `exports` here is the citizen registrar injected by index.js (the entry
    // file), NOT this module's module.exports -- see the header note.
    if (typeof exports !== 'function') throw new Error('qbsql/exports: registrar not supplied');
    // A data call: (sql, params, [cb], [resource]) in any trailing combination.
    function dataExport(name, impl) {
        exports(name, function (...args) {
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
            const p = Promise.resolve()
                .then(() => impl(...args, resource))
                .then((res) => { reply(name, cb, res, null); return res; })
                .catch((err) => {
                    log.error('exports', `${name} failed: ${err.message}`);
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
        });
    }

    // Best-effort arity of the impl minus its trailing `resource` param, so the
    // resource-peeling above doesn't eat a legitimate string SQL argument.
    function implArity(impl) {
        return Math.max(0, impl.length - 1);
    }

    // --- readiness / version ---
    exports('isReady', () => api.isReady());
    exports('version', () => api.version());
    exports('awaitReady', function (cb) {
        api.ready().then(() => reply('awaitReady', cb, true, null)).catch((e) => reply('awaitReady', cb, false, String(e.message)));
    });

    // --- core data path ---
    dataExport('query', (sql, params, resource) => api.executor.query(sql, params, resource));
    dataExport('single', (sql, params, resource) => api.executor.single(sql, params, resource));
    dataExport('scalar', (sql, params, resource) => api.executor.scalar(sql, params, resource));
    dataExport('execute', (sql, params, resource) => api.executor.execute(sql, params, resource));
    dataExport('insert', (sql, params, resource) => api.executor.insert(sql, params, resource));
    dataExport('update', (sql, params, resource) => api.executor.update(sql, params, resource));

    // --- transaction / batch ---
    dataExport('transaction', (queries, params, resource) => api.txn.transaction(queries, params));
    dataExport('batch', (queries, params, resource) => api.txn.batch(queries, params));

    // --- prepared handle store (in-memory, does NOT survive a restart) ---
    exports('store', (sql) => api.store.put(sql));
    dataExport('rawExecute', (handle, params, resource) => {
        const sql = api.store.get(handle);
        if (!sql) {
            log.warn('exports', `rawExecute called with unknown store handle ${handle} -- did the resource restart?`);
            return Promise.resolve(null);
        }
        return api.executor.execute(sql, params, resource);
    });

    // --- the coalescing write path ---
    exports('enqueue', (table, key, row, opts) => { api.queue.enqueue(table, key, row, opts); });
    exports('enqueueMany', (table, key, rows, opts) => { api.queue.enqueueMany(table, key, rows, opts); });
    dataExport('upsert', (table, key, rows, opts, resource) => {
        // Immediate awaited batched upsert -- same builder as the queue, but
        // flushed now and its result returned.
        api.queue.enqueueMany(table, key, rows, Object.assign({}, opts, { priority: 'normal' }));
        return api.queue.flush(table).then(() => rows.length);
    });
    exports('flush', function (table, cb) {
        if (typeof table === 'function') { cb = table; table = undefined; }
        api.queue.flush(table)
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
