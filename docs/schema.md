---
title: Schema management
sidebar_position: 6
---

There is no migration runner. `Kora.sql.ensureTable(spec)` and `Kora.sql.ensureTables(specs)` create a missing table and, for an existing one, only **add** missing columns, primary key, indexes, foreign keys and checks. They are safe to call on every boot and never drop anything. `ensureTables` runs its list in order (list foreign-key parents first) and stops at the first error. Both yield; `ensureTableAsync` and `ensureTablesAsync` take a callback instead.

```lua
Kora.sql.ensureTables({
    {
        name = 'my_orders',
        collate = 'utf8mb4_unicode_ci',
        columns = {
            { name = 'id', type = 'bigint', unsigned = true, auto_increment = true },
            { name = 'citizenid', type = 'varchar(50)', null = true, default = Kora.sql.NULL },
            { name = 'status', type = 'enum', values = { 'open', 'done' }, default = 'open' },
            { name = 'created_at', type = 'timestamp', default = { raw = 'CURRENT_TIMESTAMP' } },
        },
        primary = { 'id' },
        indexes = { { name = 'idx_citizen', columns = { 'citizenid', 'created_at' }, unique = false } },
        foreign = { { name = 'fk_orders_player', columns = { 'citizenid' },
                      ref_table = 'players', ref_columns = { 'citizenid' }, on_delete = 'SET NULL' } },
        checks = { { name = 'chk_id', expr = '`id` > 0' } },
        seed = { rows = { { id = 1, status = 'open' } }, once = true },
    },
})
```

## Spec fields

- Engine and charset default to InnoDB and utf8mb4. A new table's collation defaults to `kora_sql_default_collate`.
- Columns are `NOT NULL` unless `null = true`. `default` takes a value, `Kora.sql.NULL`, or `{ raw = 'CURRENT_TIMESTAMP' }`. `on_update = 'CURRENT_TIMESTAMP'` is supported. Enum and set types take a `values` list.
- `columns[].generated = { expr = '...', stored = false }` declares a generated column (stored unless `stored = false`; no default or auto_increment).
- `columns[].after`, `columns[].comment` and spec `comment` are supported.
- `indexes` with `unique = true` provide unique constraints. `foreign` entries take `on_delete` and `on_update`.
- `extend = true` marks a table owned by someone else: only the listed columns, indexes, foreign keys and checks are added, the table is never created (a missing table is an error), and `primary` and `seed` are not allowed.
- `seed.rows` are inserted with `INSERT IGNORE` (bound parameters); `seed.update = true` upserts instead. `seed.once = true` seeds only when this call created the table.

All names and types are validated against a whitelist before SQL is built. Expressions (`generated.expr`, `checks[].expr`) are developer-written SQL; `;` and comments are rejected.

## Report

The return value is `{ table, created, added_columns, added_indexes, added_fks, added_checks, modified_columns, seeded, warnings }` (a list of these for `ensureTables`). A type, nullability or collation difference on an existing column is reported in `warnings` and logged once per table, unless the column opts in to `modify`.

## Safe modify

`columns[].modify = true` allows `MODIFY COLUMN` when the existing definition differs, but only if all of these hold. Otherwise the change is reported in `warnings` and logged at warn with the resource name.

- It cannot lose data. Accepted: longer `varchar`/`char`; `char` to `varchar`; `char`/`varchar` to `text`, `mediumtext`, `longtext` (to `tinytext` only if 4 times the length is at most 255); `binary`/`varbinary` to a blob; a larger integer of the same signedness; an unsigned integer to a strictly larger signed one; an integer to a `decimal` with enough integer digits; a wider `decimal`; a larger text or blob type; more fractional-second digits; `float` to `double`; an enum or set keeping every existing value; `NOT NULL` to `NULL`; and `NULL` to `NOT NULL` once no NULLs remain.
- If the table has a recorded owner, the calling resource is that owner. kora_sql records the creator of every table it creates in `kora_sql_schema_owners`. A table with no recorded owner keeps the older behaviour: any resource's safe modify applies with a warn line and does not claim the table. Insert a row into `kora_sql_schema_owners` to give an existing table an owner.
- The spec is not `extend`.
- `kora_sql_schema_allow_modify` is not `false`.

Anything that must convert, backfill or drop existing data has to be done by hand.

## awaitTables

On a blank database, tables created by other resources (for example `players`) appear some seconds after start. Call `Kora.sql.awaitTables({ 'players' })` before the first query against such a table.
