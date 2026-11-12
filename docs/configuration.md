---
title: Configuration
sidebar_position: 3
---

The Node host cannot read Lua's `Config`, so everything the pool needs at boot is a **convar** (read in `server/js/config.js`). `config.lua` only holds Lua-side behaviour. Integer convars that fail to parse fall back to their default; booleans are true for `true`, `1` or `yes`.

## Connection string

`mysql_connection_string` uses oxmysql's convar name, so an existing server migrates untouched. Two forms are accepted:

```cfg
set mysql_connection_string "mysql://user:pass@localhost/kora_core?charset=utf8mb4"
set mysql_connection_string "host=localhost;port=3306;user=root;password=secret;database=kora_core"
```

- URI scheme `mysql://` or `mariadb://`. User and password are URL-decoded. A database name is required.
- Semicolon form keys: `host`/`server`, `port`, `user`/`uid`/`userid`, `password`/`pwd`, `database`/`db`, plus the options below.
- Defaults: host `127.0.0.1`, port `3306`, user `root`, charset `utf8mb4`.

Supported options (query string or semicolon form):

- `charset` - connection charset.
- `ssl` - a JSON object of mysql2/Node TLS options, or `true` (TLS with default verification) / `false`. Other values are ignored with a warning and the connection stays **unencrypted**.
- `sslmode` (`ssl-mode`, `ssl_mode`) - `require` encrypts without verifying the certificate; `verify-ca`, `verify-full` and `verify-identity` verify it; `disable`/`none` are plaintext. `preferred` and unknown values connect unencrypted with a warning.
- `connectTimeout` - milliseconds to open a connection (default 10000). Must be positive or boot fails.

Any other option, for example `multipleStatements`, is ignored with a warning. Pool behaviour is configured with the convars below only.

## Convars

| Convar | Default | Meaning |
| --- | --- | --- |
| `kora_sql_read_pool_size` | 16 | Connections in the read pool (statements starting with SELECT, SHOW, WITH or DESC). |
| `kora_sql_write_pool_size` | 8 | Connections in the write pool (everything else, transactions, batches). |
| `kora_sql_flush_pool_size` | 4 | Separate small pool used only by the write queue flush. `0` makes the flush share the write pool. |
| `kora_sql_statement_cache` | 256 | Prepared statements per connection. Cache size times read plus write connections must not exceed 8000 or boot fails. |
| `kora_sql_flush_interval` | 250 | Milliseconds between queue flushes. |
| `kora_sql_max_pending_rows` | 500 | Pending-row count that forces a flush. |
| `kora_sql_max_rows_per_statement` | 200 | Upper bound on rows in one batched statement. |
| `kora_sql_max_placeholders` | 60000 | Upper bound on bound parameters in one batched statement. |
| `kora_sql_pad_to_buckets` | true | Pad assign-mode batches up to a bucket size (1, 2, 4, 8, 16, 32, 64, 128, 200 rows) so statement text repeats. Never applied in accumulate mode. |
| `kora_sql_slow_threshold` | 150 | Milliseconds; queries at or above it enter the slow log. |
| `kora_sql_slow_ring` | 200 | Size of the slow-query ring buffer. |
| `kora_sql_query_timeout` | 30000 | Milliseconds before a read-pool statement fails. `0` disables. Also applied as a server-side session limit. |
| `kora_sql_acquire_timeout` | 30000 | Milliseconds a call waits for a free connection before failing with `KORA_SQL_ACQUIRE_TIMEOUT`. `0` waits forever. |
| `kora_sql_pool_queue_limit` | 10000 | Callers allowed to wait per pool before new calls fail immediately. `0` is unbounded. |
| `kora_sql_max_start_transactions` | 0 | Concurrent `startTransaction` callbacks. `0` means write pool size minus 2 (minimum 1). |
| `kora_sql_stats_max_fingerprints` | 2000 | Distinct query shapes tracked by stats; older ones are merged into an `<other>` bucket. Minimum 1. |
| `kora_sql_verify_conflict_keys` | true | Warn when a queued table's conflict key is not backed by a PRIMARY/UNIQUE index. |
| `kora_sql_schema_allow_modify` | true | Allow `modify = true` columns in `ensureTable`. `false` only warns. |
| `kora_sql_default_collate` | `utf8mb4_unicode_ci` | Collation for tables `ensureTable` creates without one. Empty string uses the server default. |
| `kora_sql_allow_multiple_statements` | false | Allow multi-statement queries (see [Compatibility](./compatibility.md)). |
| `kora_sql_connect_retry_interval` | 2000 | Milliseconds between startup connection retries (minimum 250). |
| `kora_sql_ox_typecast` | true | oxmysql-style result conversion on the oxmysql path. |
| `kora_sql_debug` | false | Debug logging. |

Read-pool timeouts are client-side plus `max_execution_time` (MySQL) or `max_statement_time` (MariaDB) per read connection. Writes are never timed out client-side, because a timed-out write may still commit. Negative values for the clamped convars are raised to their minimum.

## config.lua

`config.lua` is loaded as a `kora_sql` server script and declares its options through `Kora.config` (from kora_lib).

| Key | Default | Meaning |
| --- | --- | --- |
| `Config.compat.oxmysql` | true | Register the `exports.oxmysql:*` surface. |
| `Config.compat.mysqlAsync` | true | Register the `exports['mysql-async']:*` surface. |
| `Config.compat.ghmattimysql` | true | Register the `exports.ghmattimysql:*` surface. |
| `Config.compat.installMySQLGlobal` | true | Retained preference only. `lib/MySQL.lua` does not read it and always installs the `MySQL` global. |
| `Config.compat.warnOnSync` | true | Print one warning per calling resource on first use of an oxmysql blocking `*Sync` export. |
| `Config.sql.awaitTimeout` | 30000 | See below. |
| `Config.sql.readyTimeout` | 60000 | Default wait for `Kora.sql.ready()`. |

The compat flags are read once when kora_sql loads; changing them needs a restart of kora_sql. The native `exports.kora_sql:*` API is unaffected by them.

`@kora_sql/init.lua` runs inside the **consuming** resource's Lua VM, so it reads that resource's own `Config.sql.awaitTimeout` and `Config.sql.readyTimeout`. The values in kora_sql's own `config.lua` do not change other resources. Unset `awaitTimeout` means wait for the answer. See [Lua API](./lua-api.md).

`Config.compat.allowMultipleStatements` is also checked by the oxmysql shim but is not defined in `config.lua`; the convar is the supported switch.
