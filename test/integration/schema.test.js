'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const mysql = require('mysql2/promise');
const { SchemaManager, NULL_SENTINEL } = require('../../server/js/schema');

const dsn = process.env.KORA_SQL_TEST_DSN;
const disposable = dsn && /\/[A-Za-z0-9_]*_test(\?|$)/.test(dsn);

test('ensureTable creates, re-runs as a no-op, repairs drift and only warns on type changes', {
    skip: !disposable,
}, async () => {
    const pool = mysql.createPool({ uri: dsn, namedPlaceholders: true });
    const manager = new SchemaManager({ write: pool });
    const parent = { name: 'kora_sql_t_parent', primary: ['id'], columns: [{ name: 'id', type: 'int', unsigned: true, auto_increment: true }],
        seed: { rows: [{ id: 1 }] } };
    const child = {
        name: 'kora_sql_t_child', collate: 'utf8mb4_unicode_ci', primary: ['id'],
        columns: [
            { name: 'id', type: 'bigint', unsigned: true, auto_increment: true },
            { name: 'parent_id', type: 'int', unsigned: true, null: true, default: NULL_SENTINEL },
            { name: 'label', type: 'varchar(40)', default: 'x' },
            { name: 'kind', type: 'enum', values: ['a', 'b'], default: 'a' },
            { name: 'payload', type: 'json', null: true },
            { name: 'created_at', type: 'timestamp', default: { raw: 'CURRENT_TIMESTAMP' } },
        ],
        indexes: [{ name: 'idx_label', columns: ['label'] }],
        foreign: [{ name: 'fk_kora_sql_t_parent', columns: ['parent_id'], ref_table: 'kora_sql_t_parent', ref_columns: ['id'], on_delete: 'set null' }],
        seed: { rows: [{ id: 1, parent_id: 1, label: 'seeded' }] },
    };
    const drop = async () => {
        await pool.query('DROP TABLE IF EXISTS `kora_sql_t_child`');
        await pool.query('DROP TABLE IF EXISTS `kora_sql_t_parent`');
    };
    try {
        await drop();
        const first = await manager.ensureTables([parent, child], 'itest');
        assert.deepEqual(first.map((r) => r.created), [true, true]);
        assert.equal(first[1].seeded, 1);

        const second = await manager.ensureTables([parent, child], 'itest');
        assert.deepEqual(second.map((r) => r.created), [false, false]);
        assert.equal(second[1].seeded, 0, 'INSERT IGNORE must not reseed');
        assert.deepEqual(second[1].warnings, []);
        assert.deepEqual([second[1].added_columns, second[1].added_indexes, second[1].added_fks], [[], [], []]);

        await pool.query('ALTER TABLE `kora_sql_t_child` DROP FOREIGN KEY `fk_kora_sql_t_parent`');
        await pool.query('ALTER TABLE `kora_sql_t_child` DROP INDEX `idx_label`, DROP COLUMN `kind`');
        const repaired = await manager.ensureTable(child, 'itest');
        assert.deepEqual(repaired.added_columns, ['kind']);
        assert.ok(repaired.added_indexes.includes('idx_label'));
        assert.deepEqual(repaired.added_fks, ['fk_kora_sql_t_parent']);

        await pool.query('ALTER TABLE `kora_sql_t_child` MODIFY `label` varchar(10) NOT NULL DEFAULT \'x\'');
        const drifted = await manager.ensureTable(child, 'itest');
        assert.equal(drifted.warnings.length, 1);
        const [[col]] = await pool.query("SELECT COLUMN_TYPE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'kora_sql_t_child' AND COLUMN_NAME = 'label'");
        assert.equal(col.COLUMN_TYPE, 'varchar(10)', 'type drift must never be altered');
    } finally {
        await drop();
        await pool.end();
    }
});

