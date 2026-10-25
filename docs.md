# qbsql API reference

Two ways to use qbsql: the modern `QB.sql.*` API (recommended for new code), and
the drop-in `oxmysql` / `mysql-async` / `ghmattimysql` compat surfaces (existing
code works unmodified).

## Setup

1. Use the packaged qbsql resource, which includes `dist/build.js` with mysql2
   bundled. No runtime `node_modules` or FiveM yarn builder is required.
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
   set qbsql_connect_retry_interval 2000 # ms between startup connection retries
   set qbsql_flush_interval 250       # ms between coalescing flushes
   set qbsql_max_pending_rows 500     # high-water mark that forces a flush
   set qbsql_slow_threshold 150       # ms; queries slower than this hit the slow log
   set qbsql_allow_multiple_statements false
   set qbsql_debug false
   ```

Source contributors run `yarn install` and `yarn build` after changing the JS
driver or its dependencies. Those development dependencies are not needed by
the running FiveM resource.

If MySQL is still starting when FXServer loads qbsql, qbsql keeps retrying
network connection failures and holds database exports until it is ready. A
server or resource restart is not required. Authentication, database-name, and
other non-network configuration errors still fail immediately.

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

### QB.sql.transactionChecked(statements, operation?) -> outcome, errString
Runs on one connection and checks each statement before COMMIT. A statement may
set `expectedRows` (write affected rows or SELECT row count) and `failureCode`.
A mismatch rolls back every statement. Success is `{success=true, results={...}}`;
confirmed rollback is `{success=false, code='conflict'|'duplicate'|'unavailable'|failureCode}`.
A lost COMMIT reply or failed rollback returns `code='indeterminate'`; reconcile
using a durable receipt rather than compensating or assuming failure. Requires
transactional tables. DDL and external side effects cannot be rolled back.

Optional `operation={key=..., fingerprint=..., citizenids={...}}` joins an existing
in-flight worker with identical terms. It is an in-memory restart bridge for a
consumer resource, not a durable idempotency store. The consumer must write its
unique operation receipt in the same transaction as its mutations.

### QB.sql.awaitCheckedOperation(key, fingerprint?) -> state, errString
Joins an existing checked worker without submitting SQL. Returns `{active=false}`
when none exists, otherwise `{active=true, result=outcome}` after it settles.
Mismatched terms return an indeterminate result. After a consumer restart, wait
here before reading a pending receipt or releasing its persistent player fence.
`QB.sql.awaitCheckedOperations(prefix)` waits for all currently active checked
workers matching a key prefix and returns `{settled=count}`. Use it once before
loading a restarted consumer's caches; it never executes replacement SQL.
The server export `hasActivePlayerOperation(citizenid)` is a synchronous lifecycle
guard; it reports active checked workers declaring that character ID.

### QB.sql.enqueue(table, conflictKey, row, opts) — FIRE AND FORGET
Never yields. Hands one `{ pk, cols }` row to the coalescing queue.
```lua
QB.sql.enqueue('players', 'citizenid', { pk = cid, cols = { money = json } })
```

### QB.sql.enqueueMany(table, conflictKey, rows, opts) — FIRE AND FORGET
Never yields. `rows` = `{ {pk=, cols={}}, ... }`. **One boundary crossing for N
rows** — this is the hot save path.

`opts` = `{ mode = 'assign'|'accumulate', writeMode = 'upsert'|'update', priority = 'normal'|'immediate' }`.
- `assign` (default): `col = new value` (last write wins).
- `accumulate`: `col = col + value` (counters). Bucket padding is disabled here.
- `writeMode = 'upsert'` (default): insert missing rows, then update a conflict.
- `writeMode = 'update'`: only update rows already known to exist. Use this for
  partial writes to a table with required columns that are not in `cols`; it
  avoids MariaDB validating those omitted columns as part of an INSERT.
- `priority = 'immediate'`: flush this table now rather than on the interval.

### QB.sql.flush(table?) -> boolean, errString
Yields until the named table (or everything) has drained.

### QB.sql.upsert(table, conflictKey, rows, opts) -> affectedRows
Immediate awaited batched upsert (enqueueMany + flush in one call).

### QB.sql.migrate(resource, migrations) -> boolean, errString
`migrations` = `{ {version=, name=, sql=, checksum=}, ... }`. A checksum mismatch
on an already-applied version aborts. See qbcore's `sql/` for the pattern.

### QB.sql.migrateFiles(resource, migrations, checksumFn?) -> boolean, errString
Loads `{version=, name=, file=}` entries with `LoadResourceFile`, calculates
their checksums, and forwards them to `migrate`. `checksumFn` defaults to
`QB.util.fnv1a`; pass the resource's historical checksum function when an
existing migration used another format.

### Callback variants
`QB.sql.queryAsync(sql, params, cb)` and friends — `cb(result, errString)`, no
coroutine required.

## oxmysql compat

The current oxmysql surface is available unmodified through the provided
`oxmysql` identity: `query`, deprecated `execute`/`fetch`, `single`, `scalar`,
`insert`, `update`, `prepare`, `transaction`, `rawExecute`, `store`, `isReady`,
`awaitConnection`, and experimental `startTransaction`. Every `_async` promise
export and every `*Sync` alias is registered too. Callback-as-second-argument,
`@name`/`:name` binds, all supported transaction query shapes, rollback-to-
`false`, and `oxmysql:transaction-error` are preserved. `execute`/`fetch` keep
oxmysql's query-result semantics; `rawExecute` returns raw rows/result headers
without mysql2 field metadata, and the oxmysql `store` export returns its SQL
text unchanged exactly like upstream. Slow queries are attributed to the
original calling resource, not to qbsql.

## mysql-async compat

`shared_script '@oxmysql/lib/MySQL.lua'` works unchanged through qbsql's
provided identity; `@qbsql/lib/MySQL.lua` is the direct equivalent. Both install
the full current `MySQL` global: callable top-level methods with
`.await`, lazy `MySQL.Async.*`/`MySQL.Sync.*` aliases, stored-query handles,
`MySQL.ready`/`.ready.await`, and `MySQL.startTransaction`.

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

### Native police trash cleanup

With `qbinventory` running, the pinned `qb-policejob` statement
`DELETE FROM inventories WHERE identifier = 'policetrash'` delegates to the
provider's locked stash deletion, including its cache and pending writes. The
exact single-statement form also accepts positional `?` and named `@name` /
`:name` binds, optional identifier backticks and a trailing semicolon. Other
statements pass through unchanged; this is not a general legacy table mapping.
Ad-hoc query/update/execute/prepare/rawExecute calls preserve their normal
result shapes and report provider errors. Transaction/batch SQL is unchanged.
Without the native provider running, the original SQL executes normally.
The provider bounds pre-write readiness/lock waits; submitted durable deletion
waits for its actual result instead of reporting a timeout before a late commit.
A provider shutdown rejects pending callers.

### Native housing read projection

When qbhousing is running, reviewed ad-hoc SELECTs against houselocations and
player_houses route to its current native state. The original qbhousing caller
bypasses the bridge only for its own source import. Other unsupported ad-hoc
reads/writes fail explicitly instead of using stale archive tables. Standalone
stock housing is unchanged when the native provider has never been selected.
Transaction/batch SQL is not rewritten. See qbhousing/docs/LEGACY_SQL.md for the
exact read forms, physical mapping limits, and original-caller restriction.
