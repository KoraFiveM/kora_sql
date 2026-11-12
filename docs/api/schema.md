---
title: "Schema"
sidebar_position: 5
---


# Schema

Describe a table as data in Lua instead of shipping a `.sql` file. Kora SQL creates it when missing and adds what is missing when it exists. There is no migration runner: it never drops, renames or converts anything.

Namespace: `Kora.sql` · Source: `init.lua, server/js/schema.js`

## How it works

For each spec the table is inspected through `information_schema`. If it does not exist, one `CREATE TABLE IF NOT EXISTS` statement is built and run. If it exists, the spec is compared by name: missing columns become `ADD COLUMN`, a missing primary key `ADD PRIMARY KEY`, missing indexes, foreign keys and checks are added, and differences in an existing column’s type, nullability or collation are only reported as warnings. Every identifier, type and keyword is validated against a whitelist before any SQL is built; default values and comments are escaped by the driver; seed values are bound parameters. Foreign key and index existence is checked by name only.

## Set up your tables

1. **Describe the table in Lua** — Write one spec per table: columns, primary key, indexes and foreign keys. Keep the specs in one `server/schema.lua` file.
2. **Call ensureTables on start** — Run it inside a `CreateThread` when your resource starts. Order the specs so tables that others reference come first.
3. **Read the report** — Log `warnings`. A warning means the live table differs from your spec and Kora SQL left it alone.
4. **Wait for tables you do not own** — Call `awaitTables` before you query tables created by another resource, or add columns to them with `extend = true`.
5. **Do real migrations by hand** — Converting data, renaming or dropping columns must be done with your own SQL, once, deliberately.

## Terms used on this page

| Term | Meaning |
| --- | --- |
| Spec | The Lua table that describes one database table. |
| Report | What `ensureTable` returns: whether the table was created, what was added and what differs. |
| Extend | A spec flag for adding your own columns or indexes to a table owned by another resource without ever creating it. |
| Seed | Rows inserted after the table exists, using `INSERT IGNORE` so existing rows are not overwritten. |

## Table spec

Fields of the table passed to `ensureTable` and `ensureTables`. A `?` after a name means the option is optional.

| Option | Type | Description |
| --- | --- | --- |
| `name` | string | Required table name. Letters, digits and underscore, 1 to 64 characters. |
| `columns` | table[] | Required, non-empty list of column tables (see Column fields). |
| `primary??` | string[] | Primary key column names. Every name must be declared in `columns`. Not allowed with `extend`. |
| `indexes??` | table[] | List of `{ name, columns, unique? }`. `unique = true` makes it a UNIQUE key (this is how you declare unique constraints). |
| `foreign??` | table[] | List of `{ name, columns, ref_table, ref_columns, on_delete?, on_update? }`. Actions: `CASCADE`, `SET NULL`, `RESTRICT`, `NO ACTION`, `SET DEFAULT`. |
| `checks??` | table[] | List of `{ name, expr }` CHECK constraints. `expr` is developer-written SQL; `;`, `--` and `/* */` are rejected. |
| `engine??` | string | Storage engine for a new table. Default `InnoDB`. Letters, digits and underscore only. |
| `charset??` | string | Character set for a new table. Default `utf8mb4`. |
| `collate??` | string | Collation for a new table and its text columns. When omitted, a new table uses the `kora_sql_default_collate` convar (default `utf8mb4_unicode_ci`) if it belongs to the same charset. |
| `comment??` | string | Table comment. |
| `seed??` | table | `{ rows = {...}, once?, update?, key? }`. Rows to insert after the table exists (see Seed rows). Not allowed with `extend`. |
| `extend??` | boolean | When `true`, the table belongs to another resource (for example `players`): only your listed columns, indexes, foreign keys and checks are added, the table is never created, and a missing table is an error. |

### Column fields

Each entry of `columns`.

