---
title: "How to use"
sidebar_position: 3
---


# How to use

Kora SQL runs every query as a parameterised, prepared statement on a pooled connection. Your resource loads `@kora_sql/init.lua`, calls `Kora.sql.*` from server scripts, and gets back either a value or `nil, errorMessage`. This page explains the model, shows complete examples and lists what you must handle yourself.

## Your first query

After the manifest in Installation is in place, `Kora.sql` is available in every server Lua file of your resource. The functions yield (they pause the current thread until the database answers), so call them from a `CreateThread`, an event handler, a command handler or a callback, never from the top level of a script file where nothing can yield.

```lua title="server/main.lua"
-- server/main.lua
CreateThread(function()
    -- Optional gate: yields until the pool is connected (default wait 60 s).
    local ready, readyErr = Kora.sql.ready()
    if not ready then
        return print('database not ready:', readyErr)
    end

    -- One row, or nil when there is none.
    local player, err = Kora.sql.single('SELECT citizenid, money FROM players WHERE citizenid = ?', { 'ABC12345' })
    if err then
        return print('query failed:', err)
    end
    if not player then
        return print('no such player')
    end
    print(player.citizenid, player.money)
end)
```

- Every yielding function returns `value, errorString`. On success the second value is `nil`. On failure the first value is `nil` and the second is the message. The call itself does not throw.
- `single`, `scalar` and `query` also return `nil` (with no error) or an empty table when there is simply no data. Check `err` first, then check for the empty result.
- Replace `players` and `citizenid` with your own table and columns. Kora SQL does not know your schema.

## Which function returns what

Pick the function by the shape of the answer you need. All of them take `(sql, params)`.

```text title="result shapes"
-- query: array of rows (empty table when nothing matches)
local rows = Kora.sql.query('SELECT id, name FROM my_items WHERE owner = ?', { cid })
-- rows = { { id = 1, name = 'bread' }, { id = 2, name = 'water' } }

-- single: first row or nil
local row = Kora.sql.single('SELECT * FROM my_items WHERE id = ?', { 1 })

-- scalar: first column of the first row, or nil
local total = Kora.sql.scalar('SELECT COUNT(*) FROM my_items WHERE owner = ?', { cid })

-- insert: the AUTO_INCREMENT id (0 when the table has none)
local newId = Kora.sql.insert('INSERT INTO my_items (owner, name) VALUES (?, ?)', { cid, 'bread' })

-- update: number of affected rows
local affected = Kora.sql.update('UPDATE my_items SET name = ? WHERE id = ?', { 'water', newId })

-- execute: a small table with all four write counters
local result = Kora.sql.execute('DELETE FROM my_items WHERE id = ?', { newId })
-- result = { affectedRows = 1, insertId = 0, changedRows = 0, warningStatus = 0 }
```

- `query` returns the raw mysql2 result of the statement. For a SELECT that is an array of rows. For an INSERT/UPDATE/DELETE it is the result header (`affectedRows`, `insertId`, `changedRows`, `warningStatus`, ...), because `query` is not SELECT-only.
- `execute` always returns the four-counter table for a write. If you wrongly call it with a SELECT it returns `{ affectedRows = 0, insertId = 0, changedRows = 0, warningStatus = 0, rows = <the rows> }` instead of crashing.
- `insert` returns `insertId` and `update` returns `affectedRows`. Both go through `execute`.
- `affectedRows` and `changedRows` can differ for an UPDATE: `changedRows` (from `execute`) counts only rows whose stored value actually changed. Use it when “was anything really modified” matters.

## Binding values: placeholders and parameters

Values never go into the SQL text. Write a placeholder where the value belongs and pass the value in `params`. Kora SQL sends the statement and the values to MariaDB/MySQL separately, so a value can never change the structure of the query.

