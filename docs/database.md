---
title: Database
sidebar_position: 11
---

kora_sql connects to the database named in `mysql_connection_string` and creates two tables of its own at boot through `ensureTable`. The connection uses UTC (`timezone: 'Z'`), `decimalNumbers` and big-number support with numbers (not strings), and `stringifyObjects`.

## kora_sql_schema_owners

Records which resource created each table made through `ensureTable`, and is used to decide who may apply a safe `modify` (see [Schema management](./schema.md)).

| Column | Type | Notes |
| --- | --- | --- |
| `table_name` | `varchar(64)` | Primary key. |
| `resource` | `varchar(64)` | Creating resource. |
| `claimed_at` | `timestamp` | Default `CURRENT_TIMESTAMP`. |

## kora_sql_deadletter

Rows the write queue could not write (see [Write queue](./write-queue.md)).

| Column | Type | Notes |
| --- | --- | --- |
| `id` | `bigint unsigned` | Auto-increment primary key. |
| `table_name` | `varchar(64)` | Target table. |
| `pk` | `varchar(191)` | Primary key value. Composite keys are a JSON array of strings; longer keys keep a prefix plus `~sha:` and 40 hex characters. |
| `cols_json` | `longtext` | The row's columns as JSON. |
| `error` | `varchar(500)` | Error message, nullable. |
| `failed_at` | `timestamp` | Default `CURRENT_TIMESTAMP`. Index `idx_deadletter_table` on `table_name`. |

Inspect and replay these rows manually; kora_sql never retries them.

## kora_sql_bench

Created only by `/kora_sql bench` (`id varchar(32)` primary key, `v int`).

## Other tables

kora_sql does not own your tables. Resources create theirs with `ensureTable`; the SQL they run goes through the pools described in [Configuration](./configuration.md).
