// Migration runner, exercised against a FAKE pool that records what it is asked
// to execute -- no database.
//
// The regression these pin: the pool sets namedPlaceholders:true (mysql-async
// `@name` compat), which makes mysql2 route any VALUELESS query through the
// `named-placeholders` parser. That parser tracks quotes but knows nothing
// about SQL comments or backticks, so its /:([a-zA-Z][a-zA-Z0-9_]*)/ regex
// matches inside them. A migration whose header comment mentions an event name
// like `qb-multicharacter:server:getSkin` was read as two placeholders and died
// with "Named query contains placeholders, but parameters object is undefined".
// Migration DDL is parameterless, so the runner must opt out per query.
//
// Run with:  node --test  (from the resource root)

'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { Migrator, splitStatements } = require('../../server/js/migrate.js');

// The exact shape that broke kora_clothing v1: a `:word` inside a leading comment.
const SQL_WITH_COLON_IN_COMMENT = `
-- kora_core's own compat stub for
-- \`qb-multicharacter:server:getSkin\` already names this exact table.
CREATE TABLE IF NOT EXISTS \`playerskins\` (
  \`citizenid\` VARCHAR(50) NOT NULL,
  PRIMARY KEY (\`citizenid\`)
) ENGINE=InnoDB;
`;

function fakePools({ applied = [] } = {}) {
    const executed = [];
    const conn = {
        beginTransaction: async () => {},
        commit: async () => {},
        rollback: async () => {},
        release: () => {},
        query: async (sql, values) => {
            executed.push({ sql, values });
            return [[], []];
        },
    };
    return {
        executed,
        pools: {
            write: {
                query: async (sql, values) => {
                    executed.push({ sql, values });
                    // The "what's already applied" SELECT.
                    if (typeof sql === 'string' && sql.startsWith('SELECT')) return [applied, []];
                    return [[], []];
                },
                getConnection: async () => conn,
            },
        },
    };
}

// Mirrors mysql2's base/connection.js _resolveNamedPlaceholders: an explicit
// per-query false wins over the connection config, and an Array of values
// short-circuits the named path entirely.
function wouldHitNamedParser(queryArg, values) {
    const options = typeof queryArg === 'object' && queryArg !== null
        ? { ...queryArg }
        : { sql: queryArg, values };
    if (typeof options.namedPlaceholders === 'undefined') {
        options.namedPlaceholders = true; // the pool's setting
    }
    if (!options.namedPlaceholders) return false;
    if (Array.isArray(options.values !== undefined ? options.values : values)) return false;
    return true;
}

test('splitStatements keeps quoted semicolons together and drops nothing', () => {
    const parts = splitStatements("SELECT ';' AS a; SELECT 2");
    assert.equal(parts.length, 2);
    assert.match(parts[0], /SELECT ';' AS a/);
    assert.match(parts[1], /SELECT 2/);
});

test('a `:word` inside a migration comment does not reach the named-placeholder parser', async () => {
    const { pools, executed } = fakePools();
    const migrator = new Migrator(pools);

    await migrator.migrate('kora_clothing', [
        { version: 1, name: 'playerskins_outfits', sql: SQL_WITH_COLON_IN_COMMENT, checksum: 'abc' },
    ]);

    const ddl = executed.filter((e) => {
        const sql = typeof e.sql === 'object' ? e.sql.sql : e.sql;
        return sql.includes('CREATE TABLE IF NOT EXISTS `playerskins`');
    });
    assert.equal(ddl.length, 1, 'the migration DDL should have been executed once');

    // The regex the parser uses really does match inside the comment...
    const rawSql = typeof ddl[0].sql === 'object' ? ddl[0].sql.sql : ddl[0].sql;
    assert.deepEqual(
        rawSql.match(/(?::(\d+|(?:[a-zA-Z][a-zA-Z0-9_]*)))/g),
        [':server', ':getSkin'],
        'this SQL is exactly the shape that used to break the runner'
    );
    // ...so the runner must have opted out of placeholder compilation.
    assert.equal(
        wouldHitNamedParser(ddl[0].sql, ddl[0].values),
        false,
        'migration DDL must be sent with namedPlaceholders:false'
    );
});

test('bootstrap DDL also opts out of placeholder compilation', async () => {
    const { pools, executed } = fakePools();
    await new Migrator(pools).migrate('qbtest', []);

    const bootstrap = executed.filter((e) => {
        const sql = typeof e.sql === 'object' ? e.sql.sql : e.sql;
        return sql.includes('CREATE TABLE IF NOT EXISTS `qbsql_');
    });
    assert.equal(bootstrap.length, 2, 'both bootstrap tables should be created');
    for (const entry of bootstrap) {
        assert.equal(wouldHitNamedParser(entry.sql, entry.values), false);
    }
});

test('statements that DO bind values still pass an array (mysql2 short-circuits those)', async () => {
    const { pools, executed } = fakePools();
    await new Migrator(pools).migrate('qbtest', [
        { version: 1, name: 'noop', sql: 'CREATE TABLE IF NOT EXISTS `t` (`a` INT)', checksum: 'sum1' },
    ]);

    const insert = executed.find((e) => {
        const sql = typeof e.sql === 'object' ? e.sql.sql : e.sql;
        return sql.startsWith('INSERT INTO `qbsql_migrations`');
    });
    assert.ok(insert, 'the applied migration should be recorded');
    assert.ok(Array.isArray(insert.values), 'positional binds must stay an array');
    assert.equal(wouldHitNamedParser(insert.sql, insert.values), false);
});

test('a non-idempotent DDL migration is rejected before execution', async () => {
    const { pools } = fakePools();
    await assert.rejects(
        () => new Migrator(pools).migrate('unsafe', [
            { version: 1, name: 'unsafe', sql: 'ALTER TABLE `players` ADD COLUMN `x` INT', checksum: 'unsafe' },
        ]),
        /retry-safe/,
    );
});

test('an atomic index replacement using IF EXISTS/IF NOT EXISTS is accepted', async () => {
    const { pools, executed } = fakePools();
    await new Migrator(pools).migrate('kora_core', [
        {
            version: 8,
            name: 'active_character_slots',
            sql: 'ALTER TABLE `players` DROP INDEX IF EXISTS `old_slot`, ADD UNIQUE INDEX IF NOT EXISTS `new_slot` (`license`,`active_cid`)',
            checksum: 'active-slots',
        },
    ]);
    assert.ok(executed.some((entry) => {
        const sql = typeof entry.sql === 'object' ? entry.sql.sql : entry.sql;
        return sql.includes('DROP INDEX IF EXISTS `old_slot`');
    }));
});

test('an already-applied migration with a changed checksum is a hard abort', async () => {
    const { pools } = fakePools({ applied: [{ version: 1, checksum: 'ondisk' }] });
    await assert.rejects(
        () => new Migrator(pools).migrate('qbtest', [
            { version: 1, name: 'drifted', sql: 'SELECT 1', checksum: 'changed' },
        ]),
        /checksum mismatch/,
        'an edited migration must refuse to continue rather than drift silently'
    );
});

test('an explicitly accepted legacy checksum permits a reviewed retry-safe rewrite', async () => {
    const { pools } = fakePools({ applied: [{ version: 3, checksum: 'legacy' }] });
    const result = await new Migrator(pools).migrate('kora_core', [
        {
            version: 3,
            name: 'generated_columns',
            sql: 'ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `cash` INT',
            checksum: 'retry-safe',
            acceptedChecksums: ['legacy'],
        },
    ]);
    assert.deepEqual(result, { ran: 0, total: 1 });
});
