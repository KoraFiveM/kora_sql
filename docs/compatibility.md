---
title: Compatibility
sidebar_position: 8
---

kora_sql is a drop-in replacement for oxmysql, mysql-async and ghmattimysql. The foreign export surfaces are registered in Lua (`server/compat/*.lua`) by answering the `__cfx_export_<resource>_<name>` event, then forwarding to the JS driver. Each shim passes `GetInvokingResource()` along, so slow queries are attributed to the real caller instead of kora_sql.

Each surface can be turned off with `Config.compat.oxmysql`, `Config.compat.mysqlAsync` and `Config.compat.ghmattimysql` (see [Configuration](./configuration.md)).

## Resource names and stubs

`fxmanifest.lua` does `provide 'ghmattimysql'` only. It deliberately does not provide `oxmysql` or `mysql-async`: sharing the name made `stop oxmysql` stop kora_sql, and after `restart kora_sql` the name resolved to kora_sql. Instead:

- `stubs/oxmysql` is a placeholder resource named `oxmysql` (declares `version '2.7.3'`, depends on kora_sql, ships `lib/MySQL.lua`). Deploy it as `resources/[compat]/oxmysql`, ensured after kora_sql, for resources with `dependency 'oxmysql'`, an `@oxmysql/lib/MySQL.lua` include, or a version check (stock ox_inventory requires it).
- `stubs/mysql-async` is the same for `mysql-async` (declares `version '3.3.2'`).
- Their `lib/MySQL.lua` files load kora_sql's `lib/MySQL.lua` into the including resource's VM. The stubs register no exports.

Resources that only call `exports.oxmysql:*` or `exports['mysql-async']:*` work without any stub. Never run the real oxmysql or mysql-async alongside kora_sql.

## oxmysql exports

Registered under `exports.oxmysql`: `query`, `single`, `scalar`, `insert`, `update`, `prepare`, `execute` and `fetch` (both behave like `query`), `rawExecute`, `transaction`, `startTransaction`, `store`, `isReady`, `awaitConnection`, plus a `*Sync` variant of each (`querySync`, `executeSync`, `fetchSync`, `singleSync`, `scalarSync`, `insertSync`, `updateSync`, `prepareSync`, `transactionSync`, `rawExecuteSync`, `storeSync`, `awaitConnectionSync`, `isReadySync`, `startTransactionSync`). The `_async` promise exports are registered for `query`, `fetch`, `execute`, `single`, `scalar`, `insert`, `update`, `prepare`, `transaction`, `rawExecute`, `store`, `isReady`, `awaitConnection` and `startTransaction`.

- Callbacks may be the second or third argument. `@name` and `:name` binds are supported.
- A callback receives only the result (oxmysql behaviour); errors are logged.
- `store` returns the SQL text unchanged, as upstream.
- The first `*Sync` call per resource prints a warning naming it (`Config.compat.warnOnSync`).
- A rolled-back transaction returns `false` and triggers `oxmysql:transaction-error` ([Events](./events.md)).
- Multi-statement SQL is refused (see below).

## mysql-async exports

`exports['mysql-async']:` `mysql_fetch_all` (query), `mysql_fetch_scalar` (scalar), `mysql_insert` (insert id), `mysql_execute` (affected rows), `mysql_transaction`, `mysql_store`, `is_ready`. These use the native result shapes without oxmysql typecast.

## ghmattimysql exports

`exports.ghmattimysql:` `execute`, `executeSync`, `scalar`, `scalarSync` and `transaction`. Only these five are registered; other ghmattimysql functions are not available. Results use native shapes without oxmysql typecast.

## The MySQL global

`@kora_sql/lib/MySQL.lua` (and the stubs' `@oxmysql/lib/MySQL.lua` or `@mysql-async/lib/MySQL.lua`) installs a `MySQL` global in the including resource: callable `MySQL.query`, `single`, `scalar`, `insert`, `update`, `prepare`, `transaction`, `rawExecute` with `.await`; lazy `MySQL.Async.*` and `MySQL.Sync.*` aliases (`fetchAll`, `fetchScalar`, `fetchSingle`, `insert`, `execute`, `transaction`, `prepare`, `store`); `MySQL.ready` (callable, with `.await`); `MySQL.startTransaction`. Include it server-side only. A `mysql_option 'return_callback_errors'` entry in the including resource's manifest makes callbacks receive `(result, err)`. Any other `MySQL.name(...)` call is forwarded to the export of that name on kora_sql.

## oxmysql typecast

The oxmysql path (the oxmysql exports and `_async` exports, and the `MySQL` global) converts results like oxmysql unless `kora_sql_ox_typecast` is `false`:

- `TINYINT(1)` and `BIT(1)` become booleans; wider `BIT` becomes a number.
- `DATETIME`, `TIMESTAMP` and `DATE` become milliseconds since the epoch (`nil` when empty).
- Binary `BLOB` becomes a byte array; text blobs become strings.
- `JSON` becomes its string form.
- Prepared (bound-parameter) statements convert only dates and JSON, as upstream.

`Kora.sql.*` and `exports.kora_sql:*` are never converted.

## Multi-statement queries

Refused by default: the oxmysql shim detects a second statement outside quotes and calls the callback with `nil, 'multi-statement refused'`, and the pool is created with `multipleStatements` off. `set kora_sql_allow_multiple_statements true` allows them and accepts the SQL-injection amplification risk. Raw connection handles do not exist; use `transaction`.

## Native bridges

Two read paths are redirected to other Kora resources when they are running:

- **Police trash cleanup.** With `kora_inventory` started (or starting), the exact statement `DELETE FROM inventories WHERE identifier = 'policetrash'` (also with a `?` or named bind, optional backticks and a trailing semicolon) is delegated to `exports.kora_inventory:deleteLegacyPoliceTrash`. Other statements run normally, as does this one when kora_inventory is not running. Transactions and batches are not rewritten.
- **Housing reads.** Once `kora_housing` has been seen running, ad-hoc statements that mention `houselocations` or `player_houses` outside literals and comments are answered from `exports.kora_housing:readLegacyHousing`. Only a fixed list of `SELECT *` and `SELECT owned` forms with string binds is supported; any other statement naming those tables fails with an explicit error. Calls from `kora_housing` itself are not redirected. After kora_housing stops, such statements fail rather than hitting the stale tables. Standalone stock housing is unaffected if kora_housing has never run. Transactions and batches are not rewritten.

The behaviour of the target exports is defined in those resources.
