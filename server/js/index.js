// kora_sql entry point (the ONLY .js file listed in server_scripts; everything
// else is pulled in via require). Constructs the pools, wires the modules, and
// registers the export surface. On any boot failure it logs loudly and leaves
// isReady() returning false so callers can detect the dead driver rather than
// hang forever.

'use strict';

// The source modules use ordinary file-relative imports. The release build is
// a single resource-root dist/build.js, so FXServer never has to resolve these
// requires through its synthetic dummy.js entry module.
const cfgLoader = require('./config');
const poolBuilder = require('./pool');
const { StatementCache } = require('./statements');
const { Stats } = require('./stats');
const { Executor } = require('./execute');
const { createLegacyInventoryBridge } = require('./legacy-inventory');
const { createLegacyHousingBridge } = require('./legacy-housing');
const { WriteQueue } = require('./queue');
const { TransactionRunner } = require('./transaction');
const { SchemaManager } = require('./schema');

const DEADLETTER_TABLE = {
    name: 'kora_sql_deadletter',
    columns: [
        { name: 'id', type: 'bigint', unsigned: true, auto_increment: true },
        { name: 'table_name', type: 'varchar(64)' },
        { name: 'pk', type: 'varchar(191)' },
        { name: 'cols_json', type: 'longtext' },
        { name: 'error', type: 'varchar(500)', null: true, default: null },
        { name: 'failed_at', type: 'timestamp', default: { raw: 'CURRENT_TIMESTAMP' } },
    ],
    primary: ['id'],
    indexes: [{ name: 'idx_deadletter_table', columns: ['table_name'] }],
};
const { register } = require('./exports');
const { connectWithRetry } = require('./startup');
const log = require('./logger');

let stopping = false;

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
    const pools = await connectWithRetry(poolBuilder.build, cfg, {
        retryInterval: cfg.connectRetryInterval,
        shouldStop: () => stopping,
        onRetry: (err, attempt, retryInterval) => {
            log.warn(
                'pool',
                `database unavailable (${err.code || err.message}); retry ${attempt} in ${retryInterval}ms`
            );
        },
    });
    api.pools = pools;
    const legacyInventory = createLegacyInventoryBridge({
        getState: () => GetResourceState('kora_inventory'),
        request: (callback) => registerExport.qbinventory.deleteLegacyPoliceTrash(callback),
        onStop: (callback) => on('onResourceStop', callback),
    });
    const legacyHousing = createLegacyHousingBridge({
        getState: () => GetResourceState('kora_housing'),
        request: (operation, args, callback) => registerExport.qbhousing.readLegacyHousing(operation, args, callback),
        onStop: (callback) => on('onResourceStop', callback),
    });
    api.executor = new Executor(pools, api.statements, api.stats, legacyInventory, legacyHousing);
    api.queue = new WriteQueue(api.executor, pools, api.stats, cfg);
    api.txn = new TransactionRunner(pools);
    api.schema = new SchemaManager(pools);

    // The dead-letter table must exist before any write can dead-letter.
    await api.schema.ensureTable(DEADLETTER_TABLE, 'kora_sql');

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
// Bundlers execute this inside their own CommonJS wrapper, where bare
// `exports` may be module.exports. Oxmysql solves the same problem by reading
// the citizen registrar from the global object; prefer that path here too.
const registerExport = (typeof globalThis.exports === 'function')
    ? globalThis.exports
    : (typeof exports === 'function' ? exports : null);

if (!registerExport) {
    log.error('index', 'FiveM export registrar not found on `exports`/`globalThis.exports` -- cannot register the API.');
} else {
    register(api, registerExport);
}

boot().catch((err) => {
    if (err.code === 'QBSQL_STOPPING') return;
    log.error('index', `FAILED TO START: ${err.message}`);
    log.error('index', err.stack || '');
    api._ready = false;
    api._readyReject(err);
});

// Flush everything on resource stop so an intentional restart doesn't drop the
// in-flight queue. Bounded by whatever the runtime allows the handler.
on('onResourceStop', (resourceName) => {
    if (resourceName !== GetCurrentResourceName()) return;
    stopping = true;
    if (api.queue) {
        api.queue.flush().catch((e) => log.error('index', `stop-flush failed: ${e.message}`));
    }
});
