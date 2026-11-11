'use strict';

const log = require('./logger');

function reply(name, cb, ...args) {
    if (!cb) return;
    try {
        cb(...args);
    } catch (err) {
        log.warn('exports', `${name} reply dropped because the caller stopped: ${err.message}`);
    }
}

function register(api, exports, opts = {}) {
    if (typeof exports !== 'function') throw new Error('kora_sql/exports: registrar not supplied');

    const getInvoker = opts.getInvokingResource
        || (typeof globalThis.GetInvokingResource === 'function' ? () => globalThis.GetInvokingResource() : null);
    const self = opts.currentResource
        || (typeof globalThis.GetCurrentResourceName === 'function' ? globalThis.GetCurrentResourceName() : null);
    const warnedClaims = new Set();
    function verifiedCaller(claimed) {
        if (!getInvoker) return claimed;
        let invoker = null;
        try { invoker = getInvoker(); } catch (_) {  }
        if (!invoker || invoker === self) return claimed;
        if (typeof claimed === 'string' && claimed !== invoker && !warnedClaims.has(invoker)) {
            warnedClaims.add(invoker);
            log.warn('exports', `${invoker} passed '${claimed}' as its resource name; using the real caller '${invoker}'`);
        }
        return invoker;
    }

    const PRE_READY_ENQUEUE_LIMIT = 100000;
    let preReadyEnqueues = 0;
    let preReadyDropped = 0;
    function dataExport(name, impl) {
        const exported = function (...args) {
            let cb = null, resource = null;
            while (args.length) {
                const last = args[args.length - 1];
                if (typeof last === 'function' && !cb) { cb = args.pop(); continue; }
                if ((last === null || last === undefined) && args.length > implArity(impl)) {
                    args.pop(); continue;
                }
                if (typeof last === 'string' && resource === null && args.length > implArity(impl)) {
                    resource = args.pop(); continue;
                }
                break;
            }
            resource = verifiedCaller(resource);
            const p = Promise.resolve()
                .then(() => api.ready())
                .then(() => impl(...args, resource))
                .then((res) => { reply(name, cb, res, null); return res; })
                .catch((err) => {
                    const sql = typeof args[0] === 'string'
                        ? args[0].replace(/\s+/g, ' ').trim().slice(0, 500)
                        : '<non-SQL call>';
                    log.error('exports', `${name} failed for ${resource || 'unknown'}: ${err.message}; SQL: ${sql}`);
                    if (cb) { reply(name, cb, null, String(err.message)); return null; }
                    throw err;
                });
            if (!cb) {
                p.catch(() => {});
                return p;
            }
        };
        exports(name, exported);
        return exported;
    }

    function provideForeign(resource, name, fn) {
        if (typeof globalThis.on !== 'function') return;
        globalThis.on(`__cfx_export_${resource}_${name}`, (setCb) => setCb(fn));
    }

    function oxAsync(name, exported) {
        provideForeign('oxmysql', `${name}_async`, (...args) => exported(...args));
    }

    function implArity(impl) {
        return Math.max(0, impl.length - 1);
    }

    function enqueueWhenReady(name, impl) {
        if (api.isReady()) {
            impl();
            return;
        }
        if (preReadyEnqueues >= PRE_READY_ENQUEUE_LIMIT) {
            preReadyDropped++;
            if (preReadyDropped === 1) {
                log.error('exports', `kora_sql: ${name} dropped: ${PRE_READY_ENQUEUE_LIMIT} writes are already waiting for the database to become ready`);
            }
            return;
        }
        preReadyEnqueues++;
        api.ready()
            .then(impl)
            .catch((err) => log.error('exports', `${name} failed before kora_sql became ready: ${err.message}`))
            .finally(() => {
                preReadyEnqueues--;
                if (preReadyEnqueues === 0 && preReadyDropped > 0) {
                    log.error('exports', `kora_sql: ${preReadyDropped} fire-and-forget write(s) were dropped while waiting for the database`);
                    preReadyDropped = 0;
                }
            });
    }

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

    const query = dataExport('query', (sql, params, resource) => api.executor.query(sql, params, resource));
    const single = dataExport('single', (sql, params, resource) => api.executor.single(sql, params, resource));
    const scalar = dataExport('scalar', (sql, params, resource) => api.executor.scalar(sql, params, resource));
    const execute = dataExport('execute', (sql, params, resource) => api.executor.execute(sql, params, resource));
    const insert = dataExport('insert', (sql, params, resource) => api.executor.insert(sql, params, resource));
    const update = dataExport('update', (sql, params, resource) => api.executor.update(sql, params, resource));
    const prepare = dataExport('prepare', (sql, params, resource) => api.executor.prepare(sql, params, resource));

    const oxExec = () => (api.cfg && api.cfg.oxTypeCast === false
        ? api.executor
        : api.executor.withOxTypeCast());
    const oxQuery = dataExport('oxQuery', (sql, params, resource) => oxExec().query(sql, params, resource));
    const oxSingle = dataExport('oxSingle', (sql, params, resource) => oxExec().single(sql, params, resource));
    const oxScalar = dataExport('oxScalar', (sql, params, resource) => oxExec().scalar(sql, params, resource));
    const oxInsert = dataExport('oxInsert', (sql, params, resource) => oxExec().insert(sql, params, resource));
    const oxUpdate = dataExport('oxUpdate', (sql, params, resource) => oxExec().update(sql, params, resource));
    const oxPrepare = dataExport('oxPrepare', (sql, params, resource) => oxExec().prepare(sql, params, resource));

    oxAsync('query', oxQuery);
    oxAsync('fetch', oxQuery);
    oxAsync('execute', oxQuery);
    oxAsync('single', oxSingle);
    oxAsync('scalar', oxScalar);
    oxAsync('insert', oxInsert);
    oxAsync('update', oxUpdate);
    oxAsync('prepare', oxPrepare);

    const transaction = dataExport('transaction', (queries, params, resource) => api.txn.transaction(queries, params, resource));
    dataExport('transactionChecked', (queries, operation, resource) => api.txn.transactionChecked(queries, operation));
    dataExport('awaitCheckedOperation', (key, fingerprint, resource) => api.txn.awaitCheckedOperation(key, fingerprint));
    dataExport('awaitCheckedOperations', (prefix, resource) => api.txn.awaitCheckedOperations(prefix));
    exports('hasActivePlayerOperation', (citizenid) => api.txn ? api.txn.hasActivePlayerOperation(citizenid) : false);
    dataExport('batch', (queries, params, resource) => api.txn.batch(queries, params));
    oxAsync('transaction', transaction);

    const store = (sql, cb) => {
        const handle = api.store.put(sql);
        reply('store', cb, handle);
        return handle;
    };
    exports('store', store);
    provideForeign('oxmysql', 'store_async', (sql) => Promise.resolve(sql));
    const rawExecute = dataExport('rawExecute', (handle, params, resource) => {
        const sql = typeof handle === 'number' ? api.store.get(handle) : handle;
        if (typeof sql !== 'string') {
            log.warn('exports', `rawExecute called with unknown store handle ${handle} -- did the resource restart?`);
            return Promise.resolve(null);
        }
        return api.executor.rawExecute(sql, params, resource);
    });
    const oxRawExecute = dataExport('oxRawExecute', (handle, params, resource) => {
        const sql = typeof handle === 'number' ? api.store.get(handle) : handle;
        if (typeof sql !== 'string') {
            log.warn('exports', `oxRawExecute called with unknown store handle ${handle} -- did the resource restart?`);
            return Promise.resolve(null);
        }
        return oxExec().rawExecute(sql, params, resource);
    });
    oxAsync('rawExecute', oxRawExecute);

    const startTransaction = function (callback, resource) {
        resource = verifiedCaller(typeof resource === 'string' ? resource : null);
        const p = Promise.resolve()
            .then(() => api.ready())
            .then(() => api.txn.startTransaction(callback, resource));
        p.catch(() => {});
        return p;
    };
    exports('startTransaction', startTransaction);
    provideForeign('oxmysql', 'startTransaction_async', startTransaction);

    function safeEnqueue(name, impl) {
        try {
            enqueueWhenReady(name, () => {
                try { impl(); } catch (err) { log.error('exports', `${name} failed: ${err && err.message}`); }
            });
        } catch (err) {
            log.error('exports', `${name} failed: ${err && err.message}`);
        }
    }
    exports('enqueue', (table, key, row, opts) => {
        const resource = verifiedCaller(null);
        safeEnqueue('enqueue', () => api.queue.enqueue(table, key, row, opts, resource));
    });
    exports('enqueueMany', (table, key, rows, opts) => {
        const resource = verifiedCaller(null);
        safeEnqueue('enqueueMany', () => api.queue.enqueueMany(table, key, rows, opts, resource));
    });
    dataExport('upsert', (table, key, rows, opts, resource) => {
        api.queue.enqueueMany(table, key, rows, Object.assign({}, opts, { priority: 'normal', strict: true }), resource);
        return api.queue.flush(table).then(() => rows.length);
    });
    exports('flush', function (table, cb) {
        if (typeof table === 'function') { cb = table; table = undefined; }
        api.ready()
            .then(() => api.queue.flush(table))
            .then(() => reply('flush', cb, true, null))
            .catch((e) => reply('flush', cb, false, String(e.message)));
    });

    dataExport('ensureTable', (spec, resource) => api.schema.ensureTable(spec, resource));
    dataExport('ensureTables', (specs, resource) => api.schema.ensureTables(specs, resource));
    dataExport('awaitTables', (names, timeoutMs, resource) => api.schema.awaitTables(names, timeoutMs, resource));
    dataExport('prepareWarm', (sqlList) => api.prepareWarm(sqlList));

    exports('stats', (cb) => { const s = api.stats && api.statements ? api.stats.summary(api.statements.summary()) : null; if (cb) cb(s); return s; });
    exports('slowQueries', (limit, cb) => { const s = api.stats ? api.stats.slowQueries(limit) : []; if (cb) cb(s); return s; });
    exports('resetStats', () => { if (api.stats) api.stats.reset(); });
}

module.exports = { register };
