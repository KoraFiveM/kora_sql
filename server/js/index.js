'use strict';

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
const SCHEMA_OWNERS_TABLE = {
    name: 'kora_sql_schema_owners',
    columns: [
        { name: 'table_name', type: 'varchar(64)' },
        { name: 'resource', type: 'varchar(64)' },
        { name: 'claimed_at', type: 'timestamp', default: { raw: 'CURRENT_TIMESTAMP' } },
    ],
    primary: ['table_name'],
};
const { register } = require('./exports');
const { connectWithRetry } = require('./startup');
const log = require('./logger');

let stopping = false;

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
    store: new HandleStore(),

    isReady() { return this._ready; },
    version() {
        return this.pools
            ? { server: this.pools.version.raw, isMariaDB: this.pools.version.isMariaDB, driver: 'kora_sql/1.0.0' }
            : { server: 'starting', isMariaDB: false, driver: 'kora_sql/1.0.0' };
    },
    ready() { return this._readyPromise; },

    async prepareWarm(sqlList) {
        let warmed = 0;
        for (const sql of sqlList || []) {
            try {
                this.statements.touch(sql);
                warmed++;
            } catch (_) {  }
        }
        return { warmed };
    },
};

api._readyPromise = new Promise((resolve, reject) => {
    api._readyResolve = resolve;
    api._readyReject = reject;
});
api._readyPromise.catch(() => {});

async function boot() {
    const cfg = cfgLoader.load();
    api.cfg = cfg;
    api.statements = new StatementCache(cfg.statementCache);
    api.stats = new Stats(cfg.slowThreshold, cfg.slowRing, cfg.statsMaxFingerprints);
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
    if (stopping) {
        await Promise.allSettled(poolBuilder.all(pools).map((pool) => pool.end()));
        const stopped = new Error('kora_sql stopped while waiting for the database');
        stopped.code = 'KORA_SQL_STOPPING';
        throw stopped;
    }
    api.pools = pools;
    const legacyInventory = createLegacyInventoryBridge({
        getState: () => GetResourceState('kora_inventory'),
        request: (callback) => registerExport.kora_inventory.deleteLegacyPoliceTrash(callback),
        onStop: (callback) => on('onResourceStop', callback),
    });
    const legacyHousing = createLegacyHousingBridge({
        getState: () => GetResourceState('kora_housing'),
        request: (operation, args, callback) => registerExport.kora_housing.readLegacyHousing(operation, args, callback),
        onStop: (callback) => on('onResourceStop', callback),
    });
    api.executor = new Executor(pools, api.statements, api.stats, legacyInventory, legacyHousing);
    api.executor.readTimeout = cfg.queryTimeout;
    api.queue = new WriteQueue(api.executor, pools, api.stats, cfg);
    api.txn = new TransactionRunner(pools, { statements: api.statements, maxStartTransactions: cfg.maxStartTransactions });
    api.schema = new SchemaManager(pools, {
        createCollate: cfg.defaultCollate,
        allowModify: cfg.schemaAllowModify,
        ownersTable: SCHEMA_OWNERS_TABLE.name,
    });

    await connectWithRetry(async () => {
        await api.schema.ensureTable(SCHEMA_OWNERS_TABLE, 'kora_sql');
        await api.schema.ensureTable(DEADLETTER_TABLE, 'kora_sql');
    }, cfg, {
        retryInterval: cfg.connectRetryInterval,
        shouldStop: () => stopping,
        onRetry: (err, attempt, retryInterval) => {
            log.warn('index', `dead-letter table setup failed (${err.code || err.message}); retry ${attempt} in ${retryInterval}ms`);
        },
    });

    api._ready = true;
    api._readyResolve(true);

    emit('kora_sql:internal:ready', api.version());
    log.info('index', 'ready.');
}

const registerExport = (typeof globalThis.exports === 'function')
    ? globalThis.exports
    : (typeof exports === 'function' ? exports : null);

if (!registerExport) {
    log.error('index', 'FiveM export registrar not found on `exports`/`globalThis.exports` -- cannot register the API.');
} else {
    register(api, registerExport);
}

boot().catch((err) => {
    if (err.code === 'KORA_SQL_STOPPING') return;
    log.error('index', `FAILED TO START: ${err.message}`);
    log.error('index', err.stack || '');
    api._ready = false;
    api._readyReject(err);
});

on('onResourceStop', (resourceName) => {
    if (resourceName !== GetCurrentResourceName()) return;
    stopping = true;
    const pools = api.pools;
    const drained = api.queue
        ? api.queue.flush().catch((e) => log.error('index', `stop-flush failed: ${e.message}`))
        : Promise.resolve();
    if (pools) drained.finally(() => Promise.allSettled(poolBuilder.all(pools).map((pool) => pool.end())));
});
