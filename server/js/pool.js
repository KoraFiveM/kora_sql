'use strict';

const mysql = require('mysql2/promise');
const log = require('./logger');
const { connectionCollation } = require('./config');

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
        queueLimit: cfg.poolQueueLimit || 0,
        enableKeepAlive: true,
        keepAliveInitialDelay: 10000,

        connectTimeout: cfg.connection.connectTimeout || 10000,

        stringifyObjects: true,

        decimalNumbers: true,
        supportBigNumbers: true,
        bigNumberStrings: false,

        namedPlaceholders: true,

        dateStrings: false,
        timezone: 'Z',

        multipleStatements: cfg.allowMultipleStatements,

        maxPreparedStatements: statementCache || cfg.statementCache,
    };
    if (cfg.connection.ssl) options.ssl = cfg.connection.ssl;
    return options;
}

function withAcquireTimeout(pool, ms, name) {
    if (!ms) return pool;
    const acquire = () => new Promise((resolve, reject) => {
        let settled = false;
        const timer = setTimeout(() => {
            if (settled) return;
            settled = true;
            const err = new Error(`kora_sql: no ${name} connection became free within ${ms}ms`);
            err.code = 'KORA_SQL_ACQUIRE_TIMEOUT';
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

function isMariaConnection(conn) {
    if (typeof conn._isMariaDB === 'boolean') return conn._isMariaDB;
    const version = conn._handshakePacket && conn._handshakePacket.serverVersion;
    return typeof version === 'string' && /mariadb/i.test(version);
}

function sessionTimeoutSql(conn, ms, mariadb = isMariaConnection(conn)) {
    return mariadb
        ? `SET SESSION max_statement_time = ${(ms / 1000).toFixed(3)}`
        : `SET SESSION max_execution_time = ${Math.floor(ms)}`;
}

const UNKNOWN_VARIABLE = new Set(['ER_UNKNOWN_SYSTEM_VARIABLE', 'ER_UNKNOWN_SYSTEM_VARIABLE_NAME']);

function limitReadStatements(pool, ms) {
    if (!ms) return;
    let warned = false;
    const warn = (err) => {
        if (warned) return;
        warned = true;
        log.warn('pool', `could not set a server-side read timeout (${err.message}); only the client-side timeout applies`);
    };
    pool.on('connection', (conn) => {
        const mariadb = isMariaConnection(conn);
        conn.query(sessionTimeoutSql(conn, ms, mariadb), (err) => {
            if (!err) return;
            if (!UNKNOWN_VARIABLE.has(err.code) && err.errno !== 1193) { warn(err); return; }
            conn.query(sessionTimeoutSql(conn, ms, !mariadb), (err2) => { if (err2) warn(err2); });
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
        await Promise.allSettled([read.end(), write.end(), flush && flush.end()]);
        throw err;
    }

    return { read, write, flush, version };
}

function all(pools) {
    return [pools.read, pools.write, pools.flush].filter(Boolean);
}

module.exports = { build, all, poolOptions, withAcquireTimeout, sessionTimeoutSql, limitReadStatements };
