---
title: "Write queue"
sidebar_position: 4
---


# Write queue

A coalescing write queue for data that changes often, such as player saves and counters. You hand it rows; it merges rows with the same primary key, waits briefly, and writes each group as one batched statement. Many saves become a handful of round trips.

Namespace: `Kora.sql` · Source: `init.lua, server/js/queue.js, server/js/batch.js, server/js/exports.js`

## How it works

Rows are held per table in a map keyed by primary key. Enqueueing the same key again merges the columns (last write wins in `assign` mode, summed in `accumulate` mode), so a row is written once per flush even if it changed fifty times. A timer started by the first enqueue fires after `kora_sql_flush_interval` ms (default 250); reaching `kora_sql_max_pending_rows` (default 500) pending rows flushes at once. At flush time rows are grouped by their set of columns and each group becomes one `INSERT ... ON DUPLICATE KEY UPDATE` (or one `UPDATE ... CASE` for `writeMode = 'update'`), split into chunks of at most `kora_sql_max_rows_per_statement` rows and `kora_sql_max_placeholders` bound values. Writes to one table are serialised; different tables flush in parallel.

## Use the queue for a periodic save

1. **Make sure the key is unique in the table** — The `conflictKey` columns must be the table’s PRIMARY KEY or a UNIQUE key. Otherwise the upsert cannot detect the existing row and will insert duplicates.
2. **Enqueue changed rows** — Call `enqueue` when one player changes, or `enqueueMany` for a periodic sweep. Neither yields or returns.
3. **Let it flush, or flush explicitly** — The queue writes within about a quarter of a second. Call `flush` when you must be sure it was written, for example before a player leaves or a resource stops.
4. **Watch the dead-letter table** — If a write keeps failing, the rows are saved into `kora_sql_deadletter`. Check it with `SELECT * FROM kora_sql_deadletter` and `kora_sql stats`.

## Terms used on this page

| Term | Meaning |
| --- | --- |
| Coalescing | Merging several pending changes to the same row into one write. |
| Conflict key | The column or columns that identify a row (primary or unique key). Pending rows are merged by it. |
| Boundary crossing | One call from Lua into the JavaScript driver. `enqueueMany` crosses once for any number of rows. |
| Dead letter | A row that could not be written after the retries. It is stored in `kora_sql_deadletter` so it can be recovered by hand. |

## Queue options

The `opts` table accepted by `enqueue`, `enqueueMany` and `upsert`. All fields are optional. A `?` after a name means the option is optional.

| Option | Type | Description |
| --- | --- | --- |
| `mode??` | 'assign' \| 'accumulate' | How overlapping and conflicting values combine. `'assign'` (default): the column becomes the new value, last write wins. `'accumulate'`: the new value is added to the stored value (`col = col + value`), for counters. Only numbers can accumulate, and padding is never used in this mode. |
| `writeMode??` | 'upsert' \| 'update' | `'upsert'` (default): `INSERT ... ON DUPLICATE KEY UPDATE`, which inserts missing rows. `'update'`: a batched `UPDATE ... CASE` that only touches rows that already exist and never inserts. Use `'update'` for partial writes to tables that have required columns you are not supplying. Any other value throws `unsupported writeMode`. |
| `priority??` | 'normal' \| 'immediate' | `'immediate'` flushes this table right away instead of waiting for the flush interval. `Kora.sql.upsert` always uses `'normal'` internally. Anything else behaves as normal. |

## Retries and dead letters

A failed write is retried up to five times with a growing pause (50, 100, 200, 400 and 800 ms), logging a warning each time. While waiting, the failed rows are put back into the pending set, so a newer value for the same key supersedes the stale one instead of being overwritten by it. After the last retry the rows are inserted into `kora_sql_deadletter` and an error is logged; `flush` then fails with `write to <table> failed after 5 retries; N row(s) were dead-lettered`. Other chunks of the same flush are unaffected.

## The dead-letter table

Created automatically at boot. Columns: `id` (bigint unsigned, auto-increment), `table_name` (varchar 64), `pk` (varchar 191; a composite key is a JSON array of strings, and a longer key keeps a prefix plus `~sha:` and 40 hex characters), `cols_json` (the columns as JSON), `error` (up to 500 characters, nullable), `failed_at` (timestamp, default now). Index `idx_deadletter_table` on `table_name`. If even this insert fails, `flush` reports it and the failure is logged.

