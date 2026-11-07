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

// A renamed convar keeps honouring its old qbsql_* spelling so an existing server.cfg still applies.
function getRenamedIntConvar(name, oldName, def) {
    return getIntConvar(name, getIntConvar(oldName, def));
}

function getBoolConvar(name, def) {
    const raw = getConvar(name, null);
    if (raw === null) return def;
    return raw === 'true' || raw === '1' || raw === 'yes';
}

// `ssl` as given in a connection string: a JSON object of mysql2/tls options
// (oxmysql's documented form, e.g. ssl={"rejectUnauthorized":true}), or a
// boolean. `true` enables TLS with certificate verification.
function parseSsl(value) {
    const text = String(value).trim();
    if (/^(?:true|1|yes|required?)$/i.test(text)) return {};
    if (/^(?:false|0|no|off|disabled?)$/i.test(text)) return undefined;
    let parsed;
    try { parsed = JSON.parse(text); } catch (_) { parsed = undefined; }
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) return parsed;
    // Anything else (ssl=preferred, a broken JSON object, ...) must not stop
    // boot: warn and fall back to sslmode semantics or, failing that, to an
    // unencrypted connection (what an unrecognised ssl= value did before).
    if (/^(?:prefer(?:red)?|none)$/i.test(text)) return parseSslMode(text);
    log.warn('config', `connection string option ssl must be true/false or a JSON object, got '${text.slice(0, 64)}'; ignoring it, the connection is NOT encrypted`);
    return undefined;
}

// sslmode in the libpq / MySQL / .NET connector spellings some hosts document
// (mysql-async strings often carry `SslMode=none`).
function parseSslMode(value) {
    const mode = String(value).trim().toLowerCase().replace(/[-_]/g, '');
    if (mode === 'none' || mode === 'disable' || mode === 'disabled') return undefined;
    if (mode === 'prefer' || mode === 'preferred') {
        // mysql2 cannot fall back from TLS to plaintext per connection.
        log.warn('config', `sslmode=${value} is not supported (no opportunistic TLS); the connection is NOT encrypted. Use sslmode=require or ssl={...} to encrypt.`);
        return undefined;
    }
    if (mode === 'require' || mode === 'required') return { rejectUnauthorized: false };
    if (mode === 'verifyca' || mode === 'verifyfull' || mode === 'verifyidentity') return { rejectUnauthorized: true };
    log.warn('config', `unsupported sslmode '${value}' (use disable, require, verify-ca or verify-full); ignoring it, the connection is NOT encrypted`);
    return undefined;
}

