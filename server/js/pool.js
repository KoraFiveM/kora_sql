// Connection pool construction and the MySQL version probe.
//
// TWO POOLS, one read and one write, over one DSN. Rationale: writes serialise
// on InnoDB row locks anyway, so a burst of slow analytics SELECTs sharing a
// single pool with the save-flush would starve the flush and turn a 60s save
// window into a 90s one. Split pools make flush latency independent of read
// load. They point at the same database -- this is about scheduling
// independence, not read replicas.

'use strict';

const mysql = require('mysql2/promise');
const log = require('./logger');
const { connectionCollation } = require('./config');

// mysql2 pool options that are NOT optional for correctness in a money-handling
// framework. Each is commented with the specific breakage it prevents.
function poolOptions(cfg, connectionLimit, statementCache) {
    const options = {
        host: cfg.connection.host,
        port: cfg.connection.port,
        user: cfg.connection.user,
        password: cfg.connection.password,
        database: cfg.connection.database,
        charset: connectionCollation(cfg.connection.charset),

        connectionLimit,
        waitForConnections: true,
        // Bounded: during a database stall, new calls fail fast with "Queue
        // limit reached." instead of accumulating in memory without limit.
        // 0 (kora_sql_pool_queue_limit 0) restores the unbounded queue.
        queueLimit: cfg.poolQueueLimit || 0,
        enableKeepAlive: true,
        keepAliveInitialDelay: 10000,

        // connectTimeout bounds how long establishing a NEW physical
        // connection may hang (DB unreachable, network stall, firewall
        // black-hole). The wait for a BUSY connection is bounded separately by
        // withAcquireTimeout() below. Overridable with ?connectTimeout=.
        connectTimeout: cfg.connection.connectTimeout || 10000,

        // The text protocol (parameter-less SQL, the unpreparable fallback)
        // must never expand an object bind into `col = value, ...` assignments
        // (`UPDATE players SET ? ...` with a client-supplied table would
        // mass-assign columns). The binary protocol JSON-encodes objects anyway.
        stringifyObjects: true,

        // mysql2 returns DECIMAL as a STRING by default. Left off, every money
        // column arrives in Lua as "1250.00" and arithmetic silently breaks.
        decimalNumbers: true,
        // BIGINT beyond 2^53 would lose precision as a JS number; keep it a
        // number where safe, never a string (oxmysql normalises the same way,
        // so legacy code expecting numbers keeps working).
        supportBigNumbers: true,
        bigNumberStrings: false,

        // Gives mysql-async's `@name` named-placeholder syntax for free -- the
        // compat layer relies on it.
        namedPlaceholders: true,

        // DATETIME/TIMESTAMP come back as JS Date objects, marshalled to Lua as
        // a number. Configurable divergence from oxmysql's string form is a
        // documented risk (see docs.md); default matches mysql2.
        dateStrings: false,
        timezone: 'Z',

        // Refused by default -- see server/compat/oxmysql.lua's multi-statement
        // refusal. The prepared-statement path (execute) does not permit it
        // regardless; this only governs the query() fallback path.
        multipleStatements: cfg.allowMultipleStatements,

        // Per-connection prepared-statement LRU inside mysql2 itself. Our own
        // statements.js LRU tracks the UNPREPARABLE set on top of this.
        maxPreparedStatements: statementCache || cfg.statementCache,
    };
    // TLS from the connection string (?ssl=... / sslmode=...). Absent = plaintext.
    if (cfg.connection.ssl) options.ssl = cfg.connection.ssl;
    return options;
}