## Bucket padding

To keep the SQL text identical between flushes (and so reuse prepared statements) row counts are rounded up to 1, 2, 4, 8, 16, 32, 64, 128 or 200 by repeating a row already in the batch. That repeat is harmless in `assign` mode. It is never used in `accumulate` mode, where a repeated row would count twice. Disable it with `set kora_sql_pad_to_buckets false`.

## Durability

Pending writes live in memory until the flush. A resource stop or restart of kora_sql drains the queue first. A hard crash or kill of the server can lose up to one flush interval of writes (250 ms by default). For data that must not be lost, use `Kora.sql.upsert`, `flush`, or a transaction instead.

## Value rules

In a queued row `nil` values and `Kora.sql.NULL` are written as `NULL`. Column names come from the keys of `cols` and are quoted, so keep them developer-owned. `accumulate` mode adds values with `+`: every value must be a number. Two rows enqueued for the same key with different column sets are merged into one row with the union of the columns before writing.

## writeMode update

With `writeMode = 'update'` a row that does not exist is silently not created: the UPDATE simply matches nothing, and the queue does not report it. Use `upsert` when the row might be missing and every required column is supplied.

## Functions

Two fire-and-forget calls and two that wait. Table names and keys are developer-owned identifiers: values are bound, identifiers are only quoted.

### `Kora.sql.enqueue(table, conflictKey, row, opts?)`

Hands one row to the write queue and returns immediately. The row is merged with any pending row that has the same primary key and written in the next flush. This is the fire-and-forget save path.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `table` | string | Table name. Must be a plain identifier (`A-Za-z0-9_`, 1 to 64 characters) and is quoted with backticks; an invalid name is refused. Never pass a name from a player. |
| `conflictKey` | string \| string[] | The primary or unique key column, or a list of columns for a composite key. Must match a PRIMARY or UNIQUE key in the table for upserts to resolve. |
| `row` | table | Required `{ pk = value \| value[], cols = { column = value, ... } }`. `pk` is the key value (a list in the same order as a composite `conflictKey`). `cols` holds the other columns to write. |
| `opts?` | table | Queue options: `mode`, `writeMode`, `priority` (see Queue options). |

**Returns**

- **No value. Nothing is yielded or returned: failures are logged and retried by the queue, never reported to the caller.**

**Example**

```lua
-- Save a player's money and position whenever they change; many calls within
-- 250 ms collapse into one database write per column set.
Kora.sql.enqueue('players', 'citizenid', {
    pk = cid,
    cols = { money = json.encode(moneyTable), position = json.encode(coords) },
})

-- A counter: every call adds to the stored value.
Kora.sql.enqueue('stats_daily', { 'day', 'resource' }, {
    pk = { today, 'kora_jobs' },
    cols = { payouts = 1 },
}, { mode = 'accumulate' })
```

**Representative console output**

```text
Before the driver is ready the write is held until it is. A table’s options (conflictKey, mode, writeMode) are locked while rows are pending or a write is in flight: enqueueing with different options then throws `incompatible queue options for table ...`.
```

### `Kora.sql.enqueueMany(table, conflictKey, rows, opts?)`

Same as `enqueue` for a list of rows, using one call into the driver instead of one per row. Use it for periodic saves of many players.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `table` | string | Table name. |
| `conflictKey` | string \| string[] | Key column(s), as in `enqueue`. |
| `rows` | table[] | List of `{ pk, cols }` rows. |
| `opts?` | table | Queue options, applied to every row. |

**Returns**

- **No value. Never yields.**

**Example**

```lua
local rows = {}
for src, data in pairs(onlinePlayers) do
    rows[#rows + 1] = { pk = data.citizenid, cols = { money = json.encode(data.money), metadata = json.encode(data.metadata) } }
end
Kora.sql.enqueueMany('players', 'citizenid', rows, { mode = 'assign' })
```

**Representative console output**

```text
Counted once as a boundary crossing in `stats().queue.boundaryCrossings` no matter how many rows it carries.
```

### `Kora.sql.upsert(table, conflictKey, rows, opts?)`