// Apply one connection-string option. Only options with a meaning here are
// accepted; anything else is logged, never silently dropped, so an operator
// who copied an oxmysql option knows it had no effect. Pool behaviour
// options (multipleStatements, typeCast, ...) are deliberately NOT honoured
// from the connection string: they are kora_sql convars.
function applyOption(out, key, value) {
    switch (key.toLowerCase()) {
        case 'charset':
            out.charset = value;
            return;
        case 'ssl':
            out.ssl = parseSsl(value);
            return;
        case 'sslmode':
        case 'ssl-mode':
        case 'ssl_mode':
            out.ssl = parseSslMode(value);
            return;
        case 'connecttimeout': {
            const n = parseInt(value, 10);
            if (!Number.isFinite(n) || n <= 0) throw new Error(`qbsql: connectTimeout must be a positive number of milliseconds, got '${value}'`);
            out.connectTimeout = n;
            return;
        }
        default:
            log.warn('config', `mysql_connection_string option '${key}' is not supported by kora_sql and was ignored`);
    }
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
        ssl: undefined,
        connectTimeout: undefined,
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
        for (const [key, value] of u.searchParams) {
            if (key.toLowerCase() === 'charset' && !value) continue;
            applyOption(out, key, value);
        }
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
            else applyOption(out, k, v);
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
        // A separate small pool for the write queue's flush, so ad-hoc writes,
        // transactions and schema work cannot starve player saves. 0 = flush
        // on the write pool (the previous behaviour).
        flushPoolSize: Math.max(0, getIntConvar('kora_sql_flush_pool_size', 4)),
        // Read-pool statement timeout in ms (client side, plus the server's
        // max_execution_time / max_statement_time on read connections). 0 = off.
        queryTimeout: Math.max(0, getIntConvar('kora_sql_query_timeout', 30000)),
        // Longest a query waits for a free pool connection before failing. 0 = forever.
        acquireTimeout: Math.max(0, getIntConvar('kora_sql_acquire_timeout', 30000)),
        // Callers allowed to wait for a connection per pool before new calls fail fast. 0 = unbounded.
        poolQueueLimit: Math.max(0, getIntConvar('kora_sql_pool_queue_limit', 10000)),
        // Concurrent startTransaction callbacks (each pins a write connection for up to 30 s).
        maxStartTransactions: Math.max(0, getIntConvar('kora_sql_max_start_transactions', 0)),
        // Distinct query fingerprints kept by /qbsql stats; older ones fold into <other>.
        statsMaxFingerprints: Math.max(1, getIntConvar('kora_sql_stats_max_fingerprints', 2000)),
        // Check each queued table's conflict key against its PRIMARY/UNIQUE indexes once.
        verifyConflictKeys: getBoolConvar('kora_sql_verify_conflict_keys', true),
        // ensureTable `modify = true` (still owner-only and widening-only).
        schemaAllowModify: getBoolConvar('kora_sql_schema_allow_modify', true),
        statementCache: getRenamedIntConvar('kora_sql_statement_cache', 'qbsql_statement_cache', 256),
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
        // Collation for tables ensureTable CREATES without an explicit collate
        // (existing tables are never altered). Empty = the server's charset default.
        defaultCollate: getConvar('kora_sql_default_collate', 'utf8mb4_unicode_ci'),
        debug: getBoolConvar('qbsql_debug', false),
    };

    log.setDebug(cfg.debug);

    // Default startTransaction cap: leave two write connections for ad-hoc writes.
    if (cfg.maxStartTransactions === 0) cfg.maxStartTransactions = Math.max(1, cfg.writePoolSize - 2);

    // Guard the MySQL prepared-statement ceiling. mysql2 keeps a per-connection
    // prepared-statement cache of `statementCache`; the real server-side count
    // is that times the total connection count. MySQL's max_prepared_stmt_count
    // defaults to 16382. Refuse to start rather than fail opaque later.
    const totalConns = cfg.readPoolSize + cfg.writePoolSize;
    const worstCasePrepared = cfg.statementCache * totalConns;
    // The flush pool only ever runs a few batch statement shapes, so its
    // per-connection cache is small. It must never be the reason a config
    // that booted before now refuses to: without headroom, flush shares the
    // write pool instead.
    cfg.flushStatementCache = Math.min(cfg.statementCache, 64);
    if (cfg.flushPoolSize > 0 && worstCasePrepared <= 8000
        && worstCasePrepared + cfg.flushStatementCache * cfg.flushPoolSize > 8000) {
        log.warn('config', 'kora_sql_flush_pool_size would exceed the prepared-statement ceiling; the queue flush shares the write pool');
        cfg.flushPoolSize = 0;
    }
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

// The pool's connection collation. `charset=utf8mb4` (oxmysql's documented form)
// selects utf8mb4_unicode_ci; a full collation such as `charset=utf8mb4_general_ci`
// is used as given instead of becoming the unknown 'utf8mb4_general_ci_unicode_ci',
// which mysql2 rejects and which left the driver unable to start.
function connectionCollation(charset) {
    const value = String(charset || 'utf8mb4');
    return value.includes('_') ? value : `${value}_unicode_ci`;
}

module.exports = { load, parseConnectionString, connectionCollation, parseSsl, parseSslMode };
