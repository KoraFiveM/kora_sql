---
title: "Queries"
sidebar_position: 2
---


# Queries

The everyday API: run a parameterised statement and get rows, one row, one value, an insert id or a count. Every function yields until the database answers and returns `value, errorString`. It is installed into your own resource by `@kora_sql/init.lua` and only works on the server.

Namespace: `Kora.sql` · Source: `init.lua, server/js/execute.js, server/js/exports.js`

## How it works

Each wrapper calls the matching JS export on `exports.kora_sql`, passes a Lua callback, and waits on a promise. Any error becomes `nil, message`; the call never throws. The caller used for slow-query attribution is the real invoking resource (`GetInvokingResource()`); `ensureTable(s)` and `awaitTables` also pass the resource name explicitly. The JS side runs the statement as a prepared statement on the read or write pool, normalises the binds, records timing, and reduces the result to the requested shape.

## Run a query safely

1. **Write the SQL with placeholders** — Use `?` (or `:name`) for every value. Table and column names are written literally by you and never come from a player.
2. **Pass the values in params** — Put the values in a list in placeholder order, or in a table keyed by name. Use `Kora.sql.NULL` for a deliberate NULL.
3. **Check the error first** — Read the second return value. If it is set, the first value is `nil`; log it and stop or return a failure to the caller.
4. **Handle empty results** — `query` can return an empty table; `single` and `scalar` can return `nil`. Treat that as “not found”, not as an error.
5. **Keep the work small** — Select only the columns you need, add `LIMIT`, and cache values you read repeatedly instead of querying on every player action.

## Terms used on this page

| Term | Meaning |
| --- | --- |
| Yielding | The function pauses the current Lua thread until the answer arrives, while the server keeps running. Call it from a thread, event handler or callback. |
| Placeholder | A `?` or `:name` in the SQL text that marks where a bound value goes. |
| Fingerprint | The SQL text itself. Because every value is bound, the text is stable and is what statistics are grouped by. |
| Read pool / write pool | Two connection pools over the same database. SELECT, SHOW, WITH and DESC statements use the read pool; everything else uses the write pool. |

## Result shapes

What each function hands back on success.

| Option | Type | Description |
| --- | --- | --- |
| `query` | table | Array of row tables for a SELECT (may be empty); the mysql2 result header (`affectedRows`, `insertId`, `changedRows`, `warningStatus`, ...) for a write. |
| `single` | table \| nil | First row, or `nil`. |
| `scalar` | any \| nil | First column of the first row, or `nil`. |
| `execute` | table | `{ affectedRows, insertId, changedRows, warningStatus }`. |
| `insert` | integer | `insertId`. |
| `update` | integer | `affectedRows`. |

## Kora.sql.NULL

`Kora.sql.NULL` is the string `\0kora_sql:null\0`. Put it in a bind list where you want SQL `NULL`. It is also accepted in `default` values of `ensureTable` and in `seed` rows. Compare against the constant, not the literal.

## One statement per call

The pool runs with `multipleStatements` off, so a text containing several `;`-separated statements is rejected by the database. This is deliberate: multi-statement text amplifies SQL injection. The convar `kora_sql_allow_multiple_statements` turns it on for the text-protocol fallback only, and prepared statements can never carry more than one statement. Use `Kora.sql.transaction` or `Kora.sql.batch` for several statements.

## Prepared statements and fallback

Repeated SQL text reuses mysql2’s per-connection prepared-statement cache (`kora_sql_statement_cache` entries per connection, to a total ceiling of 8000 across all connections). Placeholders in identifier positions and a few DDL or SET forms cannot be prepared. Those fall back to a text-protocol query automatically and are remembered. `exports.kora_sql:prepareWarm({ sql, ... })` registers texts ahead of time.

## Waiting limit and query timeout

If the calling resource's own `Config.sql.awaitTimeout` is a positive number of milliseconds, a yielding call with no answer by then returns `nil, errString` (`kora_sql: no reply to <name> within <n>ms; the statement may still complete`). Only the wait ends: the statement keeps running and a write may still commit, so never retry a timed-out write blindly. Unset means wait for the answer. The limit never applies to `awaitTables`, `ensureTable`, `ensureTables`, `upsert`, `transaction`, `transactionChecked`, `awaitCheckedOperation` or `awaitCheckedOperations`.

Read-pool statements are additionally bounded server-side by `kora_sql_query_timeout` (default 30000 ms, `0` disables). Writes are never timed out client-side. Keep statements fast with indexes and `LIMIT`, and use the slow log to find offenders. See [Configuration](./configuration.md).

## Same resource restarts

If kora_sql is stopped while your call is waiting, the call returns `nil, <message>` (or the callback is not answered if your own resource also stopped). Never assume a query finished because your thread resumed: check the second return value.

## Functions

Seven yielding functions, one readiness gate and six callback variants. All take `(sql, params)`.