Immediate, awaited version of `enqueueMany`: it queues the rows, flushes the table, and yields until the write finished. Use it when the caller must know the data is stored.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `table` | string | Table name. |
| `conflictKey` | string \| string[] | Key column(s). |
| `rows` | table[] | List of `{ pk, cols }` rows. |
| `opts?` | table | Queue options. `priority` is forced to `normal`. |

**Returns**

- **count** — the number of rows you passed (not MySQL’s affected-row count).
- **err** — `nil` on success, otherwise the message (for example after rows were dead-lettered).

**Example**

```lua
local count, err = Kora.sql.upsert('my_settings', 'name', {
    { pk = 'motd', cols = { value = 'Welcome' } },
    { pk = 'max_slots', cols = { value = '64' } },
}, { mode = 'assign' })
if err then return print('settings not saved:', err) end
```

**Representative console output**

```text
It flushes the whole table, so rows other callers enqueued for the same table in the meantime are written in the same flush.
```

### `Kora.sql.flush(table?)`

Yields until every pending and in-flight write for one table, or for all tables, has been written. Use it before shutting down your own logic or before reading data you just enqueued.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `table?` | string | Table to drain. Omit to drain every table. |

**Returns**

- **ok** — `true` when everything covered by the call was written.
- **err** — `false, message` when a write failed permanently (rows dead-lettered) or the driver was unavailable.

**Example**

```lua
Kora.sql.enqueue('players', 'citizenid', { pk = cid, cols = { money = moneyJson } })
local ok, err = Kora.sql.flush('players')
if not ok then print('save failed:', err) end
```

**Representative console output**

```text
Later enqueues do not extend the wait: a flush covers the writes pending at the time of the call.
```

## Additional queue options

| Option | Type | Description |
| --- | --- | --- |
| `allowedColumns` | string[] | Refuses any column not listed. Use it when `cols` comes from client data. |

## Validation

- The table, conflict-key columns and every `cols` key must be plain identifiers (`A-Za-z0-9_`, 1 to 64 characters). `players.money` is refused.
- `cols` must be non-empty and must not contain a conflict-key column.
- Each primary-key value must be a string or finite number. `7` and `'7'` are the same row and merge.
- An invalid row in `enqueue` or `enqueueMany` is dropped and logged once per calling resource and reason; valid rows in the same call are still queued.
- `upsert` is all-or-nothing: invalid input returns `nil, errString`.
- Rows are written in primary-key order so concurrent flushes lock rows in a consistent order. On first use of a table the conflict key is checked against its PRIMARY and UNIQUE indexes (`kora_sql_verify_conflict_keys`); a warning is logged if none matches, because upserts would insert duplicates.

## How failures are handled

- Lock waits, deadlocks and connection errors are retried with backoff.
- A row-level error (value too long, NULL in NOT NULL, constraint violation) splits the batch until only the offending rows remain; those go to `kora_sql_deadletter` and the rest are written.
- A statement-level error (unknown column or table, parse error, missing privilege) dead-letters the whole batch in one insert. A missing table is first retried twice (about 3 seconds) to allow a concurrent `ensureTable`.
- If the dead-letter insert itself fails, the row stays pending for at most 3 attempts, then it is logged in full and dropped.

See [Database](../database.md) for the dead-letter columns.

## Before the driver is ready

`enqueue` and `enqueueMany` made before the database is first reachable are held and run when it is. At most 100000 are held; further calls are dropped and logged.

## Flush triggers

The queue flushes every `kora_sql_flush_interval` ms, when `kora_sql_max_pending_rows` is reached, on `priority = 'immediate'`, on an explicit `flush`, and when the resource stops. A separate small flush pool (`kora_sql_flush_pool_size`, default 4) carries only the queue flush so transactions and ad-hoc writes cannot starve it; `0` makes the flush share the write pool.

## Limits and related APIs

Server only. A table’s options are locked while it has pending rows. Enqueued writes before the pool is ready are held, and if boot fails they are dropped with an error in the console. The queue cannot report per-row failures to the caller: use `flush` for a success flag or inspect `kora_sql_deadletter`.

## Related guides

- [Queries](./queries.md)
- [Driver exports (stats)](./driver-exports.md)
- [Configuration](./configuration.md)
