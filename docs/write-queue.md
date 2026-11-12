---
title: Write queue
sidebar_position: 5
---

The coalescing queue is the hot save path. Callers hand per-row writes to it; it merges them by primary key and, at flush time, groups rows by column signature and emits one batched `INSERT ... ON DUPLICATE KEY UPDATE` per group.

## Functions

```lua
Kora.sql.enqueue('players', 'citizenid', { pk = cid, cols = { money = json } })
Kora.sql.enqueueMany('players', 'citizenid', {
    { pk = cid1, cols = { money = json1 } },
    { pk = cid2, cols = { money = json2 } },
}, { mode = 'assign', writeMode = 'upsert' })
Kora.sql.flush('players')                          -- yields until drained; flush() drains everything
local affected = Kora.sql.upsert('players', 'citizenid', rows, opts)
```

- `enqueue` and `enqueueMany` never yield and never raise. `enqueueMany` crosses the Lua/JS boundary once for N rows.
- `flush(table?)` yields; returns `true` or `false, errString`.
- `upsert` is an awaited `enqueueMany` plus `flush` in one call. It is all-or-nothing: invalid input returns `nil, errString`.
- Composite keys: pass a list for `conflictKey` and a list for `pk`.

## Options

`opts` accepts:

- `mode = 'assign'` (default) sets `col = new value`, last write wins. `'accumulate'` sets `col = col + value`; every value must be a finite number (a plain decimal string is converted), anything else is refused.
- `writeMode = 'upsert'` (default) inserts missing rows then updates on conflict. `'update'` only updates rows that already exist, for partial writes to tables with required columns missing from `cols`.
- `priority = 'immediate'` flushes the table now instead of waiting for the interval (one flush per call).
- `allowedColumns = { 'settings' }` refuses any column not listed. Use it when `cols` comes from client data.

## Validation

- The table, conflict-key columns and every `cols` key must be plain identifiers (`A-Za-z0-9_`, 1 to 64 characters). `players.money` is refused.
- `cols` must be non-empty and must not contain a conflict-key column.
- Each primary-key value must be a string or finite number. `7` and `'7'` are the same row and merge.
- An invalid row in `enqueue`/`enqueueMany` is dropped and logged once per calling resource and reason; valid rows in the same call are still queued.

Rows are written in primary-key order so concurrent flushes lock rows in a consistent order. On first use of a table the conflict key is checked against its PRIMARY/UNIQUE indexes (`kora_sql_verify_conflict_keys`); a warning is logged if none matches, because upserts would insert duplicates.

## Errors and the dead-letter table

- Lock waits, deadlocks and connection errors are retried with backoff.
- A row-level error (value too long, NULL in NOT NULL, constraint violation) splits the batch until only the offending rows remain; those go to `kora_sql_deadletter` and the rest are written.
- A statement-level error (unknown column or table, parse error, missing privilege) dead-letters the whole batch in one insert. A missing table is first retried twice (about 3 seconds) to allow a concurrent `ensureTable`.
- If the dead-letter insert itself fails, the row stays pending for at most 3 attempts, then it is logged in full and dropped.

See [Database](./database.md) for the dead-letter columns.

## Before the driver is ready

`enqueue` and `enqueueMany` made before the database is first reachable are held and run when it is. At most 100000 are held; further calls are dropped and logged.

## Durability

The queue flushes every `kora_sql_flush_interval` ms, when `kora_sql_max_pending_rows` is reached, on `priority = 'immediate'`, on explicit `flush`, and when the resource stops. A hard crash can lose up to one flush interval of pending writes.

## Bucket padding

Batched statement text varies with row count, which defeats the prepared-statement cache. In assign mode with `kora_sql_pad_to_buckets` on, row counts are rounded up to a bucket and padded by repeating an existing row, which is a no-op under last-write-wins. Padding is never used in accumulate mode.
