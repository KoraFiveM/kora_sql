// Declarative schema setup, exercised against a FAKE pool (no database).
//
// Run with:  node --test  (from the resource root)

'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { SchemaManager, validateSpec, buildCreate, buildSeed, diff, NULL_SENTINEL } = require('../../server/js/schema.js');

const spec = () => ({
    name: 'demo_ops',
    collate: 'utf8mb4_unicode_ci',
    columns: [
        { name: 'id', type: 'bigint', unsigned: true, auto_increment: true },
        { name: 'owner', type: 'varchar(50)', null: true, default: NULL_SENTINEL },
        { name: 'kind', type: 'enum', values: ['a', "b'c"], default: 'a' },
        { name: 'created_at', type: 'timestamp', default: { raw: 'current_timestamp' } },
    ],
    primary: ['id'],
    indexes: [{ name: 'idx_owner', columns: ['owner', 'created_at'] }, { name: 'uk_kind', columns: ['kind'], unique: true }],
    foreign: [{ name: 'fk_owner', columns: ['owner'], ref_table: 'players', ref_columns: ['citizenid'], on_delete: 'set null' }],
});

test('buildCreate renders columns, keys, foreign keys and table options', () => {
    const sql = buildCreate(validateSpec(spec()));
    assert.match(sql, /^CREATE TABLE IF NOT EXISTS `demo_ops`/);
    assert.match(sql, /`id` bigint UNSIGNED NOT NULL AUTO_INCREMENT/);
    assert.match(sql, /`owner` varchar\(50\) COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL/);
    assert.match(sql, /`kind` enum\('a','b\\'c'\) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'a'/);
    assert.match(sql, /DEFAULT CURRENT_TIMESTAMP/);
    assert.match(sql, /PRIMARY KEY \(`id`\)/);
    assert.match(sql, /UNIQUE KEY `uk_kind` \(`kind`\)/);
    assert.match(sql, /CONSTRAINT `fk_owner` FOREIGN KEY \(`owner`\) REFERENCES `players` \(`citizenid`\) ON DELETE SET NULL/);
    assert.match(sql, /ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci$/);
});

test('validateSpec rejects unsafe identifiers, types and keywords', () => {
    const bad = (mutate) => assert.throws(() => { const s = spec(); mutate(s); validateSpec(s); }, /qbsql schema/);
    bad((s) => { s.name = 'x`; DROP TABLE y; --'; });
    bad((s) => { s.columns[0].name = 'a b'; });
    bad((s) => { s.columns[1].type = 'varchar(50); DROP TABLE x'; });
    bad((s) => { s.columns[2].values = undefined; });
    bad((s) => { s.columns[3].default = { raw: 'SLEEP(10)' }; });
    bad((s) => { s.primary = ['missing']; });
    bad((s) => { s.foreign[0].on_delete = 'CASCADE; DROP'; });
    bad((s) => { s.collate = "utf8'; --"; });
    bad((s) => { s.columns.push({ name: 'id', type: 'int' }); });
});

test('default values are escaped, never concatenated raw', () => {
    const s = spec();
    s.columns[2].default = "x'; DROP TABLE y; --";
    assert.match(buildCreate(validateSpec(s)), /DEFAULT 'x\\'; DROP TABLE y; --'/);
});

const actualFor = (s, overrides = {}) => ({
    columns: s.columns.map((c) => ({
        COLUMN_NAME: c.name,
        COLUMN_TYPE: c.name === 'id' ? 'bigint(20) unsigned' : c.name === 'owner' ? 'varchar(50)' : c.name === 'kind' ? "enum('a','b\\'c')" : 'timestamp',
        IS_NULLABLE: c.null ? 'YES' : 'NO',
        COLLATION_NAME: /varchar|enum/.test(c.type) ? 'utf8mb4_unicode_ci' : null,
    })).filter((c) => !(overrides.drop || []).includes(c.COLUMN_NAME)),
    indexes: [{ INDEX_NAME: 'PRIMARY' }, { INDEX_NAME: 'idx_owner' }, { INDEX_NAME: 'uk_kind' }].filter((i) => !(overrides.dropIndex || []).includes(i.INDEX_NAME)),
    foreign: overrides.dropFk ? [] : [{ CONSTRAINT_NAME: 'fk_owner' }],
});

test('diff of a matching table is empty', () => {
    const s = validateSpec(spec());
    const result = diff(s, actualFor(s));
    assert.deepEqual(result.statements, []);
    assert.deepEqual(result.warnings, []);
});

test('diff only ever adds what is missing', () => {
    const s = validateSpec(spec());
    const result = diff(s, actualFor(s, { drop: ['owner', 'kind'], dropIndex: ['uk_kind', 'PRIMARY'], dropFk: true }));
    assert.deepEqual(result.added.columns, ['owner', 'kind']);
    assert.deepEqual(result.added.indexes, ['PRIMARY', 'uk_kind']);
    assert.deepEqual(result.added.foreign, ['fk_owner']);
    for (const stmt of result.statements) {
        assert.match(stmt, /^ALTER TABLE `demo_ops` ADD /);
        assert.doesNotMatch(stmt, /DROP|MODIFY|CHANGE/i);
    }
});

test('diff warns on type, nullability and collation drift without altering', () => {
    const s = validateSpec(spec());
    const actual = actualFor(s);
    actual.columns[1].COLUMN_TYPE = 'varchar(20)';
    actual.columns[1].COLLATION_NAME = 'utf8mb4_general_ci';
    actual.columns[2].IS_NULLABLE = 'YES';
    const result = diff(s, actual);
    assert.deepEqual(result.statements, []);
    assert.equal(result.warnings.length, 3);
    assert.match(result.warnings.join('\n'), /type is 'varchar\(20\)'/);
    assert.match(result.warnings.join('\n'), /collation is 'utf8mb4_general_ci'/);
    assert.match(result.warnings.join('\n'), /nullability/);
});

test('integer display width and json/longtext do not cause false warnings', () => {
    const s = validateSpec({ name: 't', columns: [{ name: 'a', type: 'int', unsigned: true }, { name: 'b', type: 'json' }, { name: 'c', type: 'boolean' }] });
    const result = diff(s, { columns: [
        { COLUMN_NAME: 'a', COLUMN_TYPE: 'int(10) unsigned', IS_NULLABLE: 'NO' },
        { COLUMN_NAME: 'b', COLUMN_TYPE: 'longtext', IS_NULLABLE: 'NO' },
        { COLUMN_NAME: 'c', COLUMN_TYPE: 'tinyint(1)', IS_NULLABLE: 'NO' },
    ], indexes: [], foreign: [] });
    assert.deepEqual(result.warnings, []);
});

test('buildSeed is a parameterised INSERT IGNORE, or an upsert when requested', () => {
    const s = validateSpec({ name: 't', primary: ['id'], columns: [{ name: 'id', type: 'int' }, { name: 'label', type: 'varchar(10)', null: true }],
        seed: { rows: [{ id: 1, label: "x'; DROP" }, { id: 2, label: NULL_SENTINEL }] } });
    const seed = buildSeed(s);
    assert.equal(seed.sql, 'INSERT IGNORE INTO `t` (`id`, `label`) VALUES (?, ?), (?, ?)');
    assert.deepEqual(seed.values, [1, "x'; DROP", 2, null]);

    s.seed.update = true;
    assert.match(buildSeed(s).sql, /ON DUPLICATE KEY UPDATE `label` = VALUES\(`label`\)$/);
    assert.equal(buildSeed(validateSpec({ name: 't', columns: [{ name: 'id', type: 'int' }] })), null);
});

function fakePools({ exists = false, actual = null } = {}) {
    const executed = [];
    return {
        executed,
        pools: {
            write: {
                query: async (sql, values) => {
                    const text = typeof sql === 'string' ? sql : sql.sql;
                    executed.push({ text, values, namedPlaceholders: typeof sql === 'object' ? sql.namedPlaceholders : undefined });
                    if (text.includes('information_schema.TABLES')) return [exists ? [{ 1: 1 }] : [], []];
                    if (text.includes('information_schema.COLUMNS')) return [actual ? actual.columns : [], []];
                    if (text.includes('information_schema.STATISTICS')) return [actual ? actual.indexes : [], []];
                    if (text.includes('TABLE_CONSTRAINTS')) return [actual ? actual.foreign : [], []];
                    return [{ affectedRows: 2 }, []];
                },
            },
        },
    };
}

test('ensureTable creates a missing table (DDL opts out of named placeholders) and seeds it', async () => {
    const { pools, executed } = fakePools();
    const manager = new SchemaManager(pools);
    const report = await manager.ensureTable({ name: 't', columns: [{ name: 'id', type: 'int' }], seed: { rows: [{ id: 1 }] } }, 'demo');
    assert.equal(report.created, true);
    assert.equal(report.seeded, 2);
    const create = executed.find((e) => e.text.startsWith('CREATE TABLE'));
    assert.equal(create.namedPlaceholders, false);
    assert.ok(executed.some((e) => e.text.startsWith('INSERT IGNORE')));
});

test('ensureTable on an existing table adds only missing columns and reports them', async () => {
    const s = validateSpec(spec());
    const { pools, executed } = fakePools({ exists: true, actual: actualFor(s, { drop: ['owner'] }) });
    const report = await new SchemaManager(pools).ensureTable(spec(), 'demo');
    assert.equal(report.created, false);
    assert.deepEqual(report.added_columns, ['owner']);
    assert.equal(executed.filter((e) => e.text.startsWith('ALTER TABLE')).length, 1);
    assert.ok(!executed.some((e) => e.text.startsWith('CREATE TABLE')));
});

test('ensureTables runs in order and stops at the first failure', async () => {
    const { pools, executed } = fakePools();
    const manager = new SchemaManager(pools);
    const reports = await manager.ensureTables([
        { name: 'a', columns: [{ name: 'id', type: 'int' }] },
        { name: 'b', columns: [{ name: 'id', type: 'int' }] },
    ], 'demo');
    assert.deepEqual(reports.map((r) => r.table), ['a', 'b']);
    const created = executed.filter((e) => e.text.startsWith('CREATE TABLE')).map((e) => e.text.match(/`(\w+)`/)[1]);
    assert.deepEqual(created, ['a', 'b']);

    await assert.rejects(manager.ensureTables([{ name: 'bad name', columns: [] }, { name: 'c', columns: [{ name: 'id', type: 'int' }] }], 'demo'), /qbsql schema/);
    assert.ok(!executed.some((e) => e.text.includes('`c`')));
});

test('generated columns, checks, comments and AFTER are rendered; expressions cannot smuggle statements', () => {
    const s = validateSpec({
        name: 't', comment: "it's a table",
        columns: [
            { name: 'amount', type: 'int' },
            { name: 'money', type: 'longtext', null: true },
            { name: 'cash', type: 'int', generated: { expr: "CAST(JSON_EXTRACT(`money`, '$.cash') AS SIGNED)", stored: false } },
            { name: 'active', type: 'varchar(24)', generated: { expr: "IF(`amount` > 0, 'y', NULL)" }, after: 'amount', comment: 'x' },
        ],
        checks: [{ name: 'chk_amount', expr: '`amount` >= 0' }],
    });
    const sql = buildCreate(s);
    assert.match(sql, /`cash` int GENERATED ALWAYS AS \(CAST\(JSON_EXTRACT\(`money`, '\$\.cash'\) AS SIGNED\)\) VIRTUAL,/);
    assert.match(sql, /`active` varchar\(24\) GENERATED ALWAYS AS \(IF\(`amount` > 0, 'y', NULL\)\) STORED COMMENT 'x'/);
    assert.match(sql, /CONSTRAINT `chk_amount` CHECK \(`amount` >= 0\)/);
    assert.match(sql, /COMMENT='it\\'s a table'$/);

    const result = diff(s, { columns: [{ COLUMN_NAME: 'amount', COLUMN_TYPE: 'int(11)', IS_NULLABLE: 'NO' }, { COLUMN_NAME: 'money', COLUMN_TYPE: 'longtext', IS_NULLABLE: 'YES' }], indexes: [], foreign: [], checks: [] });
    assert.deepEqual(result.added.columns, ['cash', 'active']);
    assert.ok(result.statements.some((x) => /ADD COLUMN `active`.* AFTER `amount`$/.test(x)));
    assert.deepEqual(result.added.checks, ['chk_amount']);

    const bad = (mutate) => assert.throws(() => { const x = { name: 't', columns: [{ name: 'a', type: 'int', generated: { expr: '1' } }] }; mutate(x); validateSpec(x); }, /qbsql schema/);
    bad((x) => { x.columns[0].generated.expr = '1); DROP TABLE y; --'; });
    bad((x) => { x.checks = [{ name: 'c', expr: '1 /* x */' }]; });
    bad((x) => { x.columns[0].default = 1; });
});

test('modify=true converges a differing column; without it the difference is only a warning', () => {
    const base = { name: 't', columns: [{ name: 'kind', type: 'enum', values: ['a', 'b', 'c'], default: 'a' }] };
    const actual = { columns: [{ COLUMN_NAME: 'kind', COLUMN_TYPE: "enum('a','b')", IS_NULLABLE: 'NO' }], indexes: [], foreign: [], checks: [] };
    const plain = diff(validateSpec(base), actual);
    assert.deepEqual(plain.statements, []);
    assert.equal(plain.warnings.length, 1);
    base.columns[0].modify = true;
    const modified = diff(validateSpec(base), actual);
    assert.deepEqual(modified.warnings, []);
    assert.deepEqual(modified.added.modified, ['kind']);
    assert.match(modified.statements[0], /^ALTER TABLE `t` MODIFY COLUMN `kind` enum\('a','b','c'\) NOT NULL DEFAULT 'a'$/);
});

test('extend tables add columns to an existing table but refuse to create or seed one', async () => {
    assert.throws(() => validateSpec({ name: 'players', extend: true, primary: ['id'], columns: [{ name: 'id', type: 'int' }] }), /extend/);
    const { pools, executed } = fakePools();
    await assert.rejects(new SchemaManager(pools).ensureTable({ name: 'players', extend: true, columns: [{ name: 'x', type: 'int', null: true }] }, 'kora_core'), /does not exist/);
    assert.ok(!executed.some((e) => /CREATE TABLE/.test(e.text)));
    const present = fakePools({ exists: true, actual: { columns: [{ COLUMN_NAME: 'citizenid', COLUMN_TYPE: 'varchar(50)', IS_NULLABLE: 'NO' }], indexes: [], foreign: [], checks: [] } });
    const report = await new SchemaManager(present.pools).ensureTable({ name: 'players', extend: true, columns: [{ name: 'citizenid', type: 'varchar(50)' }, { name: 'x', type: 'int', null: true }] }, 'kora_core');
    assert.deepEqual(report.added_columns, ['x']);
});

test('seed rows missing a column use DEFAULT instead of NULL', () => {
    const s = validateSpec({ name: 't', columns: [{ name: 'id', type: 'int' }, { name: 'v', type: 'int', default: 5 }], seed: { rows: [{ id: 1 }, { id: 2, v: 9 }] } });
    const seed = buildSeed(s);
    assert.equal(seed.sql, 'INSERT IGNORE INTO `t` (`id`, `v`) VALUES (?, DEFAULT), (?, ?)');
    assert.deepEqual(seed.values, [1, 2, 9]);
});

test('seed.once only seeds the run that creates the table', async () => {
    const spec = { name: 't', columns: [{ name: 'id', type: 'int' }], seed: { rows: [{ id: 1 }], once: true } };
    const fresh = fakePools();
    assert.equal((await new SchemaManager(fresh.pools).ensureTable(spec, 'demo')).seeded, 2);
    const present = fakePools({ exists: true, actual: { columns: [{ COLUMN_NAME: 'id', COLUMN_TYPE: 'int(11)', IS_NULLABLE: 'NO' }], indexes: [], foreign: [], checks: [] } });
    const report = await new SchemaManager(present.pools).ensureTable(spec, 'demo');
    assert.equal(report.seeded, 0);
    assert.ok(!present.executed.some((e) => e.text.startsWith('INSERT')));
    spec.seed.once = false;
    assert.equal((await new SchemaManager(fakePools({ exists: true, actual: present.pools.write && { columns: [{ COLUMN_NAME: 'id', COLUMN_TYPE: 'int(11)', IS_NULLABLE: 'NO' }], indexes: [], foreign: [], checks: [] } }).pools).ensureTable(spec, 'demo')).seeded, 2);
});

test('awaitTables resolves when the tables appear and times out naming the missing ones', async () => {
    let calls = 0;
    const pools = { write: { query: async (sql, values) => { calls++; return [calls < 3 ? [{ TABLE_NAME: 'a' }] : [{ TABLE_NAME: 'a' }, { TABLE_NAME: 'B' }], []]; } } };
    assert.equal(await new SchemaManager(pools).awaitTables(['a', 'b', 'a'], 5000, 'demo'), true);
    assert.ok(calls >= 3);
    const never = { write: { query: async () => [[], []] } };
    await assert.rejects(new SchemaManager(never).awaitTables(['x', 'y'], 300, 'demo'), /x, y.*demo/);
    await assert.rejects(new SchemaManager(never).awaitTables(['bad name'], 300, 'demo'), /list of table names/);
    await assert.rejects(new SchemaManager(never).awaitTables([], 300, 'demo'), /list of table names/);
});
