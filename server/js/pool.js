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

// mysql2 pool options that are NOT optional for correctness in a money-handling
// framework. Each is commented with the specific breakage it prevents.
function poolOptions(cfg, connectionLimit) {
    return {
        host: cfg.connection.host,
        port: cfg.connection.port,
        user: cfg.connection.user,
        password: cfg.connection.password,
        database: cfg.connection.database,
        charset: `${cfg.connection.charset}_unicode_ci`,

        connectionLimit,
        waitForConnections: true,
        queueLimit: 0,                 // unbounded queue -- we cap upstream in the queue module.
        enableKeepAlive: true,
        keepAliveInitialDelay: 10000,

        // mysql2 has no separate "acquire" timeout for a getConnection() call
        // that is queued waiting for a busy connection to free up (queueLimit
        // above is unbounded, and that wait is genuinely open-ended -- not
        // something this option fixes). What connectTimeout DOES bound is how
        // long establishing a NEW physical connection may hang (DB
        // unreachable, network stall, firewall black-hole): without it a
        // stuck TCP handshake can hang far longer than is useful. Made
        // explicit here rather than relying on mysql2's implicit default so
        // the behaviour is documented and easy to find.
        connectTimeout: 10000,

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
        maxPreparedStatements: cfg.statementCache,
    };
}

async function build(cfg) {
    const read = mysql.createPool(poolOptions(cfg, cfg.readPoolSize));
    const write = mysql.createPool(poolOptions(cfg, cfg.writePoolSize));

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
        log.info('pool', `connected to ${raw} (read=${cfg.readPoolSize} write=${cfg.writePoolSize})`);
    } catch (err) {
        // A failed mysql2 pool is not reusable. Close both sides before the
        // startup retry creates fresh pools, otherwise every attempt leaks
        // timers and sockets while the database is unavailable.
        await Promise.allSettled([read.end(), write.end()]);
        throw err;
    }

    return { read, write, version };
}

module.exports = { build };
