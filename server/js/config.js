'use strict';

const log = require('./logger');

function getConvar(name, def) {
    const v = GetConvar(name, '\x00');
    return v === '\x00' ? def : v;
}

function getIntConvar(name, def) {
    const raw = getConvar(name, null);
    if (raw === null) return def;
    const n = parseInt(raw, 10);
    return Number.isFinite(n) ? n : def;
}

function getRenamedIntConvar(name, oldName, def) {
    return getIntConvar(name, getIntConvar(oldName, def));
}

function getBoolConvar(name, def) {
    const raw = getConvar(name, null);
    if (raw === null) return def;
    return raw === 'true' || raw === '1' || raw === 'yes';
}

function parseSsl(value) {
    const text = String(value).trim();
    if (/^(?:true|1|yes|required?)$/i.test(text)) return {};
    if (/^(?:false|0|no|off|disabled?)$/i.test(text)) return undefined;
    let parsed;
    try { parsed = JSON.parse(text); } catch (_) { parsed = undefined; }
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) return parsed;
    if (/^(?:prefer(?:red)?|none)$/i.test(text)) return parseSslMode(text);
    log.warn('config', `connection string option ssl must be true/false or a JSON object, got '${text.slice(0, 64)}'; ignoring it, the connection is NOT encrypted`);
    return undefined;
}

function parseSslMode(value) {
    const mode = String(value).trim().toLowerCase().replace(/[-_]/g, '');
    if (mode === 'none' || mode === 'disable' || mode === 'disabled') return undefined;
    if (mode === 'prefer' || mode === 'preferred') {
        log.warn('config', `sslmode=${value} is not supported (no opportunistic TLS); the connection is NOT encrypted. Use sslmode=require or ssl={...} to encrypt.`);
        return undefined;
    }
    if (mode === 'require' || mode === 'required') return { rejectUnauthorized: false };
    if (mode === 'verifyca' || mode === 'verifyfull' || mode === 'verifyidentity') return { rejectUnauthorized: true };
    log.warn('config', `unsupported sslmode '${value}' (use disable, require, verify-ca or verify-full); ignoring it, the connection is NOT encrypted`);
    return undefined;
}

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
        flushPoolSize: Math.max(0, getIntConvar('kora_sql_flush_pool_size', 4)),
        queryTimeout: Math.max(0, getIntConvar('kora_sql_query_timeout', 30000)),
        acquireTimeout: Math.max(0, getIntConvar('kora_sql_acquire_timeout', 30000)),
        poolQueueLimit: Math.max(0, getIntConvar('kora_sql_pool_queue_limit', 10000)),
        maxStartTransactions: Math.max(0, getIntConvar('kora_sql_max_start_transactions', 0)),
        statsMaxFingerprints: Math.max(1, getIntConvar('kora_sql_stats_max_fingerprints', 2000)),
        verifyConflictKeys: getBoolConvar('kora_sql_verify_conflict_keys', true),
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
        oxTypeCast: getBoolConvar('kora_sql_ox_typecast', true),
        defaultCollate: getConvar('kora_sql_default_collate', 'utf8mb4_unicode_ci'),
        debug: getBoolConvar('qbsql_debug', false),
    };

    log.setDebug(cfg.debug);

    if (cfg.maxStartTransactions === 0) cfg.maxStartTransactions = Math.max(1, cfg.writePoolSize - 2);

    const totalConns = cfg.readPoolSize + cfg.writePoolSize;
    const worstCasePrepared = cfg.statementCache * totalConns;
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

function connectionCollation(charset) {
    const value = String(charset || 'utf8mb4');
    return value.includes('_') ? value : `${value}_unicode_ci`;
}

module.exports = { load, parseConnectionString, connectionCollation, parseSsl, parseSslMode };
