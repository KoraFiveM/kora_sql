---
title: Lua API
sidebar_position: 4
---

`Kora.sql.*` is defined by `@kora_sql/init.lua` and is server-side only. Include it after `@kora_lib/init.lua` (see [Installation](./installation.md)). Yielding calls must run inside a thread or event handler; they return `value` or `nil, errString` and never throw across the Lua/JS boundary.

## Readiness

- `Kora.sql.ready(timeoutMs?)` - yields until the driver is up. Returns `true`, or `false, errString`. The default wait is `Config.sql.readyTimeout` of the calling resource, else 60000 ms.
- `Kora.sql.awaitTables(names, timeoutMs?)` - yields until every named table exists, for tables another resource creates. Default 60000 ms. Returns `true` or `nil, errString`.

## Queries

Params may be a positional array or a table of named binds (`@name`, `:name`). Use `Kora.sql.NULL` for an explicit SQL NULL bind value.

```lua
local rows   = Kora.sql.query('SELECT * FROM players WHERE license = ?', { license })
local row    = Kora.sql.single('SELECT * FROM players WHERE citizenid = ?', { cid })
local count  = Kora.sql.scalar('SELECT COUNT(*) FROM players')
local result = Kora.sql.execute('UPDATE players SET bank = ? WHERE citizenid = ?', { 10, cid })
local id     = Kora.sql.insert('INSERT INTO logs (message) VALUES (?)', { 'hi' })
local n      = Kora.sql.update('DELETE FROM logs WHERE id < ?', { 100 })
```

- `query(sql, params)` returns an array of rows.
- `single` returns the first row or `nil`; `scalar` returns the first column of the first row or `nil`.
- `execute` returns `{ affectedRows, insertId, changedRows, warningStatus }`. If the statement returns rows it returns the rows under `rows` with zeroed counts.
- `insert` returns the insert id; `update` returns affected rows.

Statements with bind values are prepared (binary protocol, cached per connection). Statements with no binds use the plain text protocol. SQL that MySQL cannot prepare is remembered and falls back to the text protocol automatically. Statements starting with SELECT, SHOW, WITH or DESC use the read pool; everything else uses the write pool.

## Batches and transactions

```lua
Kora.sql.batch({ { sql = '...', params = {} }, ... })   -- one pinned connection, no transaction
local ok, err = Kora.sql.transaction({
    { sql = 'UPDATE players SET bank = bank - ? WHERE citizenid = ?', params = { amt, from } },
    { sql = 'UPDATE players SET bank = bank + ? WHERE citizenid = ?', params = { amt, to } },
})
Kora.sql.transaction('INSERT INTO t (a) VALUES (?)', { { 1 }, { 2 } })  -- oxmysql "one query, many param sets"
```

`transaction` returns `true`, or `false` after rolling back everything. It also accepts the other oxmysql shapes (a list of strings, `{ query, parameters }` or `{ sql, values }` objects). A rollback triggers the `oxmysql:transaction-error` event (see [Events](./events.md)). Array or table binds inside a transaction or batch use the text protocol, where an array expands to a comma list (`WHERE id IN (?)` with `{ {1,2,3} }`). A table bound to `SET ?` is sent as JSON text and is never expanded into assignments.

### transactionChecked

`Kora.sql.transactionChecked(statements, operation?)` runs on one connection and checks each statement before COMMIT. A statement may set `expectedRows` (affected rows for writes, row count for SELECT) and `failureCode`. A mismatch rolls everything back.

- Success: `{ success = true, results = { ... } }`.
- Confirmed rollback: `{ success = false, code = 'conflict' | 'duplicate' | 'unavailable' | failureCode }`.
- Lost COMMIT reply or failed rollback: `code = 'indeterminate'`. Reconcile with a durable receipt instead of assuming failure.

`operation = { key = ..., fingerprint = ..., citizenids = { ... } }` (key and fingerprint are required strings) makes a second call with the same key join the in-flight worker. Different terms return an indeterminate result. This is an in-memory bridge for a consumer restart, not a durable idempotency store; write your own receipt in the same transaction.

- `Kora.sql.awaitCheckedOperation(key, fingerprint?)` returns `{ active = false }` or `{ active = true, result = outcome }` once settled.
- `Kora.sql.awaitCheckedOperations(prefix)` waits for every active checked operation whose key starts with `prefix` and returns `{ settled = count }`.

## Writes through the queue

`enqueue`, `enqueueMany`, `upsert` and `flush` are covered in [Write queue](./write-queue.md). `ensureTable`, `ensureTables` and their callback variants are covered in [Schema management](./schema.md).

## Other helpers

- `Kora.sql.stats()` - the same table as the `stats` export (see [Exports](./exports.md)).
- `Kora.sql.NULL` - sentinel string for an explicit NULL.

## Callback variants

`queryAsync`, `singleAsync`, `scalarAsync`, `executeAsync`, `insertAsync` and `updateAsync` take `(sql, params, cb)` and call `cb(result, errString)` without yielding. `ensureTableAsync(spec, cb)` and `ensureTablesAsync(specs, cb)` work the same way.

## Waiting limit

If the calling resource's `Config.sql.awaitTimeout` is a positive number of milliseconds, a yielding call with no answer by then returns `nil, errString`. Only the wait ends: the statement keeps running and a write may still commit, so never retry a timed-out write blindly. Unset means wait for the answer (reads are still bounded by `kora_sql_query_timeout`). The limit never applies to `awaitTables`, `ensureTable`, `ensureTables`, `upsert`, `transaction`, `transactionChecked`, `awaitCheckedOperation` or `awaitCheckedOperations`.

## Behaviour notes

- DECIMAL and BIGINT columns are returned as numbers, not strings. The oxmysql-style result conversion applies only on the oxmysql path, never to `Kora.sql.*` (see [Compatibility](./compatibility.md)).
- Multi-statement SQL is refused unless `kora_sql_allow_multiple_statements` is true.
- The caller used for slow-query attribution is the real invoking resource (`GetInvokingResource()`); a resource name passed as a trailing argument is honoured only when the call comes from kora_sql's own shims.
