---
title: "Driver exports"
sidebar_position: 6
---


# Driver exports

The raw exports registered by the JavaScript driver. `Kora.sql.*` is a thin Lua layer over these. Use them directly for readiness, statistics and the oxmysql-style `store`, `rawExecute` and `startTransaction`, or from code that cannot load `@kora_sql/init.lua`.

Namespace: `exports.kora_sql` · Source: `server/js/exports.js, server/js/index.js, server/js/stats.js, server/js/statements.js`

## How it works

Every data export peels a trailing callback and a trailing resource name off its arguments, waits for the shared readiness promise, runs the work, then calls the callback as `cb(result, null)` or `cb(null, message)`. With no callback it returns a promise instead, which a Lua caller can `Citizen.Await`. If the calling resource stops before the reply, the dropped reply is logged and ignored. Synchronous exports (`isReady`, `version`, `stats`, `slowQueries`, `resetStats`, `store`, `hasActivePlayerOperation`) return immediately.

## Read statistics in your own code

1. **Call stats()** — It returns `nil` until the driver has started. Check for that before reading fields.
2. **Compare totals** — `queries.total` and `queries.errors` show volume and failure rate. `topByTotalMs` shows which SQL texts use the most database time.
3. **Inspect slow queries** — `slowQueries(n)` lists recent offenders with the resource that issued them. Calls through `Kora.sql.*` carry the real invoking resource.
4. **Reset between experiments** — `resetStats()` zeroes everything so you can measure a single change.

## Terms used on this page

| Term | Meaning |
| --- | --- |
| Export | A function one resource publishes for others to call with `exports.resource:name(...)`. |
| Fingerprint | The SQL text used to group statistics. Values are never part of it. |
| Slow log | A ring buffer of the latest queries at or above the slow threshold. |

## Argument peeling

The trailing arguments are interpreted by type: a function is the callback, a string beyond the SQL’s own arity is the resource name, a trailing `nil` is dropped. A bare string SQL argument is never mistaken for a resource name.

## Attribution

Statistics and the slow log label queries with the real invoking resource (`GetInvokingResource()`). A resource name passed as a trailing argument is honoured only when the real invoker is kora_sql itself (its own shims); otherwise it is ignored with a one-time warning. `unknown` appears only when no caller can be determined.

## Errors

With a callback: `cb(nil, message)`. Without one: the returned promise rejects with the error. Either way the failure is logged as `<export> failed for <resource>: <message>; SQL: <text>` without bound values.

## Functions

Readiness, raw data exports, oxmysql-style helpers and observability.

### `exports.kora_sql:isReady()`

Returns whether the pools are connected and the dead-letter table exists. Synchronous and cheap.

**Parameters**



**Returns**

- **ready** — boolean.

**Example**

```lua
if not exports.kora_sql:isReady() then
    return print('database is not ready yet')
end
```

**Representative console output**

```text
Raises (instead of returning false) while kora_sql is stopped or has not finished registering its exports; `Kora.sql.ready` wraps it in `pcall` for that reason.
```

### `exports.kora_sql:awaitConnection()`

Returns a promise that resolves to `true` when the database is ready, or rejects if boot failed. Lua code normally uses `Kora.sql.ready()` instead.

**Parameters**



**Returns**

- **promise** — resolves `true`, or rejects with the boot error.

**Example**

```lua
-- Inside a thread: blocks until the database is ready (this is how the MySQL global's MySQL.ready.await works).
CreateThread(function()
    exports.kora_sql:awaitConnection()
    print('database ready')
end)
```

**Representative console output**

```text
Waits indefinitely while the database is unreachable on a transient error, because boot keeps retrying.
```

### `exports.kora_sql:awaitReady(cb)`

Callback form of `awaitConnection`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `cb` | function | Called as `cb(true, nil)` when ready, or `cb(false, message)` if boot failed. |

**Returns**

- **No value.**

**Example**

```lua
exports.kora_sql:awaitReady(function(ok, err)
    if not ok then return print('database failed:', err) end
    print('database ready')
end)
```

**Representative console output**

```text
If your resource stops before the reply, the dropped reply is logged and ignored.
```

### `exports.kora_sql:version()`

Returns the database version and the driver label.

**Parameters**



**Returns**

- **info** — `{ server = string, isMariaDB = boolean, driver = string }`. Before boot finishes `server` is `'starting'`.

**Example**

```lua
local info = exports.kora_sql:version()
print(info.server, info.isMariaDB, info.driver)   -- e.g. 10.11.6-MariaDB   true   kora_sql/1.0.0
```

**Representative console output**

```text
The driver label is the fixed string `kora_sql/1.0.0`.
```

