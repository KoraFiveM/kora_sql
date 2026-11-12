---
title: "Compatibility"
sidebar_position: 9
---


# Compatibility

Kora SQL answers to the export names of oxmysql, mysql-async and ghmattimysql so existing resources work without edits. New Kora code should use `Kora.sql.*`. This page explains what is emulated and where behavior differs.

Namespace: `exports.oxmysql · exports['mysql-async'] · exports.ghmattimysql` · Source: `server/compat/*.lua, lib/MySQL.lua, server/js/typecast.js, stubs/*`

## How it works

Each compatibility file registers handlers for `__cfx_export_<resource>_<name>`, the event FiveM uses to resolve an export, so `exports.oxmysql:query(...)` reaches kora_sql even though no resource called `oxmysql` is running. The shim records `GetInvokingResource()` at call time and forwards it, so statistics name the real caller. The oxmysql path calls the `ox*` export variants, which apply oxmysql’s typeCast. Each layer can be switched off in `config.lua` (`Config.compat.*`).

## Move a legacy resource onto Kora SQL

1. **Stop the old driver** — Remove `oxmysql`, `mysql-async` and `ghmattimysql` from `server.cfg`. Do not run them with kora_sql.
2. **Add the placeholder if needed** — If a resource declares a dependency on the old name, deploy the stub from `stubs/oxmysql` or `stubs/mysql-async` after `kora_sql`.
3. **Test the typed results** — Booleans, dates and JSON arrive in oxmysql’s format on this path. Compare a few queries before and after.
4. **Migrate hot paths** — Replace `*Sync` calls and heavy save loops with `Kora.sql.*` and the write queue over time.

## oxmysql typeCast

Applied only on the compatibility path (`exports.oxmysql`, `_async` exports and the `MySQL` global) when `kora_sql_ox_typecast` is true (default). The native API and the ghmattimysql and mysql-async raw exports are not converted.

| Option | Type | Description |
| --- | --- | --- |
| `TINYINT(1)` | boolean | Text queries return `true` or `false`. A different width is returned unchanged. |
| `BIT` | boolean \| integer | One byte equal to 1 gives `true`; otherwise the first byte as a number. |
| `DATETIME / TIMESTAMP` | integer | Milliseconds since the epoch (UTC), or `nil` for NULL. |
| `DATE` | integer | Milliseconds since the epoch at midnight UTC. |
| `BLOB (binary)` | integer[] | A list of byte values for binary blobs; text blobs return a string. |
| `JSON` | string | The raw JSON text, not a table. Decode it with `json.decode`. |
| `prepared statements` | mixed | Prepared statements convert only dates and JSON. |

## Names that are deliberately not provided

The manifest provides `ghmattimysql`. It does not provide `oxmysql` or `mysql-async`: the placeholder stubs own those names so that stopping them cannot stop the driver, and so a version check such as ox_inventory’s sees `2.7.3` instead of `1.0.0`.

## Multi-statement refusal

The oxmysql bridge refuses a text with a `;` followed by more SQL (outside quotes) and answers the callback with `nil, 'multi-statement refused'`. The refusal applies to query, execute, fetch, single, scalar, insert, update and prepare. Set `kora_sql_allow_multiple_statements true` only if you accept the injection risk.

## Blocking calls

`*Sync` functions block the calling thread until the database answers and print a one-time warning per resource. Migrate hot code to `Kora.sql.*`.

## Native bridges

With `kora_inventory` running, the exact statement `DELETE FROM inventories WHERE identifier = 'policetrash'` (with `?`, `:name` or an inline literal bind) is delegated to the native inventory instead of running as SQL. With `kora_housing` running, a fixed set of stock `SELECT` forms on `houselocations` and `player_houses` are answered from native housing state, and other statements touching those two tables fail with an error. Transactions and batches are never rewritten. Everything else passes through unchanged.

## Store handles

The oxmysql `store` export returns the SQL text itself. kora_sql’s own numeric handles (`exports.kora_sql:store`) are only valid for `exports.kora_sql:rawExecute`, live in memory, and are lost on restart.

## Functions

The surfaces that are provided. Behavior matches the original libraries unless noted.

### `exports.oxmysql:query(query, params, cb)`

