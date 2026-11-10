'use strict';

const registered = new Map();
const dsn = process.env.KORA_SQL_TEST_DSN;

globalThis.exports = (name, fn) => registered.set(name, fn);
globalThis.GetConvar = (name, fallback) => name === 'mysql_connection_string' ? dsn : fallback;
globalThis.GetCurrentResourceName = () => 'kora_sql';
globalThis.GetInvokingResource = () => 'kora_sql-bundle-smoke';
globalThis.emit = () => {};
globalThis.on = () => {};

require('../../dist/build.js');

async function main() {
    await new Promise((resolve, reject) => {
        registered.get('awaitReady')((ok, err) => ok ? resolve() : reject(new Error(err)));
    });
    const rows = await registered.get('query')('SELECT 1 AS value', [], 'kora_sql-bundle-smoke');
    if (!rows || !rows[0] || Number(rows[0].value) !== 1) {
        throw new Error('bundled query returned an unexpected result');
    }
    process.stdout.write('bundle round trip ok\n', () => process.exit(0));
}

main().catch((err) => {
    process.stderr.write(`${err.stack || err.message}\n`, () => process.exit(1));
});
