---
title: kora_sql
sidebar_position: 1
---

`kora_sql` is a server-only MySQL/MariaDB driver for FiveM, built on Node and mysql2. It replaces oxmysql and offers a `Kora.sql.*` Lua API plus drop-in compatibility with `oxmysql`, `mysql-async` and `ghmattimysql`. The release version is the `version` field in `fxmanifest.lua`.

What sets it apart:

- **Write coalescing.** Fire-and-forget row writes are merged by primary key and flushed as batched `INSERT ... ON DUPLICATE KEY UPDATE` statements.
- **Split pools.** Separate read, write and (optionally) flush pools keep save latency independent of read load.
- **Prepared-statement cache.** SQL text that MySQL refuses to prepare is remembered and sent as plain text afterwards.
- **Declarative schema.** `Kora.sql.ensureTable` creates missing tables and adds missing columns, indexes, foreign keys and checks.

## Documentation map

- [Installation](./installation.md) - database setup, `server.cfg`, connection strings, start order, migrating from oxmysql and the compat stubs.
- [How to use](./how-to-use.md) - first query, result shapes, binding, error handling and a full worked example.
- [Commands](./commands.md) - the `/kora_sql` console command (ping, stats, slow, queue, flush, bench).
- [API reference](./api/index.md) - all modules:
  - [Queries](./api/queries.md) - `Kora.sql.query`, `single`, `scalar`, `execute`, `insert`, `update` and callback variants.
  - [Transactions](./api/transactions.md) - `transaction`, `batch`, `transactionChecked` and checked operations.
  - [Write queue](./api/write-queue.md) - `enqueue`, `enqueueMany`, `upsert`, `flush`, dead-letters and durability.
  - [Schema](./api/schema.md) - `ensureTable`, `ensureTables`, `awaitTables`, specs and safe `modify` rules.
  - [Driver exports](./api/driver-exports.md) - the server exports of `kora_sql` itself, statistics and slow log.
  - [Configuration](./api/configuration.md) - connection string, every convar and `config.lua`.
  - [Events](./api/events.md) - `kora_sql:ready`, `oxmysql:transaction-error` and the events kora_sql handles.
  - [Compatibility](./api/compatibility.md) - oxmysql, mysql-async and ghmattimysql surfaces, typecast and native bridges.
  - [Security and best practices](./api/security.md) - what is protected, what is not, and checklists.
- [Database](./database.md) - tables kora_sql creates and uses.
- [Troubleshooting](./troubleshooting.md) - common errors and fixes.

## Quick start

```lua
-- fxmanifest.lua of a consumer resource
shared_script '@kora_lib/init.lua'
server_scripts {
    '@kora_sql/init.lua', -- server-only; never shared or client
    'server.lua',
}
dependency 'kora_sql'
```

```lua
-- server.lua
local rows, err = Kora.sql.query('SELECT * FROM players WHERE license = ?', { license })
if not rows then print('query failed:', err) return end
```
