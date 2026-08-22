# qbsql API reference

Two ways to use qbsql: the modern `QB.sql.*` API (recommended for new code), and
the drop-in `oxmysql` / `mysql-async` / `ghmattimysql` compat surfaces (existing
code works unmodified).

## Setup

1. `npm install` (or `pnpm install`) inside the `qbsql` folder.
2. In `server.cfg`, before any resource that queries:
   ```
   set mysql_connection_string "mysql://user:pass@localhost/qbcore?charset=utf8mb4"
   ensure qbsql
   ```
3. Optional convars (defaults shown):
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

## `QB.sql.*` (modern)

Add to your resource, in order:
```lua
shared_script '@qblib/init.lua'
shared_script '@qbsql/init.lua'
```

### QB.sql.ready(timeoutMs?)
Yields until the pool is up. Returns `true`, or `false, errString` on timeout.

### QB.sql.query(sql, params) -> rows[] | nil, errString
Yields. Returns an array of row tables.
```lua
local rows = QB.sql.query('SELECT * FROM players WHERE license = ?', { license })
```

### QB.sql.single(sql, params) -> row | nil
First row only (or `nil`).

### QB.sql.scalar(sql, params) -> value | nil
First column of the first row.

### QB.sql.execute(sql, params) -> { affectedRows, insertId, changedRows }
For writes.

### QB.sql.insert(sql, params) -> insertId
### QB.sql.update(sql, params) -> affectedRows

### QB.sql.batch(statements) -> results[]
`statements` = `{ {sql=, params=}, ... }`. One pinned connection, NO transaction.

### QB.sql.transaction(statements) -> boolean, errString
Same, wrapped in BEGIN/COMMIT; rolls back on any error. Also accepts the oxmysql
"one query, many param sets" form: `QB.sql.transaction(sql, { {p1}, {p2}, ... })`.

### QB.sql.enqueue(table, conflictKey, row, opts) — FIRE AND FORGET
Never yields. Hands one `{ pk, cols }` row to the coalescing queue.
```lua
QB.sql.enqueue('players', 'citizenid', { pk = cid, cols = { money = json } })
```

### QB.sql.enqueueMany(table, conflictKey, rows, opts) — FIRE AND FORGET
Never yields. `rows` = `{ {pk=, cols={}}, ... }`. **One boundary crossing for N
rows** — this is the hot save path.

`opts` = `{ mode = 'assign'|'accumulate', priority = 'normal'|'immediate', onError = 'retry'|'drop' }`.
- `assign` (default): `col = new value` (last write wins).
- `accumulate`: `col = col + value` (counters). Bucket padding is disabled here.
- `priority = 'immediate'`: flush this table now rather than on the interval.

### QB.sql.flush(table?) -> boolean, errString
Yields until the named table (or everything) has drained.

### QB.sql.upsert(table, conflictKey, rows, opts) -> affectedRows
Immediate awaited batched upsert (enqueueMany + flush in one call).

### QB.sql.migrate(resource, migrations) -> boolean, errString
`migrations` = `{ {version=, name=, sql=, checksum=}, ... }`. A checksum mismatch
on an already-applied version aborts. See qbcore's `sql/` for the pattern.

### Callback variants
`QB.sql.queryAsync(sql, params, cb)` and friends — `cb(result, errString)`, no
coroutine required.

## oxmysql compat

`exports.oxmysql:execute/query/scalar/single/insert/update/transaction/store/
rawExecute/isReady` and every `*Sync` variant work unmodified. Slow queries are
attributed to the calling resource, not to qbsql.

## mysql-async compat

`shared_script '@qbsql/lib/MySQL.lua'` (or drop the `stubs/mysql-async` folder in
for a zero-touch include) gives the `MySQL` global: `MySQL.ready`,
`MySQL.Async.*`, `MySQL.Sync.*`, and `MySQL.query.await` / `.scalar.await` /
`.single.await` / `.insert.await` / `.update.await` / `.transaction.await`.

## Console commands (`command.qbsql` ace, or the server console)
- `/qbsql ping` — SELECT VERSION() + round-trip time.
- `/qbsql stats` — query aggregates + queue coalescing counters.
- `/qbsql slow [n]` — the n slowest queries, with the resource that issued each.
- `/qbsql queue` — pending queue depth / retries / dead-letters.
- `/qbsql flush` — force-drain the write queue.
- `/qbsql bench [n]` — A/B: n individual writes vs one `enqueueMany` + flush,
  printing wall-clock, round trips, and boundary crossings for each.

## Behaviour notes & caveats
- **Multi-statement queries are refused** by default (one statement per call).
  Set `qbsql_allow_multiple_statements true` to allow them and accept the
  SQL-injection amplification risk.
- **`store()` handles do not survive a restart** (in-memory only).
- **DECIMAL/BIGINT**: returned as numbers (`decimalNumbers`, `supportBigNumbers`),
  matching oxmysql — not strings. A pre-existing DECIMAL column on a migrated
  server is worth checking.
- **Durability**: the coalescing queue flushes on an interval and on resource
  stop. A hard crash can lose up to one flush interval of writes. Clean paths
  (resource stop, explicit flush) always drain first.