| Option | Type | Description |
| --- | --- | --- |
| `name` | string | Required column name, 1 to 64 letters, digits or underscores. Must be unique in the table. |
| `type` | string | Required, from a fixed list: `tinyint`, `smallint`, `mediumint`, `int`, `bigint` (optionally with a width such as `int(11)`), `integer`, `decimal(p[,s])`, `numeric(p[,s])`, `float`, `double`, `char(n)`, `varchar(n)`, `binary(n)`, `varbinary(n)`, `tinytext`, `text`, `mediumtext`, `longtext`, `tinyblob`, `blob`, `mediumblob`, `longblob`, `json`, `date`, `time`, `datetime`, `timestamp` (the last three with an optional precision 0-9), `year`, `boolean`, `bool`, `enum`, `set`. Anything else raises `unsupported type`. Use the separate `unsigned` flag; do not write it inside the type. |
| `unsigned??` | boolean | Adds `UNSIGNED`. |
| `null??` | boolean | Columns are `NOT NULL` unless `null = true`. |
| `default??` | any | A value (escaped by the driver), `Kora.sql.NULL` for `DEFAULT NULL`, or `{ raw = 'CURRENT_TIMESTAMP' }`. Only `CURRENT_TIMESTAMP`, `NOW` and `LOCALTIMESTAMP` (with optional precision) are accepted as raw defaults. Not allowed on generated columns. |
| `auto_increment??` | boolean | Adds `AUTO_INCREMENT`. Not allowed on generated columns. |
| `values??` | string[] | Required for `enum` and `set`: the list of allowed strings. |
| `collate??` | string | Column collation. Text-like columns otherwise inherit the spec’s `collate`. |
| `on_update??` | string | Only `CURRENT_TIMESTAMP`, `NOW` or `LOCALTIMESTAMP`: adds `ON UPDATE <value>`. |
| `generated??` | table | `{ expr = '...', stored? = boolean }`: a generated column, `STORED` unless `stored = false`. Cannot have a default or `auto_increment`; nullability is implied. |
| `after??` | string | Position for a newly added column: placed `AFTER` the named existing column. |
| `comment??` | string | Column comment. |
| `modify??` | boolean | Opt in to `MODIFY COLUMN` when an existing column’s type or nullability differs from the spec (for example widening an enum). Without it, a difference is only a warning. |

### Seed rows

`seed = { rows = { { col = value, ... } }, once = true, update = true, key = { ... } }`. Every row key must be a declared column.

| Option | Type | Description |
| --- | --- | --- |
| `rows` | table[] | Required list of rows. A column missing from a row uses `DEFAULT`. `Kora.sql.NULL` is written as NULL. |
| `once??` | boolean | Seed only when this call created the table. Without it, seeding runs `INSERT IGNORE` on every boot and re-adds rows an admin deleted. |
| `update??` | boolean | Use `ON DUPLICATE KEY UPDATE` to refresh the non-key columns instead of ignoring existing rows. Fails with `has no non-key columns` if there is nothing to update. |
| `key??` | string[] | With `update`, the columns treated as the key. Defaults to the spec’s `primary`. |

### Report fields

The table returned by `ensureTable`.

| Option | Type | Description |
| --- | --- | --- |
| `table` | string | The table name. |
| `created` | boolean | `true` if this call created the table. |
| `added_columns` | string[] | Columns added to an existing table. |
| `modified_columns` | string[] | Columns altered because `modify = true` was set. |
| `added_indexes` | string[] | Indexes added (`PRIMARY` for a primary key). |
| `added_fks` | string[] | Foreign keys added. |
| `added_checks` | string[] | CHECK constraints added. |
| `seeded` | integer | Rows reported as affected by the seed statement. |
| `warnings` | string[] | Differences found but not changed, for example `my_table.col: type is 'int', schema expects 'bigint' (not altered)`. |

## Collation of new tables

On MySQL 8 a table created without a collation gets `utf8mb4_0900_ai_ci`, which fails joins against Kora’s `utf8mb4_unicode_ci` tables with "Illegal mix of collations". New tables therefore use `kora_sql_default_collate` (default `utf8mb4_unicode_ci`). Set the convar to an empty value to use the server default. Existing tables are never compared against or altered to match it.

## Safe for every boot

A repeat call with an unchanged spec sends only `SELECT` statements against `information_schema` plus the seed statement, if any. It is also safe if two resources call it at the same moment for the same table.

## Extending another resource’s table

Use `extend = true` with only the new columns. If the table does not exist, the call fails with `table 'x' does not exist, so <resource> cannot extend it`. Wait for the owner first with `awaitTables`.

## What it will not do

It will not rename or drop a column, change a primary key, change an existing column’s type unless `modify = true`, create views, triggers or procedures, or run data migrations. Use your own SQL for those.

## Functions

Two creators, one waiter and their callback forms. All validate the spec before touching the database.

### `Kora.sql.ensureTable(spec)`

Creates the table if it is missing; if it exists, adds whatever is missing (columns, primary key, indexes, foreign keys, checks). Existing columns are never altered or dropped unless you set `modify = true` on that column. Safe to call on every boot.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `spec` | table | Required table description (see Table spec). It is validated first; nothing is sent to the database if any identifier, type or keyword is invalid. |

**Returns**

- **report** — `{ table, created, added_columns, modified_columns, added_indexes, added_fks, added_checks, seeded, warnings }`.
- **err** — `nil` on success, otherwise the message, for example `kora_sql schema: invalid table name 'my-table'`.

**Example**

```lua
local report, err = Kora.sql.ensureTable({
    name = 'my_bank_accounts',
    columns = {
        { name = 'id',         type = 'bigint', unsigned = true, auto_increment = true },
        { name = 'citizenid',  type = 'varchar(50)' },
        { name = 'balance',    type = 'bigint', default = 0 },
        { name = 'label',      type = 'varchar(64)', null = true, default = Kora.sql.NULL },
        { name = 'updated_at', type = 'timestamp', default = { raw = 'CURRENT_TIMESTAMP' }, on_update = 'CURRENT_TIMESTAMP' },
    },
    primary = { 'id' },
    indexes = { { name = 'uniq_account_owner', columns = { 'citizenid' }, unique = true } },
})
if not report then return print('table setup failed:', err) end
if report.created then print('created my_bank_accounts') end
for _, warning in ipairs(report.warnings) do print('warning:', warning) end
```