The oxmysql export surface, served by kora_sql without the placeholder. Names: `query`, `execute` and `fetch` (both behave as `query`), `single`, `scalar`, `insert`, `update`, `prepare`, `rawExecute`, `store`, `transaction`, `startTransaction`, `isReady`, `awaitConnection`, each also as a blocking `...Sync` form, and the promise forms `..._async`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `query` | string | SQL text. |
| `params?` | table | Binds. A callback in this position is shifted into `cb`. |
| `cb?` | function | Callback `cb(result)`. Without it the call returns a promise (async form) or the value (`Sync` form). |

**Returns**

- **The same as upstream oxmysql: `query` returns rows or the result header, `single` a row, `scalar` a value, `insert` the insert id, `update` affected rows.**

**Example**

```lua
-- An unmodified oxmysql script keeps working
exports.oxmysql:query('SELECT * FROM players WHERE citizenid = ?', { cid }, function(rows)
    print(#rows)
end)
local count = MySQL.scalar.await('SELECT COUNT(*) FROM players')
```

**Representative console output**

```text
Results go through the oxmysql typeCast (`kora_sql_ox_typecast`). Statistics are attributed to the real calling resource. A statement with a `;` followed by more SQL is refused with `multi-statement refused`. Blocking `*Sync` calls print a one-time warning per resource while `Config.compat.warnOnSync` is true. `oxmysql:isReady_async` and `awaitConnection_async` exist too.
```

### `exports['mysql-async']:mysql_fetch_all(query, params, cb)`

The raw mysql-async exports: `mysql_fetch_all` (rows), `mysql_fetch_scalar` (one value), `mysql_insert` (insert id), `mysql_execute` (affected rows), `mysql_transaction`, `mysql_store` (handle) and `is_ready`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `query` | string | SQL text. |
| `params?` | table | Binds, or a callback. |
| `cb?` | function | Callback with the result. |

**Returns**

- **Delivered to the callback, as in mysql-async.**

**Example**

```lua
exports['mysql-async']:mysql_execute('UPDATE players SET money = @m WHERE citizenid = @c', { ['@m'] = 500, ['@c'] = cid }, function(affected)
    print(affected)
end)
```

**Representative console output**

```text
Named `@name` binds are converted automatically. The `MySQL.Async` / `MySQL.Sync` global needs `server_script '@kora_sql/lib/MySQL.lua'` (or the placeholder stub).
```

### `exports.ghmattimysql:execute(query, params, cb)`

A small surface: `execute` (returns rows), `executeSync`, `scalar`, `scalarSync` and `transaction`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `query` | string | SQL text. |
| `params?` | table | Binds, or a callback. |
| `cb?` | function | Callback with the result. |

**Returns**

- **Rows for `execute`, a value for `scalar`.**

**Example**

```lua
exports.ghmattimysql:scalar('SELECT COUNT(*) FROM players', {}, function(total) print(total) end)
```

**Representative console output**

```text
The ghmattimysql export results are not typeCast.
```

### `server_script '@kora_sql/lib/MySQL.lua'`

Installs the full current `MySQL` global into your resource: callable `MySQL.query`, `single`, `scalar`, `insert`, `update`, `prepare`, `transaction`, `rawExecute` each with `.await`, lazy `MySQL.Async.*` and `MySQL.Sync.*` aliases (`fetchAll`, `fetchScalar`, `fetchSingle`, `insert`, `execute`, `transaction`, `prepare`), `MySQL.Sync.store`, `MySQL.Async.store`, `MySQL.ready` and `MySQL.ready.await`, and `MySQL.startTransaction`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `mysql_option` | metadata | Add `mysql_option 'return_callback_errors'` to a manifest to receive `(result, err)` in callbacks. |

**Returns**

- **Per method, as in oxmysql.**

**Example**

```lua
local rows = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { cid })
MySQL.update('UPDATE players SET money = ? WHERE citizenid = ?', { 500, cid }, function(affected) end)
```

**Representative console output**

```text
The `.await` form raises the database error instead of returning it, so wrap it in `pcall` when you need to handle the failure. Argument types are checked and raise `First argument expected string, received ...`.
```

## Resource names and stubs

`fxmanifest.lua` does `provide 'ghmattimysql'` only. It deliberately does not provide `oxmysql` or `mysql-async`. Instead:

- `stubs/oxmysql` is a placeholder resource named `oxmysql` (declares `version '2.7.3'`, depends on kora_sql, ships `lib/MySQL.lua`). Deploy it as `resources/[compat]/oxmysql`, ensured after kora_sql, for resources with `dependency 'oxmysql'`, an `@oxmysql/lib/MySQL.lua` include, or a version check (stock ox_inventory requires it).
- `stubs/mysql-async` is the same for `mysql-async` (declares `version '3.3.2'`).
- Their `lib/MySQL.lua` files load kora_sql's `lib/MySQL.lua` into the including resource's VM. The stubs register no exports.

Resources that only call `exports.oxmysql:*` or `exports['mysql-async']:*` work without any stub. Never run the real oxmysql or mysql-async alongside kora_sql.

## Registered export names

- **oxmysql**: `query`, `single`, `scalar`, `insert`, `update`, `prepare`, `execute` and `fetch` (both behave like `query`), `rawExecute`, `transaction`, `startTransaction`, `store`, `isReady`, `awaitConnection`, plus a `*Sync` variant of each (`querySync`, `executeSync`, `fetchSync`, `singleSync`, `scalarSync`, `insertSync`, `updateSync`, `prepareSync`, `transactionSync`, `rawExecuteSync`, `storeSync`, `awaitConnectionSync`, `isReadySync`, `startTransactionSync`). The `_async` promise exports are registered for `query`, `fetch`, `execute`, `single`, `scalar`, `insert`, `update`, `prepare`, `transaction`, `rawExecute`, `store`, `isReady`, `awaitConnection` and `startTransaction`.
- **mysql-async**: `mysql_fetch_all`, `mysql_fetch_scalar`, `mysql_insert`, `mysql_execute`, `mysql_transaction`, `mysql_store`, `is_ready`. These use native result shapes without oxmysql typecast.
- **ghmattimysql**: only `execute`, `executeSync`, `scalar`, `scalarSync` and `transaction`; other ghmattimysql functions are not available. Results use native shapes.

Callbacks may be the second or third argument, and `@name` and `:name` binds are supported. A callback receives only the result (oxmysql behaviour); errors are logged. A rolled-back transaction returns `false` and triggers `oxmysql:transaction-error` (see [Events](./events.md)). Each surface can be turned off with `Config.compat.oxmysql`, `Config.compat.mysqlAsync` and `Config.compat.ghmattimysql` (see [Configuration](./configuration.md)).

## The MySQL global in detail

`@kora_sql/lib/MySQL.lua` (and the stubs' `@oxmysql/lib/MySQL.lua` or `@mysql-async/lib/MySQL.lua`) installs a `MySQL` global in the including resource. `MySQL.ready` is callable and has `.await`. Any other `MySQL.name(...)` call is forwarded to the export of that name on kora_sql. Include it server-side only.

## Native bridges in detail

- **Police trash cleanup.** With `kora_inventory` started (or starting), the exact statement `DELETE FROM inventories WHERE identifier = 'policetrash'` (also with a `?` or named bind, optional backticks and a trailing semicolon) is delegated to `exports.kora_inventory:deleteLegacyPoliceTrash`. Other statements run normally, as does this one when kora_inventory is not running.
- **Housing reads.** Once `kora_housing` has been seen running, ad-hoc statements that mention `houselocations` or `player_houses` outside literals and comments are answered from `exports.kora_housing:readLegacyHousing`. Only a fixed list of `SELECT *` and `SELECT owned` forms with string binds is supported; any other statement naming those tables fails with an explicit error. Calls from `kora_housing` itself are not redirected. After kora_housing stops, such statements fail rather than hitting the stale tables. Standalone stock housing is unaffected if kora_housing has never run.
- Transactions and batches are never rewritten. The behaviour of the target exports is defined in those resources.

## Limits and related APIs

Server only. Do not run the real oxmysql, mysql-async or ghmattimysql beside Kora SQL. The oxmysql typeCast applies to compatibility calls only, so the same query can return different shapes from `Kora.sql.query` and `MySQL.query.await`.

## Related guides

- [Queries](./queries.md)
- [Configuration](./configuration.md)