### `Kora.sql.ready(timeoutMs?)`

Waits until the connection pool is up. It polls the driver every 50 ms and returns `true` immediately when it is already ready. Use it to gate startup code. Individual queries already wait for readiness on their own, so this is optional.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `timeoutMs?` | integer | Maximum wait in milliseconds. When omitted, `Config.sql.readyTimeout` from the calling resource’s own `Config` table is used if it exists, otherwise 60000. |

**Returns**

- **ok** — `true` when the pool is ready.
- **reason** — `false, 'kora_sql not ready within timeout'` when the wait expired.

**Example**

```lua
CreateThread(function()
    local ok, reason = Kora.sql.ready(15000)
    if not ok then
        return print('database unavailable:', reason)
    end
    startMyResource()
end)
```

**Representative console output**

```text
Returns true as soon as exports.kora_sql:isReady() is true. While the driver is stopped, the check is treated as "not ready" instead of raising.
```

### `Kora.sql.query(sql, params?)`

Runs one statement and returns whatever mysql2 returns for it: an array of row tables for a SELECT, or the result header for a write. Use it for lists.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table \| scalar | Values bound to the placeholders. A positional list `{ a, b }` for `?`, or a table with string keys for `:name` / `@name`. A single non-table value is treated as a one-item list. Omit it or pass `nil` for no binds. Use `Kora.sql.NULL` for an intentional SQL NULL. |

**Returns**

- **rows** — array of row tables (empty when nothing matches), or the result header for INSERT/UPDATE/DELETE.
- **err** — `nil` on success, otherwise the error message string (rows is then `nil`).

**Example**

```lua
local rows, err = Kora.sql.query('SELECT id, name FROM my_items WHERE owner = ? ORDER BY id LIMIT ?', { cid, 25 })
if err then return print('lookup failed:', err) end
for _, row in ipairs(rows) do
    print(row.id, row.name)
end
```

**Representative console output**

```text
Yields until the database answers. SELECT/SHOW/WITH/DESC run on the read pool, everything else on the write pool.
```

### `Kora.sql.single(sql, params?)`

Runs one statement and returns only the first row. Add `LIMIT 1` yourself: Kora SQL still fetches every row the SQL returns and then discards the rest.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table \| scalar | Values bound to the placeholders. A positional list `{ a, b }` for `?`, or a table with string keys for `:name` / `@name`. A single non-table value is treated as a one-item list. Omit it or pass `nil` for no binds. Use `Kora.sql.NULL` for an intentional SQL NULL. |

**Returns**

- **row** — the first row table, or `nil` when no row matched.
- **err** — `nil` on success, otherwise the error message.

**Example**

```lua
local player, err = Kora.sql.single('SELECT citizenid, charinfo FROM players WHERE citizenid = ? LIMIT 1', { cid })
if err then return nil, err end
if not player then return nil, 'unknown_player' end
return player
```

**Representative console output**

```text
A statement that is not a SELECT (so the raw result is not an array) returns nil.
```

### `Kora.sql.scalar(sql, params?)`

Returns the first column of the first row, or `nil` when there is no row. Ideal for `COUNT(*)`, `MAX(...)`, `EXISTS(...)` and single settings.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table \| scalar | Values bound to the placeholders. A positional list `{ a, b }` for `?`, or a table with string keys for `:name` / `@name`. A single non-table value is treated as a one-item list. Omit it or pass `nil` for no binds. Use `Kora.sql.NULL` for an intentional SQL NULL. |

**Returns**

- **value** — the first column of the first row, or `nil`.
- **err** — `nil` on success, otherwise the error message.

**Example**

```lua
local count, err = Kora.sql.scalar('SELECT COUNT(*) FROM my_items WHERE owner = ?', { cid })
if err then return nil, err end
return count or 0
```

**Representative console output**

```text
Because a `NULL` first column is also `nil`, use `COALESCE(col, 0)` when you need to tell "no row" apart from a number.
```

### `Kora.sql.execute(sql, params?)`

Runs a write and returns all four counters. Use it when you need more than one of them.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table \| scalar | Values bound to the placeholders. A positional list `{ a, b }` for `?`, or a table with string keys for `:name` / `@name`. A single non-table value is treated as a one-item list. Omit it or pass `nil` for no binds. Use `Kora.sql.NULL` for an intentional SQL NULL. |

**Returns**

- **result** — table `{ affectedRows, insertId, changedRows, warningStatus }` with every field a number (0 when absent). A SELECT passed here returns the same table plus `rows`.
- **err** — `nil` on success, otherwise the error message.

**Example**

```lua
local result, err = Kora.sql.execute('UPDATE my_items SET qty = qty + ? WHERE id = ?', { 5, itemId })
if err then return false end
return result.changedRows > 0
```

**Representative console output**

```text
Unlike `query`, a write never returns the raw header; only the four documented counters.
```