```lua title="binding.lua"
-- Positional: one value per ?, in order.
Kora.sql.query('SELECT * FROM my_items WHERE owner = ? AND name = ?', { cid, 'bread' })

-- Named: table with string keys. :name and @name are both accepted.
Kora.sql.query('SELECT * FROM my_items WHERE owner = :owner AND name = :name', { owner = cid, name = 'bread' })
Kora.sql.query('SELECT * FROM my_items WHERE owner = @owner', { ['@owner'] = cid })   -- a leading @ or : in the key is allowed

-- A single non-table value counts as a one-item list.
Kora.sql.scalar('SELECT COUNT(*) FROM my_items WHERE owner = ?', cid)

-- Optional value: write an explicit NULL, never a hole in the list.
Kora.sql.insert('INSERT INTO my_items (owner, note) VALUES (?, ?)', { cid, note or Kora.sql.NULL })

-- IN (...) lists: build one ? per value, then bind them. Never concatenate the values.
local ids = { 4, 8, 15 }
local marks = string.rep('?,', #ids):sub(1, -2)
local rows = Kora.sql.query(('SELECT * FROM my_items WHERE id IN (%s)'):format(marks), ids)
```

- `?` placeholders are filled from a list in order. `:name` and `@name` placeholders are filled from a table with string keys. Do not mix the two styles in one statement.
- `@name` is converted to `:name` before execution only when `params` is a table with string keys, and only outside quoted strings, backticked identifiers and comments. When you pass a positional list, an `@` in the SQL (for example a MySQL user variable `@x`) is left untouched.
- A Lua list cannot hold `nil`: `{ a, nil, b }` leaves a gap that would either truncate the list or reach the driver as `undefined`. Kora SQL repairs this: a sparse list is rebuilt densely and gaps become SQL `NULL`. Prefer being explicit with `Kora.sql.NULL`, which is the string `\0kora_sql:null\0` that the driver converts back to `NULL`.
- Values are sent as JavaScript values: numbers, strings, booleans, `NULL`. A Lua table value is not a valid scalar bind. Encode it first, for example `json.encode(data)` for a JSON or text column.
- Identifiers (table and column names) cannot be bound. If one must vary, choose it from a fixed list in your own code. See Security.
- Result values: `DECIMAL` and `BIGINT` come back as numbers (not strings). `DATETIME`/`TIMESTAMP`/`DATE` come back as JavaScript dates that reach Lua as a number (milliseconds since the epoch). `NULL` columns are `nil` in Lua, so a row table has no key for them. These native result shapes are never altered. The oxmysql typeCast conversions only apply on the compatibility path (see Compatibility).

## How a query is executed

1. **Wait for readiness** — The call waits behind the single boot promise. If the database is still connecting the call waits; if boot failed the call returns `nil, <boot error>`.

2. **Normalise the parameters** — `nil` becomes an empty list, a scalar becomes a one-item list, `Kora.sql.NULL` and gaps become `NULL`, and `@name` placeholders are converted to `:name`.

3. **Choose a pool** — Statements whose first word is `SELECT`, `SHOW`, `WITH` or `DESC` go to the read pool. Everything else, including anything ambiguous, goes to the write pool. Both pools point at the same database; the split only keeps a burst of slow reads from starving writes.

4. **Run as a prepared statement** — The statement runs through mysql2’s `execute` (a prepared statement, cached per connection by `kora_sql_statement_cache`). If the server answers `ER_UNSUPPORTED_PS`, `ER_WRONG_ARGUMENTS` or `ER_PARSE_ERROR_IN_PS` the statement cannot be prepared: Kora SQL falls back to a normal `query()` and remembers that this exact SQL text is unpreparable, so the failed prepare is paid only once per text.

5. **Record timing and shape the result** — Duration, row count and errors are recorded per SQL text (see Statistics). Anything at or over `kora_sql_slow_threshold` ms is added to the slow log together with the calling resource. The raw result is then reduced to the shape of the function you called.