### `exports.kora_sql:query(sql, params, cb, resource)`

The raw data exports that `Kora.sql.*` is built on. Same names and result shapes as the matching `Kora.sql` functions. Pass a callback as `cb(result, errorString)`; without a callback they return a promise that rejects on error. From another resource prefer `Kora.sql.*`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table | Bind values. |
| `cb?` | function | Optional callback `cb(result, errorString)`. On success `errorString` is `nil`. On failure `result` is `nil` and `errorString` is the message. |
| `resource?` | string | Name of the calling resource, used to label statistics and the slow log. Passed as the trailing argument. |

**Returns**

- **result** — delivered to `cb`, or the promise value.

**Example**

```lua
exports.kora_sql:single('SELECT VERSION() AS v', {}, function(row, err)
    if err then return print(err) end
    print(row.v)
end, GetCurrentResourceName())
```

**Representative console output**

```text
Native exports never apply the oxmysql typeCast. Failures are logged as `<name> failed for <resource>: <message>; SQL: <first 500 characters>`; bound values are not logged.
```

### `exports.kora_sql:prepare(sql, params, cb, resource)`

`prepare` runs a statement once per parameter list and unpacks each response in the oxmysql style (insert id, affected rows, one value, or a row). `rawExecute(handleOrSql, params, cb, resource)` is the same without unpacking. `params` may be one list or a list of lists; one result is returned unwrapped, several as a list.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table | Bind values. |
| `cb?` | function | Optional callback `cb(result, errorString)`. On success `errorString` is `nil`. On failure `result` is `nil` and `errorString` is the message. |
| `resource?` | string | Name of the calling resource, used to label statistics and the slow log. Passed as the trailing argument. |

**Returns**

- **result** — a single value for one parameter list, or a list for several.

**Example**

```lua
local handle = exports.kora_sql:store('SELECT * FROM my_items WHERE owner = ?')
exports.kora_sql:rawExecute(handle, { cid }, function(rows, err)
    if err then return print(err) end
    print(#rows)
end, GetCurrentResourceName())
```

**Representative console output**

```text
`rawExecute` accepts a numeric handle from `store`, or the SQL string. An unknown handle logs `rawExecute called with unknown store handle` and returns nil.
```

### `exports.kora_sql:store(sql, cb?)`

Saves SQL text and returns a numeric handle for `rawExecute`. Handles live in memory only and do not survive a restart of kora_sql.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | The statement text. |
| `cb?` | function | Called with the handle. |

**Returns**

- **handle** — integer, starting at 1.

**Example**

```lua
local handle = exports.kora_sql:store('UPDATE my_items SET qty = ? WHERE id = ?')
```

**Representative console output**

```text
The oxmysql identity (`exports.oxmysql:store`) returns the SQL text unchanged instead, like upstream oxmysql.
```

### `exports.kora_sql:startTransaction(callback, resource?)`

oxmysql-style transaction. `callback(query)` receives a function that runs statements on the pinned connection. The transaction commits when the callback returns anything except `false`, and rolls back when it returns `false` or errors.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `callback` | function | Required. Receives `query(sql, params?)`, which returns the statement’s raw result. |
| `resource?` | string | Calling resource name. |

**Returns**

- **promise** — resolves `true` after COMMIT, `false` after a rollback or error.

**Example**

```lua
-- Commits when the callback returns anything but false; returns false to roll back.
exports.kora_sql:startTransaction(function(query)
    query('UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?', { 500, fromId, 500 })
    query('UPDATE accounts SET balance = balance + ? WHERE id = ?', { 500, toId })
    return true
end, GetCurrentResourceName())
```

**Representative console output**

```text
The export hands back a promise-style value (true after COMMIT, false after a rollback); how the result reaches Lua depends on the FiveM build, so test it on your server before relying on it. Fixed 30-second deadline: after it the transaction is rolled back and the connection is destroyed. A callback that is not a function raises `startTransaction requires a callback`. Prefer `Kora.sql.transactionChecked` for new code.
```

### `exports.kora_sql:hasActivePlayerOperation(citizenid)`

Synchronously reports whether a running `transactionChecked` operation lists this citizen id in `operation.citizenids`. Use it as a guard before releasing a player or loading their data after a restart.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `citizenid` | string | Citizen id to look for. |

**Returns**

- **active** — boolean (false when the transaction runner has not started).

**Example**

```lua
if exports.kora_sql:hasActivePlayerOperation(cid) then
    return false, 'try_again_in_a_moment'
end
```

**Representative console output**

```text
Only operations started with an `operation` table and a `citizenids` list are tracked.
```

### `exports.kora_sql:stats()`

Returns query aggregates, write-queue counters and prepared-statement cache information.

