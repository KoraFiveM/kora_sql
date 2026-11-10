---
layout: default
title: kora_sql
---

A Node + mysql2 database driver for FiveM, built to replace oxmysql. **Write
coalescing** merges per-row saves by primary key and batches them into a single
`INSERT ... ON DUPLICATE KEY UPDATE` per flush; **split read/write pools** keep
save-flush latency independent of read load; a **prepared-statement LRU**
remembers which SQL text can't be prepared so a failed prepare is paid at most
once. Ships full drop-in compatibility with `oxmysql`, `mysql-async`, and
`ghmattimysql` — existing resources that query the database keep working
unmodified, no code changes required.

Two ways to use it: the modern `Kora.sql.*` API for new code, or the
`exports.oxmysql:*` / `MySQL.*` / `exports.ghmattimysql:*` compat surfaces for
everything already written against those drivers.

## Requirements

kora_sql is foundational — it has no dependency on kora_lib or kora_core, and everything
else in the [qbcore2](https://github.com/qbcore2) set depends on it. It needs:

- A running MySQL/MariaDB server.
- `set mysql_connection_string "..."` in `server.cfg` — deliberately the same
  convar name oxmysql uses, so an existing server migrates untouched.
- The packaged `dist/build.js`, which includes mysql2 in the same way oxmysql's
  release artifact does. Runtime `node_modules` and FiveM builder resources are
  not required.

## Installation

`kora_sql` must be `ensure`d before kora_lib/kora_core (and before any other resource
that queries the database) so the pool exists when they boot:

```
set mysql_connection_string "mysql://user:pass@localhost/kora_core?charset=utf8mb4"
ensure kora_sql
ensure kora_lib
ensure kora_core
```

Source contributors run `yarn install` and `yarn build`; server operators use
the committed bundle and do not need Yarn or a package install.

Optional convars (defaults shown):
```
set kora_sql_read_pool_size 16
set kora_sql_write_pool_size 8
set kora_sql_statement_cache 256      # cache * (read+write pools) must be <= 8000 (old name kora_sql_statement_cache still read)
set kora_sql_default_collate utf8mb4_unicode_ci # collation for tables ensureTable creates without one; "" = server default
set kora_sql_flush_interval 250       # ms between coalescing flushes
set kora_sql_max_pending_rows 500     # high-water mark that forces a flush
set kora_sql_slow_threshold 150       # ms; queries slower than this hit the slow log
set kora_sql_allow_multiple_statements false
set kora_sql_ox_typecast true      # oxmysql-style result conversion on the oxmysql path (see below)
set kora_sql_debug false
```

kora_sql serves `exports.oxmysql:*` / `exports['mysql-async']:*` itself, so those
calls work with or without the placeholder. It does **not** `provide 'oxmysql'`.
Any resource that declares `dependency 'oxmysql'`, includes `@oxmysql/lib/MySQL.lua`
or checks the oxmysql version needs the `stubs/oxmysql` placeholder ensured after
kora_sql.

Stock ox_inventory **requires** the placeholder: deploy `stubs/oxmysql` as
`[compat]/oxmysql`, ensured after kora_sql and before ox_lib/ox_inventory. It declares
`version '2.7.3'` and ships `lib/MySQL.lua`. Real oxmysql must not run alongside it.
See `stubs/oxmysql/README.md`.

kora_sql no longer `provide`s `mysql-async`. Resources that declare
`dependency 'mysql-async'` or include `@mysql-async/lib/MySQL.lua` need the
`stubs/mysql-async` stub deployed as `resources/[compat]/mysql-async` and ensured
after kora_sql (`ensure kora_sql` then `ensure mysql-async`). Never run the real
mysql-async alongside it. Resources that only call `exports['mysql-async']:mysql_*`
or the `MySQL` global need nothing extra. See `stubs/mysql-async/README.md`.

### oxmysql result conversion (`kora_sql_ox_typecast`)
On the oxmysql compatibility path only (`exports.oxmysql:*`, the oxmysql
`*_async` exports, and the `MySQL` global from `@oxmysql/lib/MySQL.lua`,
`@mysql-async/lib/MySQL.lua` or `@kora_sql/lib/MySQL.lua`), results go through a
port of oxmysql's `typeCast`, **on by default** like oxmysql:
`TINYINT(1)`/`BIT(1)` → boolean, `DATETIME`/`TIMESTAMP`/`DATE` → milliseconds since
epoch (`null` when empty), binary `BLOB`s → byte arrays, text `BLOB`s → strings,
`JSON` → its string (oxmysql's `jsonStrings`). Prepared (`execute`) statements only
convert dates and JSON, exactly as upstream. Set `set kora_sql_ox_typecast false` to get
mysql2's default shapes there instead. `Kora.sql.*` and `exports.kora_sql:*` are
never converted.

## Usage examples

### Query rows (modern API)
```lua
-- server, after:
--   shared_script '@kora_lib/init.lua'
--   server_script '@kora_sql/init.lua'  (server-only, never shared)
local rows, err = Kora.sql.query('SELECT * FROM players WHERE license = ?', { license })
if not rows then
    print('query failed:', err)
    return
end
```

### Scalar and single-row reads
```lua
local count = Kora.sql.scalar('SELECT COUNT(*) FROM players WHERE last_updated > ?', { cutoff })
local player = Kora.sql.single('SELECT * FROM players WHERE citizenid = ?', { citizenid })
```

### Insert and update
```lua
local insertId = Kora.sql.insert('INSERT INTO logs (player, message) VALUES (?, ?)', { citizenid, message })

local result = Kora.sql.execute('UPDATE players SET last_updated = NOW() WHERE citizenid = ?', { citizenid })
print(result.affectedRows, result.changedRows)
```

### The hot save path: enqueueMany (fire-and-forget)
```lua
-- Never yields -- hands N rows to the coalescing queue in ONE boundary
-- crossing. This is how kora_core batches every online player's save.
local rows = {}
for citizenid, moneyJson in pairs(pendingSaves) do
    rows[#rows + 1] = { pk = citizenid, cols = { money = moneyJson } }
end
Kora.sql.enqueueMany('players', 'citizenid', rows, { mode = 'assign', writeMode = 'upsert' })

-- force it to write now instead of waiting for the flush interval
Kora.sql.flush('players')
```

### Transaction (rolls back on any error)
```lua
local ok, err = Kora.sql.transaction({
    { sql = 'UPDATE players SET bank = bank - ? WHERE citizenid = ?', params = { amount, fromCid } },
    { sql = 'UPDATE players SET bank = bank + ? WHERE citizenid = ?', params = { amount, toCid } },
})
if not ok then
    print('transfer failed:', err)
end
```

### Migrating from oxmysql: same call signature, works unmodified
```lua
-- Existing oxmysql-era code. kora_sql registers the same __cfx_export_oxmysql_*
-- identity, so this needs zero changes (no placeholder required for exports).
local rows = exports.oxmysql:query('SELECT * FROM players WHERE license = ?', { license })

exports.oxmysql:insert('INSERT INTO logs (player, message) VALUES (?, ?)', { citizenid, message },
    function(insertId) print(insertId) end)

-- mysql-async's `MySQL` global works through its existing include unchanged;
-- @kora_sql/lib/MySQL.lua is also available as an explicit direct include:
local job = MySQL.query.await('SELECT job FROM players WHERE citizenid = ?', { citizenid })
MySQL.Async.execute('UPDATE players SET last_updated = NOW() WHERE citizenid = ?', { citizenid })
```

### Benchmark the coalescing win
```
/kora_sql bench 500
```
Runs an A/B on a scratch table: 500 individual `execute()` upserts (500 round
trips, 500 Lua→JS boundary crossings) versus one `enqueueMany` + `flush` of the
same 500 rows, printing wall-clock time, round trips, and boundary crossings
for each path.

## API reference

All calls are server-side. Fallible functions return `(value, errorString)` and
never throw across the Lua/JS boundary.

### `Kora.sql.*` (modern, requires `@kora_lib/init.lua` then `@kora_sql/init.lua`)
```lua
Kora.sql.ready(timeoutMs?)                      -- yields until the pool is up; true | false, errString
Kora.sql.query(sql, params) -> rows[] | nil, errString
Kora.sql.single(sql, params) -> row | nil
Kora.sql.scalar(sql, params) -> value | nil
Kora.sql.execute(sql, params) -> { affectedRows, insertId, changedRows }
Kora.sql.insert(sql, params) -> insertId
Kora.sql.update(sql, params) -> affectedRows
Kora.sql.batch(statements)                      -- { {sql=, params=}, ... }; one pinned connection, NO transaction
Kora.sql.transaction(statements)                -- same, wrapped in BEGIN/COMMIT, rolls back on error
Kora.sql.transaction(sql, paramSets)            -- oxmysql's "one query, many param sets" form
Kora.sql.upsert(table, conflictKey, rows, opts) -- immediate awaited batched upsert (enqueueMany + flush in one call)
Kora.sql.ensureTables(specs)                   -- create missing tables, add missing columns/indexes/FKs (see docs.md)
Kora.sql.flush(table?) -> boolean, errString    -- yields until the table (or everything) has drained
Kora.sql.stats()                                -- query + queue counters (same data as `/kora_sql stats`)
Kora.sql.NULL                                   -- sentinel for an explicit SQL NULL bind value
```

Fire-and-forget — **never yield**, hand rows straight to the coalescing queue:
```lua
Kora.sql.enqueue(table, conflictKey, row, opts)       -- one { pk=, cols= } row
Kora.sql.enqueueMany(table, conflictKey, rows, opts)  -- { {pk=, cols=}, ... }; ONE boundary crossing for N rows
```
`opts` = `{ mode = 'assign'|'accumulate', writeMode = 'upsert'|'update', priority = 'normal'|'immediate' }`.
`assign` (default) is last-write-wins; `accumulate` does `col = col + value` for
counters (bucket padding is disabled in this mode). `writeMode = 'update'` only
touches rows already known to exist, useful for partial writes to a table with
required columns absent from `cols`.

Non-yielding callback variants exist for every yielding call above —
`Kora.sql.queryAsync(sql, params, cb)`, `singleAsync`, `scalarAsync`,
`executeAsync`, `insertAsync`, `updateAsync` — with `cb(result, errString)`.

### oxmysql compat
The full current export surface works through `exports.oxmysql`: `query`,
deprecated `execute`/`fetch`, `single`, `scalar`, `insert`, `update`, `prepare`,
`transaction`, `rawExecute`, `store`, `isReady`, `awaitConnection`, and
experimental `startTransaction`, together with every `_async` promise export
and `*Sync` alias. Callback-as-second-argument, named `@`/`:` binds, all
transaction input shapes, rollback-to-`false`, and the
`oxmysql:transaction-error` event are retained. `rawExecute` exposes raw
rows/result headers without mysql2 field metadata, and oxmysql `store` returns
the SQL text unchanged. Multi-statement strings are refused unless
`kora_sql_allow_multiple_statements true` is set. Slow queries are
attributed to the original calling resource, not to kora_sql.

### mysql-async compat
`shared_script '@oxmysql/lib/MySQL.lua'` works unchanged through kora_sql's
provided identity; `@kora_sql/lib/MySQL.lua` is the direct equivalent. Both build
the complete current `MySQL` global: callable dual methods and `.await`,
lazy `MySQL.Async.*`/`MySQL.Sync.*`, stored-query handles,
`MySQL.ready`/`.ready.await`, and `MySQL.startTransaction`.

### ghmattimysql compat
`exports.ghmattimysql:*` is registered the same way as the oxmysql bridge, for
resources still written against that driver.

### Console commands (`command.kora_sql` ace, or the server console)
```
/kora_sql ping      -- SELECT VERSION() + round-trip time
/kora_sql stats     -- query aggregates + queue coalescing counters
/kora_sql slow [n]  -- the n slowest queries, with the resource that issued each
/kora_sql queue     -- pending queue depth / retries / dead-letters
/kora_sql flush     -- force-drain the write queue
/kora_sql bench [n] -- A/B: n individual writes vs one enqueueMany + flush
```

### Behaviour notes
- **Multi-statement queries are refused** by default (one statement per call);
  `kora_sql_allow_multiple_statements true` lifts this and accepts the SQL-injection
  amplification risk.
- **`store()` handles do not survive a restart** — in-memory only.
- **DECIMAL/BIGINT columns come back as numbers**, matching oxmysql, not strings.
- **Durability**: the coalescing queue flushes on an interval and on resource
  stop. A hard crash can lose up to one flush interval of writes; clean paths
  (resource stop, explicit `flush`) always drain first.

## Config highlights (`config.lua`)

The Node pool reads everything it needs at boot from **convars** (connection
string, pool/cache sizes, flush timing — Lua's `Config` is invisible to the
Node host). `config.lua` only holds Lua-side behaviour:

`Config.compat.oxmysql` / `.mysqlAsync` / `.ghmattimysql` (each default `true`,
toggle a compat surface off entirely), `Config.compat.installMySQLGlobal`
(create the `MySQL` global when `@kora_sql/lib/MySQL.lua` is included),
`Config.compat.warnOnSync` (default `true`, print once per resource on first
blocking `*Sync` use), `Config.sql.awaitTimeout` (30s, how long `Kora.sql.*`
waits before rejecting), `Config.sql.readyTimeout` (60s, how long
`Kora.sql.ready()` polls before giving up).

## Related resources

Part of the [qbcore2](https://github.com/qbcore2) resource set:

- [kora_lib](https://qbcore2.github.io/kora_lib/) — shared helper library
- [kora_core](https://qbcore2.github.io/kora_core/) — framework core
- [kora_inventory](https://qbcore2.github.io/kora_inventory/) — headless inventory
- [kora_target](https://qbcore2.github.io/kora_target/) — targeting/interaction
- [kora_clothing](https://qbcore2.github.io/kora_clothing/) — clothing/wardrobe
- [full resource list ↗](https://github.com/orgs/qbcore2/repositories)
