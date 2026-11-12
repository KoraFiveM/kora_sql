---
title: Exports
sidebar_position: 7
---

All exports are server-side and registered by the JS bundle (`dist/build.js`, built from `server/js`). `Kora.sql.*` wraps them; call them directly only when you cannot include `@kora_sql/init.lua`.

Data exports accept an optional trailing callback `cb(result, errString)`. Without a callback they return a promise. The caller's resource name is taken from `GetInvokingResource()`; a name passed as a trailing argument is honoured only when the real invoker is kora_sql itself.

## Readiness

- `isReady()` - `true` once the pools are up and the internal tables exist.
- `awaitConnection()` - promise that resolves `true` when ready.
- `awaitReady(cb)` - calls `cb(true)` when ready, or `cb(false, err)` if boot failed.
- `version()` - `{ server, isMariaDB, driver }`; `server` is `'starting'` before the connection exists.

## Queries

`query`, `single`, `scalar`, `execute`, `insert`, `update`, `prepare` (all `(sql, params, cb?)`), `rawExecute(handleOrSql, params, cb?)`, `store(sql, cb?)`, `batch`, `transaction`, `startTransaction(callback)`. Behaviour matches the `Kora.sql.*` functions in [Lua API](./lua-api.md); `startTransaction` follows oxmysql's callback contract (the callback receives a `query` function and returns `false` to roll back; it times out after 30 seconds).

`store` returns an integer handle held in memory; handles do not survive a restart of kora_sql, and `rawExecute` with an unknown handle logs a warning and returns `nil`.

The `ox*` variants `oxQuery`, `oxSingle`, `oxScalar`, `oxInsert`, `oxUpdate`, `oxPrepare` and `oxRawExecute` are the same operations with oxmysql-style result conversion (gated by `kora_sql_ox_typecast`). They exist for the compat shims and `lib/MySQL.lua`; native callers should use the plain names.

## Transactions with checks

- `transactionChecked(statements, operation?)`
- `awaitCheckedOperation(key, fingerprint?)`
- `awaitCheckedOperations(prefix)`
- `hasActivePlayerOperation(citizenid)` - synchronous; returns whether an active checked operation declared that `citizenids` entry.

## Write queue and schema

`enqueue(table, key, row, opts)`, `enqueueMany(table, key, rows, opts)` (no result; fire and forget), `upsert(table, key, rows, opts)`, `flush(table?, cb?)`, `ensureTable(spec, cb?, resource?)`, `ensureTables(specs, cb?, resource?)`, `awaitTables(names, timeoutMs, cb?, resource?)`. See [Write queue](./write-queue.md) and [Schema management](./schema.md).

`prepareWarm(sqlList)` marks SQL texts as recently used in the prepared-statement cache and returns `{ warmed }`. It does not prepare anything on the server.

## Statistics

- `stats(cb?)` - returns `{ queries = { total, errors, avgMs, distinctFingerprints, evictedQueries, slowCount, slowThreshold, topByTotalMs }, queue = { boundaryCrossings, rowsEnqueued, rowsWritten, coalesceRatio, statementsIssued, statementsPerFlush, flushes, avgFlushMs, deadLettered, retries }, statementCache }`, or `nil` before the driver has started.
- `slowQueries(limit?, cb?)` - entries `{ ms, sql, rows, resource, at }`, newest first, default 20.
- `resetStats()` - clears the counters and slow log.

Statistics group queries by fingerprint: string and number literals become `?`, so concatenated SQL is grouped by shape.

## Foreign export identities

kora_sql also registers `exports.oxmysql:*`, `exports['mysql-async']:*` and `exports.ghmattimysql:*` through `__cfx_export_<resource>_<name>` event handlers. These are listed in [Compatibility](./compatibility.md).