test('generated columns, checks, modify and extend converge on a real database', {
    skip: !disposable,
}, async () => {
    const pool = mysql.createPool({ uri: dsn, namedPlaceholders: true });
    const owners = 'kora_sql_t_owners';
    const manager = new SchemaManager({ write: pool }, { ownersTable: owners });
    const drop = async () => {
        await pool.query('DROP TABLE IF EXISTS `kora_sql_t_gen`');
        await pool.query('DROP TABLE IF EXISTS `kora_sql_t_ext`');
        await pool.query(`DROP TABLE IF EXISTS \`${owners}\``);
    };
    const gen = (kinds) => ({
        name: 'kora_sql_t_gen', primary: ['id'], comment: 'schema test',
        columns: [
            { name: 'id', type: 'int', unsigned: true, auto_increment: true },
            { name: 'amount', type: 'int', default: 1 },
            { name: 'money', type: 'longtext', null: true },
            { name: 'cash', type: 'int', generated: { expr: "CAST(JSON_EXTRACT(`money`, '$.cash') AS SIGNED)", stored: false } },
            { name: 'active', type: 'varchar(8)', generated: { expr: "IF(`amount` > 0, 'y', NULL)" } },
            { name: 'kind', type: 'enum', values: kinds, default: 'a', modify: true, after: 'amount' },
        ],
        indexes: [{ name: 'uk_active', columns: ['active'], unique: true }],
        checks: [{ name: 'chk_kora_sql_amount', expr: '`amount` >= 0' }],
        seed: { rows: [{ amount: 3 }] },
    });
    try {
        await drop();
        await manager.ensureTable({ name: owners, primary: ['table_name'], columns: [
            { name: 'table_name', type: 'varchar(64)' }, { name: 'resource', type: 'varchar(64)' },
            { name: 'claimed_at', type: 'timestamp', default: { raw: 'CURRENT_TIMESTAMP' } },
        ] }, 'kora_sql');
        assert.equal((await manager.ensureTable(gen(['a', 'b']), 'itest')).created, true);
        const again = await manager.ensureTable(gen(['a', 'b']), 'itest');
        assert.deepEqual([again.created, again.added_columns, again.modified_columns, again.added_indexes, again.added_checks, again.warnings], [false, [], [], [], [], []]);
        assert.equal(again.seeded, 0);

        await assert.rejects(pool.query('INSERT INTO `kora_sql_t_gen` (`amount`) VALUES (-1)'), /CONSTRAINT|constraint/i);
        const notOwner = await manager.ensureTable(gen(['a', 'b', 'c']), 'other_resource');
        assert.deepEqual(notOwner.modified_columns, [], 'only the creating resource may modify');
        const narrowed = await manager.ensureTable(gen(['a']), 'itest');
        assert.deepEqual(narrowed.modified_columns, [], 'dropping an enum value is never applied');
        const widened = await manager.ensureTable(gen(['a', 'b', 'c']), 'itest');
        assert.deepEqual(widened.modified_columns, ['kind']);

        await pool.query('ALTER TABLE `kora_sql_t_gen` DROP CONSTRAINT `chk_kora_sql_amount`');
        await pool.query('ALTER TABLE `kora_sql_t_gen` DROP INDEX `uk_active`, DROP COLUMN `cash`');
        const repaired = await manager.ensureTable(gen(['a', 'b', 'c']), 'itest');
        assert.deepEqual([repaired.added_columns, repaired.added_indexes, repaired.added_checks], [['cash'], ['uk_active'], ['chk_kora_sql_amount']]);

        await pool.query('CREATE TABLE `kora_sql_t_ext` (`citizenid` VARCHAR(50) NOT NULL, PRIMARY KEY (`citizenid`)) ENGINE=InnoDB');
        const extend = { name: 'kora_sql_t_ext', extend: true, columns: [{ name: 'citizenid', type: 'varchar(50)' }, { name: 'flag', type: 'tinyint', null: true }] };
        assert.deepEqual((await manager.ensureTable(extend, 'itest')).added_columns, ['flag']);
        assert.deepEqual((await manager.ensureTable(extend, 'itest')).added_columns, []);
    } finally {
        await drop();
        await pool.end();
    }
});

test('awaitTables waits for a table another caller creates a moment later', {
    skip: !disposable,
}, async () => {
    const pool = mysql.createPool({ uri: dsn, namedPlaceholders: true });
    const manager = new SchemaManager({ write: pool });
    try {
        await pool.query('DROP TABLE IF EXISTS `kora_sql_t_late`');
        const started = Date.now();
        const waiting = manager.awaitTables(['kora_sql_t_late'], 5000, 'consumer');
        setTimeout(() => manager.ensureTable({ name: 'kora_sql_t_late', columns: [{ name: 'id', type: 'int' }] }, 'owner'), 700);
        assert.equal(await waiting, true);
        assert.ok(Date.now() - started >= 600, 'resolved only after the table existed');
        await assert.rejects(manager.awaitTables(['kora_sql_t_never'], 400, 'consumer'), /kora_sql_t_never/);
    } finally {
        await pool.query('DROP TABLE IF EXISTS `kora_sql_t_late`');
        await pool.end();
    }
});
