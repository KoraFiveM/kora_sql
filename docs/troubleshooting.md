---
title: Troubleshooting
sidebar_position: 6
---

## FAILED TO START in the console

The message after it is the real cause. Common ones:

- `no mysql_connection_string convar set` - add it to `server.cfg` with `set`, before `ensure kora_sql`.
- `connection string is missing a database name` - add `/dbname` to the URI or `database=` to the semicolon form.
- `kora_sql_statement_cache x total connections ... over the safe ceiling of 8000` - lower the cache or pool sizes.
- Authentication errors fail immediately. Only network-type errors are retried (`database unavailable ... retry N`).

## Calls hang or fail with KORA_SQL_ACQUIRE_TIMEOUT or Queue limit reached

Every connection in a pool is busy. Look at `/kora_sql slow`, raise the pool size convars, or fix the slow queries. `Queue limit reached.` means more than `kora_sql_pool_queue_limit` callers are waiting.

## A resource asks for oxmysql or mysql-async and will not start

It needs the stub resource. Deploy `stubs/oxmysql` or `stubs/mysql-async` as described in [Installation](./installation.md). Remove any real oxmysql.

## Multi-statement query refused

Split the SQL, or set `kora_sql_allow_multiple_statements true` knowing the injection risk.

## Queued rows never appear

Check the console for dead-letter lines and query `kora_sql_deadletter`. Unknown columns, values too long or NULLs in NOT NULL columns are never retried. A warning about the conflict key not being a PRIMARY/UNIQUE index means upserts will insert duplicates.

## Results look different from oxmysql

Check `kora_sql_ox_typecast`. It applies only on the oxmysql path; `Kora.sql.*` returns raw mysql2 shapes (for example `TINYINT(1)` as a number).

## Schema differences are only warnings

`ensureTable` never alters existing columns unless `modify = true` and every safe-modify condition holds. See [Schema management](./api/schema.md).

## Connection string password leaked

Use `set`, not `setr` or `sets`, for `mysql_connection_string`, and rotate the password.