### `Kora.sql.insert(sql, params?)`

Runs an INSERT and returns its `AUTO_INCREMENT` id.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table \| scalar | Values bound to the placeholders. A positional list `{ a, b }` for `?`, or a table with string keys for `:name` / `@name`. A single non-table value is treated as a one-item list. Omit it or pass `nil` for no binds. Use `Kora.sql.NULL` for an intentional SQL NULL. |

**Returns**

- **insertId** — the new row id (0 when the table has no auto-increment column).
- **err** — `nil` on success, otherwise the error message.

**Example**

```lua
local id, err = Kora.sql.insert('INSERT INTO my_orders (citizenid, item, amount) VALUES (?, ?, ?)', { cid, 'bread', 3 })
if err then return nil, err end
return id
```

**Representative console output**

```text
A duplicate key or constraint failure is returned as nil plus the server’s message (for example "Duplicate entry ...").
```

### `Kora.sql.update(sql, params?)`

Runs an UPDATE or DELETE and returns the number of affected rows. Use it for "did anything change" checks.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params?` | table \| scalar | Values bound to the placeholders. A positional list `{ a, b }` for `?`, or a table with string keys for `:name` / `@name`. A single non-table value is treated as a one-item list. Omit it or pass `nil` for no binds. Use `Kora.sql.NULL` for an intentional SQL NULL. |

**Returns**

- **affectedRows** — number of rows affected.
- **err** — `nil` on success, otherwise the error message.

**Example**

```lua
local affected = Kora.sql.update('DELETE FROM my_orders WHERE id = ? AND citizenid = ?', { orderId, cid })
if affected ~= 1 then return false, 'not_found' end
return true
```

**Representative console output**

```text
On failure the first value is nil (not 0), so `affected == 0` means "no rows matched" and `affected == nil` means "the query failed".
```

### `Kora.sql.queryAsync(sql, params, cb)`

Callback versions of the six functions above for code that does not want to yield. They return nothing; the result arrives in `cb`. Same names with `single`, `scalar`, `execute`, `insert` and `update` in place of `query`.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `sql` | string | Required SQL text with `?` placeholders (or `:name` / `@name` placeholders when `params` is a table with string keys). One statement only: multi-statement text is not supported by default. |
| `params` | table \| scalar | Bind values, or `nil`. Required positionally because the callback comes after it. |
| `cb` | function | Called as `cb(result, errorString)` with the same result shape as the matching yielding function. |

**Returns**

- **No value** — the result is delivered to `cb(result, errorString)`. If the driver export cannot be called at all (kora_sql stopped), `cb(nil, errorString)` is called instead of raising.

**Example**

```lua
Kora.sql.singleAsync('SELECT money FROM players WHERE citizenid = ?', { cid }, function(row, err)
    if err then return print('failed:', err) end
    if row then print('balance', row.money) end
end)
```

**Representative console output**

```text
The callback is invoked on the Lua side after the driver answers. If the export cannot be called, the callback receives nil and the error text.
```

## More behaviour notes

- Params may be a positional array or a table of named binds (`@name`, `:name`). `Kora.sql.NULL` is the explicit SQL NULL bind value.
- `execute` returns `{ affectedRows, insertId, changedRows, warningStatus }`; if the statement returns rows it returns them under `rows` with zeroed counts.
- Statements with bind values are prepared (binary protocol, cached per connection). Statements with no binds use the plain text protocol. SQL that MySQL cannot prepare is remembered and falls back to the text protocol automatically.
- DECIMAL and BIGINT columns are returned as numbers, not strings. The oxmysql-style result conversion applies only on the oxmysql path, never to `Kora.sql.*` (see [Compatibility](./compatibility.md)).
- Multi-statement SQL is refused unless `kora_sql_allow_multiple_statements` is true.
- `Kora.sql.stats()` returns the same table as the `stats` export (see [Driver exports](./driver-exports.md)).
- `Kora.sql.awaitTables(names, timeoutMs?)` is documented in [Schema](./schema.md); `Kora.sql.enqueue`, `enqueueMany`, `upsert` and `flush` in [Write queue](./write-queue.md).
- The callback variants are `queryAsync`, `singleAsync`, `scalarAsync`, `executeAsync`, `insertAsync` and `updateAsync` with `(sql, params, cb)`; `ensureTableAsync(spec, cb)` and `ensureTablesAsync(specs, cb)` work the same way.

## Limits and related APIs

Server only. Only the first statement kind in a call is run: no multi-statement text. `single` still fetches all rows the SQL returns, so use `LIMIT 1`. Bind values must be numbers, strings, booleans or `NULL`; encode tables yourself. The native shapes are never altered; booleans and dates are only converted on the oxmysql compatibility path.

## Related guides

- [Transactions and batches](./transactions.md)
- [Write queue](./write-queue.md)
- [Schema: ensureTable](./schema.md)
- [Configuration](./configuration.md)
