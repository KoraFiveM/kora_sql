---
title: "Configuration"
sidebar_position: 7
---


# Configuration

Kora SQL is configured in two places. Everything the pool needs at boot (connection, pool sizes, cache and flush timing) is a server convar, because the Node.js host cannot read Lua’s `Config` table. `config.lua` holds only the Lua-side behaviour. Both are server settings; there is nothing to configure on the client.

Namespace: `convars · Config` · Source: `server/js/config.js, config.lua`

## Server convars (set in server.cfg)

Every convar read by `server/js/config.js`. Set them with `set name value` before `ensure kora_sql`.

| Convar | Type | Default | Controls | Notes |
| --- | --- | --- | --- | --- |
| `mysql_connection_string` | string | none (required) | Connection URI or semicolon string. See Installation. | Missing: Kora SQL refuses to start. Same name as oxmysql. |
| `kora_sql_read_pool_size` | integer | 16 | Maximum connections in the read pool. | Counts toward the prepared-statement ceiling. |
| `kora_sql_write_pool_size` | integer | 8 | Maximum connections in the write pool. Transactions and batches each hold one. | Counts toward the prepared-statement ceiling. |
| `kora_sql_statement_cache` | integer | 256 | Prepared statements cached per connection, and the size of the unpreparable-text LRU. | `cache × (read + write pool sizes)` must be at most 8000 or boot fails. |
| `kora_sql_flush_interval` | integer (ms) | 250 | Delay between the first enqueue and the flush of the write queue. | A single timer per burst, not a repeating one. Also the data-loss window on a hard crash. |
| `kora_sql_max_pending_rows` | integer | 500 | Pending rows (all tables) that force an immediate flush. | Raise only if flushes are too frequent. |
| `kora_sql_max_rows_per_statement` | integer | 200 | Maximum rows in one batched write statement. | Padding buckets stop at 200, so do not raise it expecting bigger statements to be padded. |
| `kora_sql_max_placeholders` | integer | 60000 | Maximum bound values in one batched write statement. | Wide rows get fewer rows per statement. MySQL’s hard limit is 65535. |
| `kora_sql_pad_to_buckets` | boolean | true | Pad batched upserts to 1, 2, 4, 8 ... 200 rows so SQL text stays stable. | `true`, `1` or `yes` enable it; anything else disables. Never applied in `accumulate` mode. |
| `kora_sql_slow_threshold` | integer (ms) | 150 | A query this slow or slower is added to the slow log. | Also shown as `queries.slowThreshold`. |
| `kora_sql_slow_ring` | integer | 200 | Number of slow-log entries kept. | Oldest entries are overwritten. |
| `kora_sql_allow_multiple_statements` | boolean | false | Lets text-protocol queries carry several statements, and disables the oxmysql bridge’s multi-statement refusal. | Increases SQL-injection impact. Prepared statements still cannot carry several. |
| `kora_sql_connect_retry_interval` | integer (ms) | 2000 | Pause between startup connection retries. | Values below 250 are raised to 250. Only transient network errors are retried. |
| `kora_sql_ox_typecast` | boolean | true | Applies oxmysql-style type conversion on the compatibility path only. | Native `Kora.sql.*` is never converted. |
| `kora_sql_default_collate` | string | utf8mb4_unicode_ci | Collation for tables `ensureTable` creates without an explicit one. | Empty means the server default. Existing tables are never changed. |
| `kora_sql_debug` | boolean | false | Enables debug log lines. | Verbose; use for diagnosis only. |

### More convars

Also read by `server/js/config.js`; they were not listed above.

| Convar | Type | Default | Controls | Notes |
| --- | --- | --- | --- | --- |
| `kora_sql_flush_pool_size` | integer | 4 | Separate small pool used only by the write-queue flush. | `0` makes the flush share the write pool. It is also disabled (with a warning) when it would push the prepared-statement total over 8000. |
| `kora_sql_query_timeout` | integer (ms) | 30000 | Time before a read-pool statement fails. | `0` disables. Also applied as a server-side limit (`max_execution_time` on MySQL, `max_statement_time` on MariaDB) per read connection. Writes are never timed out client-side, because a timed-out write may still commit. |
| `kora_sql_acquire_timeout` | integer (ms) | 30000 | Time a call waits for a free connection before failing with `KORA_SQL_ACQUIRE_TIMEOUT`. | `0` waits forever. |
| `kora_sql_pool_queue_limit` | integer | 10000 | Callers allowed to wait per pool before new calls fail immediately with `Queue limit reached.` | `0` is unbounded. |
| `kora_sql_max_start_transactions` | integer | 0 | Concurrent `startTransaction` callbacks. | `0` means write pool size minus 2 (minimum 1). |
| `kora_sql_stats_max_fingerprints` | integer | 2000 | Distinct query shapes tracked by statistics. | Older ones are merged into an `<other>` bucket. Minimum 1. |
| `kora_sql_verify_conflict_keys` | boolean | true | Warn when a queued table's conflict key is not backed by a PRIMARY or UNIQUE index. | |
| `kora_sql_schema_allow_modify` | boolean | true | Allow `modify = true` columns in `ensureTable`. | `false` only warns. |