**Parameters**



**Returns**

- **stats** — `{ queries = { total, errors, avgMs, distinctFingerprints, slowCount, slowThreshold, topByTotalMs }, queue = { boundaryCrossings, rowsEnqueued, rowsWritten, coalesceRatio, statementsIssued, statementsPerFlush, flushes, avgFlushMs, deadLettered, retries }, statementCache = { size, maxSize, hits, misses, unpreparable } }`, or `nil` before boot loaded its config.

**Example**

```lua
local s = exports.kora_sql:stats()
if s then
    print(('%d queries, %d errors, coalesce ratio %.2f'):format(s.queries.total, s.queries.errors, s.queue.coalesceRatio))
end
```

**Representative console output**

```text
`topByTotalMs` lists up to ten entries `{ sql, count, totalMs, maxMs, minMs, errors, rowsReturned, lastSeenAt, avgMs }`. `coalesceRatio` is rows enqueued divided by rows written. Statistics are in memory and reset on restart. Resources that load `@kora_sql/init.lua` can also call it as `Kora.sql.stats()`.
```

### `exports.kora_sql:slowQueries(limit?)`

Returns the most recent slow queries, newest first.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `limit?` | integer | How many to return. Default 20. |

**Returns**

- **entries** — list of `{ ms, sql, rows, resource, at }`. `at` is the time in milliseconds since the epoch; `resource` is the caller or `unknown`.

**Example**

```lua
for _, q in ipairs(exports.kora_sql:slowQueries(10)) do
    print(('%.1fms [%s] %s'):format(q.ms, q.resource, q.sql))
end
```

**Representative console output**

```text
A query enters the log when it takes `kora_sql_slow_threshold` ms or more. The log keeps the newest `kora_sql_slow_ring` entries (default 200).
```

### `exports.kora_sql:resetStats()`

Clears all query aggregates, the slow log and the queue counters.

**Parameters**



**Returns**

- **No value.**

**Example**

```lua
exports.kora_sql:resetStats()
```

**Representative console output**

```text
Does nothing before boot. It does not touch pending writes.
```

### `exports.kora_sql:prepareWarm(sqlList)`

Registers a list of hot SQL texts in the statement cache so they count as known and preparable before their first call.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sqlList` | string[] | SQL texts. |

**Returns**

- **result** — `{ warmed = n }`.

**Example**

```lua
exports.kora_sql:prepareWarm({
    'SELECT * FROM players WHERE citizenid = ?',
    'UPDATE players SET money = ? WHERE citizenid = ?',
}, function() end)
```

**Representative console output**

```text
This only primes Kora SQL’s own bookkeeping; it does not send anything to the database.
```

### `exports.kora_sql:enqueue(table, key, row, opts)`

The raw exports behind the `Kora.sql` functions of the same name, with identical arguments and results. `transaction(queries, params, cb, resource)`, `batch(queries, cb)`, `ensureTable(spec, cb, resource)` and `flush(table?, cb)` take a trailing callback; `cb(ok, err)` for `flush`. Use `Kora.sql.*` from Lua; these are for callers outside the include.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `args` | any | As documented for the matching `Kora.sql` function, followed by an optional callback and resource name. |

**Returns**

- **Same as the matching `Kora.sql` function.**

**Example**

```lua
exports.kora_sql:flush('players', function(ok, err)
    print(ok and 'flushed' or ('flush failed: ' .. tostring(err)))
end)
```

**Representative console output**

```text
`enqueue` and `enqueueMany` return nothing and queue behind readiness. `upsert` resolves to the row count, as documented for `Kora.sql.upsert`.
```

## Statistics fields not listed above

`stats()` also reports `queries.evictedQueries` (queries merged into the `<other>` bucket once `kora_sql_stats_max_fingerprints` is exceeded). Statistics group queries by fingerprint: string and number literals become `?`, so concatenated SQL is grouped by shape. `prepareWarm(sqlList)` marks SQL texts as recently used in the prepared-statement cache and returns `{ warmed }`.

## Foreign export identities

kora_sql also registers `exports.oxmysql:*`, `exports['mysql-async']:*` and `exports.ghmattimysql:*` through `__cfx_export_<resource>_<name>` event handlers. These are listed in [Compatibility](./compatibility.md).

## Limits and related APIs

Server only. The `ox*` export variants (`oxQuery`, `oxSingle`, `oxScalar`, `oxInsert`, `oxUpdate`, `oxPrepare`, `oxRawExecute`) exist for the oxmysql compatibility layer and apply the oxmysql typeCast; do not call them from new code.

## Related guides

- [Queries](./queries.md)
- [Compatibility](./compatibility.md)