6. **Answer** — The Lua wrapper hands your thread the value, or `nil, errorString` when the driver reported an error. Errors are also logged to the server console with the resource name and the first 500 characters of the SQL, never the bound values.

## Handling errors in your own resource

Failures are values, not exceptions, so each of these must be checked by the code that called:

```text title="error handling"
local rows, err = Kora.sql.query('SELECT id FROM my_items WHERE owner = ?', { cid })
if err then
    print('my_items lookup failed:', err)
    return false, 'database_error'
end
if #rows == 0 then
    return true, {}
end
return true, rows
```

- Connection failures: before ready the call waits; after a boot failure it returns the boot error. If the connection drops while running, the call returns the mysql2 error message (`nil, message`). Pool connections use TCP keep-alive; Kora SQL has no extra reconnect logic beyond what mysql2’s pool does.
- Invalid SQL, missing tables or columns, constraint violations: returned as `nil, "<message from the server>"`, for example `Table 'kora.my_items' doesn't exist` or `Duplicate entry 'x' for key ...`.
- Bad binds: a table value in a bind position or the wrong number of values produces a driver error returned the same way.
- Timeouts: a read-pool statement fails after `kora_sql_query_timeout` ms (default 30000, `0` disables); writes are never timed out client-side because a timed-out write may still commit. A call waiting for a free pool connection fails with `KORA_SQL_ACQUIRE_TIMEOUT` after `kora_sql_acquire_timeout` ms (default 30000), or with `Queue limit reached.` when more than `kora_sql_pool_queue_limit` callers (default 10000) are waiting. A new connection attempt gives up after 10 seconds (`connectTimeout`). If the calling resource sets `Config.sql.awaitTimeout` to a positive number, a yielding call also returns `nil, err` when no answer arrives in that time (see [Queries](./api/queries.md)).
- Transactions: `Kora.sql.transaction` returns `false` (not an error string) when it rolled back. `Kora.sql.transactionChecked` returns a table with `success = false` and a `code`. See the Transactions module.
- Empty results: an empty table from `query`, `nil` from `single` and `scalar`. An `UPDATE` that matches nothing returns `0`.
- Missing tables on a fresh database: use `Kora.sql.ensureTable(s)` for your own tables and `Kora.sql.awaitTables` for tables other resources create.

## Server only: client code never talks to the database

Kora SQL has no client scripts and no client exports. The connection string, the pools and every query live on the server. A client resource that needs data must ask the server through a net event, and the server resource decides what to query.

```lua title="server/main.lua"
-- Server: the client sends a bare request; the server owns the SQL and the identity.
RegisterNetEvent('my_shop:server:requestOrders', function()
    local src = source
    local player = exports.kora_core:getPlayer(src)        -- identity comes from the server, never from the client
    if not player then return end
    CreateThread(function()
        local rows, err = Kora.sql.query('SELECT id, status FROM my_orders WHERE citizenid = ? ORDER BY id DESC LIMIT 50', { player.citizenid })
        if err then return end
        TriggerClientEvent('my_shop:client:orders', src, rows)
    end)
end)
```

- Never accept SQL text, table names, column names, `ORDER BY` fragments or `WHERE` clauses from a client. Accept small values (an id, a quantity, a choice from a fixed list) and validate them on the server.
- Never take an identity such as a citizen id from a client argument. Derive it from `source` on the server.
- The example identifies the player with `exports.kora_core:getPlayer(src)` (Kora Core). Use whatever player lookup your server uses; only `Kora.sql.query` belongs to Kora SQL.

## Full worked example: a small resource that stores orders

This resource creates its table, inserts, reads, updates, checks existence, deletes and runs a transaction. Every call is a real `Kora.sql` function documented in this resource.

