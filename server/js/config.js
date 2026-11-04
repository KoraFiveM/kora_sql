// Boot-time configuration for the JS runtime.
//
// WHY CONVARS, NOT config.lua: the Node scripting host cannot read Lua's
// `Config` table -- they are separate script hosts in the same process with
// no shared globals. Two alternatives were rejected (see AGENTS.md):
//   * pushing Config into JS via an export at boot -> a startup race where an
//     early query from another resource arrives before the pool is built;
//   * a second JSON config file -> a second config format in a codebase that
//     has exactly one (config.lua).
// Convars are read synchronously here, before the pool is constructed, so the
// pool is guaranteed to exist before any export can be serviced.
//
// The connection string convar is deliberately named `mysql_connection_string`
// -- the exact name oxmysql uses -- so an existing server.cfg migrates with no
// edit. Both the oxmysql URI form and the semicolon key=value form are parsed.

'use strict';

const log = require('./logger');

function getConvar(name, def) {
    // GetConvar is a FiveM native exposed to the JS host as a global.
    const v = GetConvar(name, '\x00');
    return v === '\x00' ? def : v;
}

function getIntConvar(name, def) {
    const raw = getConvar(name, null);
    if (raw === null) return def;
    const n = parseInt(raw, 10);
    return Number.isFinite(n) ? n : def;
}

function getBoolConvar(name, def) {
    const raw = getConvar(name, null);
    if (raw === null) return def;
    return raw === 'true' || raw === '1' || raw === 'yes';
}

// Parse either mysql://user:pass@host:port/db?flags  OR  the legacy
// semicolon form: host=…;user=…;password=…;database=…;port=…
function parseConnectionString(str) {
    if (!str) {
        throw new Error(
            'qbsql: no `mysql_connection_string` convar set. Add e.g. ' +
            "`set mysql_connection_string \"mysql://user:pass@localhost/qbcore?charset=utf8mb4\"` to server.cfg."
        );
    }

    const out = {
        host: '127.0.0.1',
        port: 3306,
        user: 'root',
        password: '',
        database: undefined,
        charset: 'utf8mb4',
    };

    if (str.startsWith('mysql://') || str.startsWith('mariadb://')) {
        const u = new URL(str);
        out.host = decodeURIComponent(u.hostname) || out.host;
        out.port = u.port ? parseInt(u.port, 10) : out.port;
        out.user = decodeURIComponent(u.username) || out.user;
        out.password = decodeURIComponent(u.password) || '';
        out.database = u.pathname && u.pathname.length > 1
            ? decodeURIComponent(u.pathname.slice(1))
            : undefined;
        const cs = u.searchParams.get('charset');
        if (cs) out.charset = cs;
    } else {
        // Legacy semicolon form.
        for (const pair of str.split(';')) {
            const eq = pair.indexOf('=');
            if (eq === -1) continue;
            const k = pair.slice(0, eq).trim().toLowerCase();
            const v = pair.slice(eq + 1).trim();
            if (k === 'host' || k === 'server') out.host = v;
            else if (k === 'port') out.port = parseInt(v, 10);
            else if (k === 'user' || k === 'uid' || k === 'userid') out.user = v;
            else if (k === 'password' || k === 'pwd') out.password = v;
            else if (k === 'database' || k === 'db') out.database = v;
            else if (k === 'charset') out.charset = v;
        }
    }

    if (!out.database) {
        throw new Error('qbsql: connection string is missing a database name.');
    }

    return out;
}

function load() {
    const connection = parseConnectionString(getConvar('mysql_connection_string', null));

    const cfg = {
        connection,
        readPoolSize: getIntConvar('qbsql_read_pool_size', 16),
        writePoolSize: getIntConvar('qbsql_write_pool_size', 8),
        statementCache: getIntConvar('kora_sql_statement_cache', 256),
        flushInterval: getIntConvar('qbsql_flush_interval', 250),
        maxPendingRows: getIntConvar('qbsql_max_pending_rows', 500),
        maxRowsPerStatement: getIntConvar('qbsql_max_rows_per_statement', 200),
        maxPlaceholders: getIntConvar('qbsql_max_placeholders', 60000),
        padToBuckets: getBoolConvar('qbsql_pad_to_buckets', true),
        slowThreshold: getIntConvar('qbsql_slow_threshold', 150),
        slowRing: getIntConvar('qbsql_slow_ring', 200),
        allowMultipleStatements: getBoolConvar('qbsql_allow_multiple_statements', false),
        connectRetryInterval: Math.max(250, getIntConvar('qbsql_connect_retry_interval', 2000)),
        // oxmysql-style typeCast on the oxmysql compat exports only (default on, like oxmysql).
        oxTypeCast: getBoolConvar('kora_sql_ox_typecast', true),
        debug: getBoolConvar('qbsql_debug', false),
    };

    log.setDebug(cfg.debug);

    // Guard the MySQL prepared-statement ceiling. mysql2 keeps a per-connection
    // prepared-statement cache of `statementCache`; the real server-side count
    // is that times the total connection count. MySQL's max_prepared_stmt_count
    // defaults to 16382. Refuse to start rather than fail opaque later.
    const totalConns = cfg.readPoolSize + cfg.writePoolSize;
    const worstCasePrepared = cfg.statementCache * totalConns;
    if (worstCasePrepared > 8000) {
        throw new Error(
            `qbsql: kora_sql_statement_cache (${cfg.statementCache}) x total connections (${totalConns}) ` +
            `= ${worstCasePrepared} prepared statements, over the safe ceiling of 8000 ` +
            `(MySQL max_prepared_stmt_count defaults to 16382, and it is GLOBAL on a shared host). ` +
            `Lower kora_sql_statement_cache or the pool sizes.`
        );
    }

    return cfg;
}

module.exports = { load, parseConnectionString };