**Representative console output**

```text
Type, nullability or collation differences on an existing column are reported in `warnings` and logged once per table; nothing is altered. Work on one table name is serialised, so two resources racing on the same table do not interleave DDL.
```

### `Kora.sql.ensureTables(specs)`

Runs `ensureTable` for an ordered list. List parents of foreign keys first. It stops at the first failure.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `specs` | table[] | Required list of table specs. |

**Returns**

- **reports** — list of `ensureTable` reports, one per spec, in order.
- **err** — `nil` on success, otherwise the message of the first failure (reports is then `nil`; tables created before the failure remain).

**Example**

```lua
local reports, err = Kora.sql.ensureTables({ parentSpec, childSpec })
if not reports then return print('schema failed:', err) end
```

**Representative console output**

```text
Passing anything other than a list returns `kora_sql schema: ensureTables expects a list of table specs`.
```

### `Kora.sql.awaitTables(names, timeoutMs?)`

Yields until every named table exists, whoever creates it. Use it before the first query against a table another resource owns, because on a blank database such tables appear a few seconds after startup.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `names` | string[] | Required non-empty list of table names (letters, digits, underscore). |
| `timeoutMs?` | integer | Maximum wait in milliseconds. Default 60000 in the Lua wrapper. |

**Returns**

- **ok** — `true` once every table exists (checked every 250 ms).
- **err** — `nil, message` such as `tables not created within the timeout: players (waiting: my_shop)` or `awaitTables expects a list of table names`.

**Example**

```lua
CreateThread(function()
    local ok, err = Kora.sql.awaitTables({ 'players', 'player_vehicles' }, 120000)
    if not ok then return print(err) end
    loadMyCaches()
end)
```

**Representative console output**

```text
Table names are compared case-insensitively against `information_schema.TABLES` in the current database.
```

### `Kora.sql.ensureTableAsync(spec, cb)`

Callback versions: `ensureTableAsync(spec, cb)` and `ensureTablesAsync(specs, cb)`. They return nothing; `cb(report, errorString)` receives the same values as the yielding versions.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `spec` | table | Table spec (`specs` for `ensureTablesAsync`). |
| `cb` | function | Called as `cb(report, errorString)`. |

**Returns**

- **No value** — the result is delivered to `cb(result, errorString)`. If the driver export cannot be called at all (kora_sql stopped), `cb(nil, errorString)` is called instead of raising.

**Example**

```lua
Kora.sql.ensureTableAsync(mySpec, function(report, err)
    if err then return print('schema failed:', err) end
    print('ready, created =', report.created)
end)
```

**Representative console output**

```text
Both pass the calling resource name so the console log line says which resource created or updated the table.
```

## Safe modify

`columns[].modify = true` allows `MODIFY COLUMN` when the existing definition differs, but only if all of these hold. Otherwise the change is reported in `warnings` and logged at warn with the resource name.

- It cannot lose data. Accepted: longer `varchar` or `char`; `char` to `varchar`; `char` or `varchar` to `text`, `mediumtext`, `longtext` (to `tinytext` only if 4 times the length is at most 255); `binary` or `varbinary` to a blob; a larger integer of the same signedness; an unsigned integer to a strictly larger signed one; an integer to a `decimal` with enough integer digits; a wider `decimal`; a larger text or blob type; more fractional-second digits; `float` to `double`; an enum or set keeping every existing value; `NOT NULL` to `NULL`; and `NULL` to `NOT NULL` once no NULLs remain.
- If the table has a recorded owner, the calling resource is that owner. kora_sql records the creator of every table it creates in `kora_sql_schema_owners` (see [Database](../database.md)). A table with no recorded owner keeps the older behaviour: any resource's safe modify applies with a warn line and does not claim the table. Insert a row into `kora_sql_schema_owners` to give an existing table an owner.
- The spec is not `extend`.
- `kora_sql_schema_allow_modify` is not `false`.

Anything that must convert, backfill or drop existing data has to be done by hand.

## Other notes

- `ensureTables` runs its list in order and stops at the first error. `ensureTableAsync` and `ensureTablesAsync` take a callback instead of yielding.
- `awaitTables` is exempt from `Config.sql.awaitTimeout` (see [Queries](./queries.md)).

## Limits and related APIs

Server only. The type list is fixed (see Column fields). The comparison is by name, so a renamed index is added again as a new one. Generated-column and check expressions are developer SQL and are only screened for `;` and comments. The database user needs DDL privileges.

## Related guides

- [Queries](./queries.md)
- [Configuration](./configuration.md)