```lua title="server/orders.lua"
-- 1. Create the table on every boot (safe: only missing parts are added).
CreateThread(function()
    local report, err = Kora.sql.ensureTable({
        name = 'my_orders',
        columns = {
            { name = 'id',         type = 'bigint', unsigned = true, auto_increment = true },
            { name = 'citizenid',  type = 'varchar(50)' },
            { name = 'item',       type = 'varchar(64)' },
            { name = 'amount',     type = 'int', unsigned = true, default = 1 },
            { name = 'status',     type = 'enum', values = { 'open', 'done' }, default = 'open' },
            { name = 'created_at', type = 'timestamp', default = { raw = 'CURRENT_TIMESTAMP' } },
        },
        primary = { 'id' },
        indexes = { { name = 'idx_orders_citizen', columns = { 'citizenid' } } },
    })
    if not report then return print('my_orders setup failed:', err) end
    for _, warning in ipairs(report.warnings) do print('schema warning:', warning) end
end)

-- 2. Insert: returns the new id.
function CreateOrder(cid, item, amount)
    local id, err = Kora.sql.insert('INSERT INTO my_orders (citizenid, item, amount) VALUES (?, ?, ?)', { cid, item, amount })
    if err then return nil, err end
    return id
end

-- 3. Fetch one / many.
function GetOrder(id)
    return Kora.sql.single('SELECT * FROM my_orders WHERE id = ?', { id })
end

function GetOpenOrders(cid)
    return Kora.sql.query('SELECT id, item, amount FROM my_orders WHERE citizenid = ? AND status = ?', { cid, 'open' })
end

-- 4. Does a record exist?
function HasOpenOrder(cid)
    local count = Kora.sql.scalar('SELECT COUNT(*) FROM my_orders WHERE citizenid = ? AND status = ?', { cid, 'open' })
    return (count or 0) > 0
end

-- 5. Update: number of rows changed.
function CompleteOrder(id)
    local affected = Kora.sql.update('UPDATE my_orders SET status = ? WHERE id = ? AND status = ?', { 'done', id, 'open' })
    return affected == 1
end

-- 6. Delete.
function DeleteOrder(id)
    local result = Kora.sql.execute('DELETE FROM my_orders WHERE id = ?', { id })
    return result and result.affectedRows == 1
end

-- 7. Several statements that must all succeed or all roll back.
function MoveOrders(fromCid, toCid)
    local ok = Kora.sql.transaction({
        { sql = 'UPDATE my_orders SET citizenid = ? WHERE citizenid = ?', params = { toCid, fromCid } },
        { sql = 'DELETE FROM my_orders WHERE citizenid = ? AND status = ?', params = { toCid, 'done' } },
    })
    return ok == true
end
```

## Another way: the oxmysql MySQL global

Resources written for oxmysql or mysql-async can keep their code. Include the global in the manifest and use `MySQL.query.await` and friends. New Kora resources should prefer `Kora.sql.*` (clearer errors, no blocking calls).

```lua title="fxmanifest.lua"
server_script '@kora_sql/lib/MySQL.lua'  -- direct equivalent of '@oxmysql/lib/MySQL.lua'
```

> **Note:** The `MySQL` global goes through the oxmysql compatibility path, so its results use the oxmysql typeCast (booleans for `TINYINT(1)`, dates as milliseconds, JSON as text). See the Compatibility module.

## Waiting for tables and the database

On a blank database, tables created by other resources appear some seconds after start: call `Kora.sql.awaitTables({ 'players' })` before the first query against them. See [Schema](./api/schema.md) and [Queries](./api/queries.md).

## Where to go next

- [Queries](./api/queries.md) - every query function, result shapes and callback variants.
- [Transactions](./api/transactions.md) - `transaction`, `batch` and `transactionChecked`.
- [Write queue](./api/write-queue.md) - coalesced saves with `enqueue`, `enqueueMany`, `upsert` and `flush`.
- [Schema](./api/schema.md) - `ensureTable` and `ensureTables`.
- [Security and best practices](./api/security.md) - what to validate before exposing a query.
- [Troubleshooting](./troubleshooting.md) - common errors and fixes.
