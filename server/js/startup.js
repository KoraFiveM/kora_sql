'use strict';

const TRANSIENT_CODES = new Set([
    'ECONNREFUSED',
    'ECONNRESET',
    'ETIMEDOUT',
    'EHOSTUNREACH',
    'ENETUNREACH',
    'EPIPE',
    'PROTOCOL_CONNECTION_LOST',
]);

function isTransientConnectionError(err) {
    let current = err;
    while (current) {
        if (TRANSIENT_CODES.has(current.code)) return true;
        current = current.cause;
    }
    return false;
}

function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

async function connectWithRetry(build, cfg, options = {}) {
    const delay = options.delay || sleep;
    const retryInterval = options.retryInterval || 2000;
    const shouldStop = options.shouldStop || (() => false);
    const onRetry = options.onRetry || (() => {});
    let attempt = 0;

    for (;;) {
        try {
            return await build(cfg);
        } catch (err) {
            if (!isTransientConnectionError(err) || shouldStop()) throw err;
            attempt++;
            onRetry(err, attempt, retryInterval);
            await delay(retryInterval);
            if (shouldStop()) {
                const stopped = new Error('qbsql stopped while waiting for the database');
                stopped.code = 'QBSQL_STOPPING';
                throw stopped;
            }
        }
    }
}

module.exports = { connectWithRetry, isTransientConnectionError };
