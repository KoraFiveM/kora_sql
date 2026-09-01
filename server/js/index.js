// qbsql entry point (the ONLY .js file listed in server_scripts; everything
// else is pulled in via require). Constructs the pools, wires the modules, and
// registers the export surface. On any boot failure it logs loudly and leaves
// isReady() returning false so callers can detect the dead driver rather than
// hang forever.

'use strict';

// FXServer evaluates a server-side JS entry through a resource-root
// `dummy.js`, not this file's on-disk dirname. Relative `./config` imports
// therefore resolve to `<resource>/config.js` and fail even though every
// companion lives under server/js/. Resolve these first-level imports from the
// resource root; once loaded, each real CommonJS module resolves its own local
// dependencies normally.
const cfgLoader = require('./server/js/config');
const poolBuilder = require('./server/js/pool');
const { StatementCache } = require('./server/js/statements');
const { Stats } = require('./server/js/stats');
const { Executor } = require('./server/js/execute');
const { WriteQueue } = require('./server/js/queue');
const { TransactionRunner } = require('./server/js/transaction');
const { Migrator } = require('./server/js/migrate');
const { register } = require('./server/js/exports');
const log = require('./server/js/logger');

// In-memory prepared-handle store for oxmysql's store()/rawExecute(). Handles
// are integers and explicitly do NOT survive a restart (documented refusal).
class HandleStore {
    constructor() { this.map = new Map(); this.next = 1; }
    put(sql) { const h = this.next++; this.map.set(h, sql); return h; }
    get(h) { return this.map.get(h); }
}

const api = {
    _ready: false,
    _readyPromise: null,
    _readyResolve: null,
    _readyReject: null,
    // store() is deliberately synchronous and may be called by a compatibility
    // consumer during resource startup, before the pool's first await settles.
    store: new HandleStore(),

    isReady() { return this._ready; },
    version() {
        return this.pools
            ? { server: this.pools.version.raw, isMariaDB: this.pools.version.isMariaDB, driver: 'qbsql/1.0.0' }
            : { server: 'starting', isMariaDB: false, driver: 'qbsql/1.0.0' };
    },
    ready() { return this._readyPromise; },

    async prepareWarm(sqlList) {
        // Touch each hot statement so its unpreparable-ness is known before the
        // first real call, and so mysql2's per-connection cache is primed.
        let warmed = 0;
        for (const sql of sqlList || []) {
            try {
                // EXPLAIN prepares without mutating -- but not all statements
                // EXPLAIN cleanly, so just run a prepare via execute against a
                // rollback-safe no-op is overkill. Simplest: record it in the
                // LRU as preparable; the first real call primes mysql2.
                this.statements.touch(sql);
                warmed++;
            } catch (_) { /* ignore */ }
        }
        return { warmed };
    },
};

api._readyPromise = new Promise((resolve, reject) => {
    api._readyResolve = resolve;
    api._readyReject = reject;
});
// Attach a swallowing handler so a boot failure (e.g. no DB reachable) does not
// surface as an unhandled promise rejection -- callers observe readiness via
// isReady() polling, and awaitReady() attaches its own handler. Without this, a
// DB-less boot spams the console with unhandled-rejection warnings.
api._readyPromise.catch(() => {});

async function boot() {
    const cfg = cfgLoader.load();
    api.cfg = cfg;
    api.statements = new StatementCache(cfg.statementCache);
    api.stats = new Stats(cfg.slowThreshold, cfg.slowRing);
    const pools = await poolBuilder.build(cfg);
    api.pools = pools;
    api.executor = new Executor(pools, api.statements, api.stats);
    api.queue = new WriteQueue(api.executor, pools, api.stats, cfg);
    api.txn = new TransactionRunner(pools);
    api.migrator = new Migrator(pools);

    // Ensure the bookkeeping tables (qbsql_migrations, qbsql_deadletter) exist
    // before any resource migrates or any write can dead-letter.
    await api.migrator._bootstrap();

    api._ready = true;
    api._readyResolve(true);

    // Tell the Lua side (server/ready.lua) the pool is up.
    emit('qbsql:internal:ready', api.version());
    log.info('index', 'ready.');
}

// Capture FiveM's citizen export registrar HERE, in the entry scope, where the
// bare `exports` global is the citizen function (in a require()'d sub-module it
// would be that module's module.exports instead -- see exports.js's header).
// globalThis.exports covers builds that expose it only as a global.
const registerExport = (typeof exports === 'function')
    ? exports
    : (typeof globalThis !== 'undefined' && typeof globalThis.exports === 'function' ? globalThis.exports : null);

if (!registerExport) {
    log.error('index', 'FiveM export registrar not found on `exports`/`globalThis.exports` -- cannot register the API.');
} else {
    register(api, registerExport);
}

boot().catch((err) => {
    log.error('index', `FAILED TO START: ${err.message}`);
    log.error('index', err.stack || '');
    api._ready = false;
    if (api._readyReject) api._readyReject(err);
});

// Flush everything on resource stop so an intentional restart doesn't drop the
// in-flight queue. Bounded by whatever the runtime allows the handler.
on('onResourceStop', (resourceName) => {
    if (resourceName !== GetCurrentResourceName()) return;
    if (api.queue) {
        api.queue.flush().catch((e) => log.error('index', `stop-flush failed: ${e.message}`));
    }
});