Negative values for the clamped convars are raised to their minimum.

## Connection string options

`mysql_connection_string` accepts `mysql://` and `mariadb://` URIs and the semicolon form. Besides `charset`, these options are read from the query string or semicolon form:

- `ssl` - a JSON object of mysql2/Node TLS options, or `true` (TLS with default verification) / `false`. Other values are ignored with a warning and the connection stays unencrypted.
- `sslmode` (`ssl-mode`, `ssl_mode`) - `require` encrypts without verifying the certificate; `verify-ca`, `verify-full` and `verify-identity` verify it; `disable` and `none` are plaintext. `preferred` and unknown values connect unencrypted with a warning.
- `connectTimeout` - milliseconds to open a connection (default 10000). Must be positive or boot fails.

Any other option, for example `multipleStatements`, is ignored with a warning. Pool behaviour is configured with the convars on this page only.

## How it works

Convars are read once, before the pools are built, so changes need a restart of `kora_sql` (`restart kora_sql` or the Kora restart command). Integer convars that fail to parse fall back to the default. Boolean convars are true only for `true`, `1` or `yes`. The `Config` table in `config.lua` is registered with Kora Lib’s config editor (`/config`), and the compatibility switches are applied when the Lua scripts load.

## Lua Config (config.lua)

Defaults of the `Config` table. Types are enforced when the table is registered with Kora Lib.

| Option | Type | Description |
| --- | --- | --- |
| `Config.compat.oxmysql` | boolean | Default `true`. Registers the `exports.oxmysql:*` handlers. Read once at load. Restart kora_sql after changing it. |
| `Config.compat.mysqlAsync` | boolean | Default `true`. Registers `exports['mysql-async']:*`. Read once at load. |
| `Config.compat.ghmattimysql` | boolean | Default `true`. Registers `exports.ghmattimysql:*`. Read once at load. |
| `Config.compat.installMySQLGlobal` | boolean | Default `true`. Listed as a preference for the `MySQL` global. Retained but not read: `@kora_sql/lib/MySQL.lua` always installs its global. |
| `Config.compat.warnOnSync` | boolean | Default `true`. Prints one warning per resource the first time it uses a blocking oxmysql `*Sync` call. Applies to the oxmysql compatibility exports. |
| `Config.sql.awaitTimeout` | integer (ms, min 0) | Default `30000`. How long a yielding `Kora.sql.*` call waits for an answer before returning `nil, err`. Read from the calling resource's own `Config.sql.awaitTimeout` (unset means wait for the answer), not from kora_sql's config. The statement may still complete. |
| `Config.sql.readyTimeout` | integer (ms, min 0) | Default `60000`. How long `Kora.sql.ready()` waits when no argument is given. Read from the calling resource’s own `Config.sql.readyTimeout`, not from kora_sql’s config. |

`config.lua` is loaded as a `kora_sql` server script and declares its options through `Kora.config` (from kora_lib). `@kora_sql/init.lua` runs inside the consuming resource's Lua VM, so it reads that resource's own `Config.sql.*`; the values in kora_sql's own `config.lua` do not change other resources. `Config.compat.allowMultipleStatements` is also checked by the oxmysql shim but is not defined in `config.lua`; the convar `kora_sql_allow_multiple_statements` is the supported switch.

## Example: a busy server

Keep the defaults unless you measure a problem. For a large server with many readers: `set kora_sql_read_pool_size 24`, `set kora_sql_write_pool_size 12`. `256 × 36 = 9216` exceeds the ceiling of 8000, so also lower the cache: `set kora_sql_statement_cache 200` (`200 × 36 = 7200`). The pool sizes must also fit under your database’s `max_connections`.

## Prepared-statement ceiling

MySQL’s `max_prepared_stmt_count` is global and defaults to 16382. Kora SQL refuses to start if `kora_sql_statement_cache × (read pool + write pool)` exceeds 8000, with the message `over the safe ceiling of 8000`, to protect other applications on a shared database host.

## Fixed pool settings

These are not configurable: keep-alive after 10 s, 10-second connect timeout, UTC timezone, `DECIMAL` and `BIGINT` as numbers, dates as JavaScript dates, named placeholders on.

## Convar names

`kora_sql_statement_cache` is the only name read for the prepared-statement cache; no older alias is read by the code.

## Limits and related APIs

Server only. Convars cannot be changed at runtime for a running pool. Do not put the connection string anywhere a client can read it (resource files sent to clients, shared scripts, logs, screenshots).

## Related guides

- [Queries](./queries.md)
- [Write queue](./write-queue.md)
