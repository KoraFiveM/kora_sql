---
layout: default
title: qbsql
---

A Node + mysql2 database driver for FiveM, built to replace oxmysql. **Write
coalescing** merges per-row saves by primary key and batches them into a single
`INSERT ... ON DUPLICATE KEY UPDATE` per flush; **split read/write pools** keep
save-flush latency independent of read load; a **prepared-statement LRU**
remembers which SQL text can't be prepared so a failed prepare is paid at most
once. Ships full drop-in compatibility with `oxmysql`, `mysql-async`, and
`ghmattimysql` — existing resources that query the database keep working
unmodified, no code changes required.

Two ways to use it: the modern `QB.sql.*` API for new code, or the
`exports.oxmysql:*` / `MySQL.*` / `exports.ghmattimysql:*` compat surfaces for
everything already written against those drivers.

## Requirements

qbsql is foundational — it has no dependency on qblib or qbcore, and everything
else in the [qbcore2](https://github.com/qbcore2) set depends on it. It needs:

- A running MySQL/MariaDB server.
- `set mysql_connection_string "..."` in `server.cfg` — deliberately the same
  convar name oxmysql uses, so an existing server migrates untouched.
- `npm install` (or `pnpm install`) run once inside the `qbsql` folder. mysql2
  is pure JS, resolved from `node_modules/` (gitignored) — there is no bundler
  or build step beyond that install.

## Installation

`qbsql` must be `ensure`d before qblib/qbcore (and before any other resource
that queries the database) so the pool exists when they boot:

```
set mysql_connection_string "mysql://user:pass@localhost/qbcore?charset=utf8mb4"
ensure qbsql
ensure qblib
ensure qbcore
```

Optional convars (defaults shown):
```
set qbsql_read_pool_size 16
set qbsql_write_pool_size 8
set qbsql_statement_cache 256      # cache * (read+write pools) must be <= 8000
set qbsql_flush_interval 250       # ms between coalescing flushes
set qbsql_max_pending_rows 500     # high-water mark that forces a flush
set qbsql_slow_threshold 150       # ms; queries slower than this hit the slow log
set qbsql_allow_multiple_statements false
set qbsql_debug false
```

For a zero-touch drop-in replacing an actual `oxmysql`/`mysql-async` resource,
copy the two-file stubs from `stubs/oxmysql/` or `stubs/mysql-async/` into
`resources/` and `ensure` them after qbsql — they forward `@oxmysql/lib/MySQL.lua`
-style file includes into qbsql's own `lib/MySQL.lua`, which FiveM's file
resolution can't do across resources on its own.

## Usage examples

### Query rows (modern API)
```lua
-- server, after:
--   shared_script '@qblib/init.lua'
--   shared_script '@qbsql/init.lua'
local rows, err = QB.sql.query('SELECT * FROM players WHERE license = ?', { license })
if not rows then
    print('query failed:', err)
    return
end
```

### Scalar and single-row reads
```lua
local count = QB.sql.scalar('SELECT COUNT(*) FROM players WHERE last_updated > ?', { cutoff })
local player = QB.sql.single('SELECT * FROM players WHERE citizenid = ?', { citizenid })
```

### Insert and update
```lua
local insertId = QB.sql.insert('INSERT INTO logs (player, message) VALUES (?, ?)', { citizenid, message })

local result = QB.sql.execute('UPDATE players SET last_updated = NOW() WHERE citizenid = ?', { citizenid })
print(result.affectedRows, result.changedRows)
```

### The hot save path: enqueueMany (fire-and-forget)
```lua
-- Never yields -- hands N rows to the coalescing queue in ONE boundary
-- crossing. This is how qbcore batches every online player's save.
local rows = {}
for citizenid, moneyJson in pairs(pendingSaves) do
    rows[#rows + 1] = { pk = citizenid, cols = { money = moneyJson } }
end
QB.sql.enqueueMany('players', 'citizenid', rows, { mode = 'assign', writeMode = 'upsert' })

-- force it to write now instead of waiting for the flush interval
QB.sql.flush('players')
```

### Transaction (rolls back on any error)
```lua
local ok, err = QB.sql.transaction({
    { sql = 'UPDATE players SET bank = bank - ? WHERE citizenid = ?', params = { amount, fromCid } },
    { sql = 'UPDATE players SET bank = bank + ? WHERE citizenid = ?', params = { amount, toCid } },
})
if not ok then
    print('transfer failed:', err)
end
```

### Migrating from oxmysql: same call signature, works unmodified
```lua
-- Existing oxmysql-era code. qbsql `provide`s oxmysql and registers the same
-- __cfx_export_oxmysql_* identity, so this needs zero changes.
local rows = exports.oxmysql:query('SELECT * FROM players WHERE license = ?', { license })

exports.oxmysql:insert('INSERT INTO logs (player, message) VALUES (?, ?)', { citizenid, message },
    function(insertId) print(insertId) end)

-- mysql-async's `MySQL` global works the same way, via
-- shared_script '@qbsql/lib/MySQL.lua' (or the stubs/mysql-async drop-in):
local job = MySQL.query.await('SELECT job FROM players WHERE citizenid = ?', { citizenid })
MySQL.Async.execute('UPDATE players SET last_updated = NOW() WHERE citizenid = ?', { citizenid })
```

### Benchmark the coalescing win
```
/qbsql bench 500
```
Runs an A/B on a scratch table: 500 individual `execute()` upserts (500 round
trips, 500 Lua→JS boundary crossings) versus one `enqueueMany` + `flush` of the
same 500 rows, printing wall-clock time, round trips, and boundary crossings
for each path.

## API reference

All calls are server-side. Fallible functions return `(value, errorString)` and
never throw across the Lua/JS boundary.

### `QB.sql.*` (modern, requires `@qblib/init.lua` then `@qbsql/init.lua`)
```lua
QB.sql.ready(timeoutMs?)                      -- yields until the pool is up; true | false, errString
QB.sql.query(sql, params) -> rows[] | nil, errString
QB.sql.single(sql, params) -> row | nil
QB.sql.scalar(sql, params) -> value | nil
QB.sql.execute(sql, params) -> { affectedRows, insertId, changedRows }
QB.sql.insert(sql, params) -> insertId
QB.sql.update(sql, params) -> affectedRows
QB.sql.batch(statements)                      -- { {sql=, params=}, ... }; one pinned connection, NO transaction
QB.sql.transaction(statements)                -- same, wrapped in BEGIN/COMMIT, rolls back on error
QB.sql.transaction(sql, paramSets)            -- oxmysql's "one query, many param sets" form
QB.sql.upsert(table, conflictKey, rows, opts) -- immediate awaited batched upsert (enqueueMany + flush in one call)
QB.sql.migrate(resource, migrations)          -- { {version=, name=, sql=, checksum=}, ... }
QB.sql.flush(table?) -> boolean, errString    -- yields until the table (or everything) has drained
QB.sql.stats()                                -- query + queue counters (same data as `/qbsql stats`)
QB.sql.NULL                                   -- sentinel for an explicit SQL NULL bind value
```

Fire-and-forget — **never yield**, hand rows straight to the coalescing queue:
```lua
QB.sql.enqueue(table, conflictKey, row, opts)       -- one { pk=, cols= } row
QB.sql.enqueueMany(table, conflictKey, rows, opts)  -- { {pk=, cols=}, ... }; ONE boundary crossing for N rows
```
`opts` = `{ mode = 'assign'|'accumulate', writeMode = 'upsert'|'update', priority = 'normal'|'immediate' }`.
`assign` (default) is last-write-wins; `accumulate` does `col = col + value` for
counters (bucket padding is disabled in this mode). `writeMode = 'update'` only
touches rows already known to exist, useful for partial writes to a table with
required columns absent from `cols`.

Non-yielding callback variants exist for every yielding call above —
`QB.sql.queryAsync(sql, params, cb)`, `singleAsync`, `scalarAsync`,
`executeAsync`, `insertAsync`, `updateAsync` — with `cb(result, errString)`.

### oxmysql compat
`exports.oxmysql:execute/query/scalar/single/insert/update/transaction/store/
rawExecute/isReady`, plus every `*Sync` variant, work unmodified. Multi-statement
strings are refused unless `qbsql_allow_multiple_statements true` is set. Slow
queries are attributed to the calling resource, not to qbsql.

### mysql-async compat
`shared_script '@qbsql/lib/MySQL.lua'` (or the `stubs/mysql-async` drop-in)
builds the `MySQL` global: `MySQL.ready`, `MySQL.Async.*`, `MySQL.Sync.*`, and
`MySQL.query.await` / `.scalar.await` / `.single.await` / `.insert.await` /
`.update.await` / `.transaction.await`.

### ghmattimysql compat
`exports.ghmattimysql:*` is registered the same way as the oxmysql bridge, for
resources still written against that driver.

### Console commands (`command.qbsql` ace, or the server console)
```
/qbsql ping      -- SELECT VERSION() + round-trip time
/qbsql stats     -- query aggregates + queue coalescing counters
/qbsql slow [n]  -- the n slowest queries, with the resource that issued each
/qbsql queue     -- pending queue depth / retries / dead-letters
/qbsql flush     -- force-drain the write queue
/qbsql bench [n] -- A/B: n individual writes vs one enqueueMany + flush
```

### Behaviour notes
- **Multi-statement queries are refused** by default (one statement per call);
  `qbsql_allow_multiple_statements true` lifts this and accepts the SQL-injection
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
(create the `MySQL` global when `@qbsql/lib/MySQL.lua` is included),
`Config.compat.warnOnSync` (default `true`, print once per resource on first
blocking `*Sync` use), `Config.sql.awaitTimeout` (30s, how long `QB.sql.*`
waits before rejecting), `Config.sql.readyTimeout` (60s, how long
`QB.sql.ready()` polls before giving up).

## Related resources

Part of the [qbcore2](https://github.com/qbcore2) resource set:

- [qblib](https://qbcore2.github.io/qblib/) — shared helper library
- [qbcore](https://qbcore2.github.io/qbcore/) — framework core
- [qbinventory](https://qbcore2.github.io/qbinventory/) — headless inventory
- [qbtarget](https://qbcore2.github.io/qbtarget/) — targeting/interaction
- [qbclothing](https://qbcore2.github.io/qbclothing/) — clothing/wardrobe
- [full resource list ↗](https://github.com/orgs/qbcore2/repositories)