// mysql2 has no acquire timeout: a call waiting for a busy connection waits
// forever. Wrap the pool so execute/query/getConnection race the wait against
// a timer. A connection that arrives after the timeout is released at once.
// The statement itself is not timed here (see the read-pool timeout).
function withAcquireTimeout(pool, ms, name) {
    if (!ms) return pool;
    const acquire = () => new Promise((resolve, reject) => {
        let settled = false;
        const timer = setTimeout(() => {
            if (settled) return;
            settled = true;
            const err = new Error(`qbsql: no ${name} connection became free within ${ms}ms`);
            err.code = 'QBSQL_ACQUIRE_TIMEOUT';
            reject(err);
        }, ms);
        pool.getConnection().then((conn) => {
            clearTimeout(timer);
            if (settled) { conn.release(); return; }
            settled = true;
            resolve(conn);
        }, (err) => {
            clearTimeout(timer);
            if (settled) return;
            settled = true;
            reject(err);
        });
    });
    const run = (method) => async (...args) => {
        const conn = await acquire();
        try {
            return await conn[method](...args);
        } finally {
            conn.release();
        }
    };
    return {
        pool,
        getConnection: acquire,
        execute: run('execute'),
        query: run('query'),
        end: () => pool.end(),
        on: (...args) => pool.on(...args),
    };
}

// Server-side statement limit for READ connections, so a slow SELECT stops on
// the server rather than holding a read connection after its caller gave up.
// MySQL's max_execution_time applies to read-only SELECTs (ms); MariaDB's
// max_statement_time is in seconds.
function sessionTimeoutSql(conn, ms) {
    return conn._isMariaDB
        ? `SET SESSION max_statement_time = ${(ms / 1000).toFixed(3)}`
        : `SET SESSION max_execution_time = ${Math.floor(ms)}`;
}

function limitReadStatements(pool, ms) {
    if (!ms) return;
    let warned = false;
    pool.on('connection', (conn) => {
        // A callback is required: a callback-less core query with no 'error'
        // listener would throw on failure (e.g. a server without the variable).
        conn.query(sessionTimeoutSql(conn, ms), (err) => {
            if (err && !warned) {
                warned = true;
                log.warn('pool', `could not set a server-side read timeout (${err.message}); only the client-side timeout applies`);
            }
        });
    });
}

async function build(cfg) {
    const readRaw = mysql.createPool(poolOptions(cfg, cfg.readPoolSize));
    limitReadStatements(readRaw, cfg.queryTimeout);
    const writeRaw = mysql.createPool(poolOptions(cfg, cfg.writePoolSize));
    const flushRaw = cfg.flushPoolSize > 0
        ? mysql.createPool(poolOptions(cfg, cfg.flushPoolSize, cfg.flushStatementCache))
        : null;
    const read = withAcquireTimeout(readRaw, cfg.acquireTimeout, 'read');
    const write = withAcquireTimeout(writeRaw, cfg.acquireTimeout, 'write');
    const flush = flushRaw ? withAcquireTimeout(flushRaw, cfg.acquireTimeout, 'flush') : null;

    // Probe the server version once. batch.js picks the upsert dialect from
    // this: MySQL 8.0.20+ deprecates VALUES() in ON DUPLICATE KEY UPDATE in
    // favour of the `AS new` alias form, while MariaDB and older MySQL only
    // understand VALUES(). Getting this wrong is a hard SQL error on every
    // single write, so it is probed, not assumed.
    let version = { raw: 'unknown', isMariaDB: false, major: 0, minor: 0, patch: 0 };
    try {
        const [rows] = await read.query('SELECT VERSION() AS v');
        const raw = rows[0].v;
        const isMariaDB = /mariadb/i.test(raw);
        const m = raw.match(/(\d+)\.(\d+)\.(\d+)/);
        version = {
            raw,
            isMariaDB,
            major: m ? parseInt(m[1], 10) : 0,
            minor: m ? parseInt(m[2], 10) : 0,
            patch: m ? parseInt(m[3], 10) : 0,
        };
        log.info('pool', `connected to ${raw} (read=${cfg.readPoolSize} write=${cfg.writePoolSize} flush=${cfg.flushPoolSize || 'shared'}${cfg.connection.ssl ? ' tls' : ''})`);
    } catch (err) {
        // A failed mysql2 pool is not reusable. Close every pool before the
        // startup retry creates fresh pools, otherwise every attempt leaks
        // timers and sockets while the database is unavailable.
        await Promise.allSettled([read.end(), write.end(), flush && flush.end()]);
        throw err;
    }

    return { read, write, flush, version };
}

// Every pool, for shutdown.
function all(pools) {
    return [pools.read, pools.write, pools.flush].filter(Boolean);
}

module.exports = { build, all, poolOptions, withAcquireTimeout, sessionTimeoutSql };
