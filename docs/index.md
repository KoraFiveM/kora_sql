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

## Pages

- [Installation](./installation.md) - dependencies, `server.cfg`, ensure order, compat stubs.
- [Configuration](./configuration.md) - connection string, TLS options, every convar, and `config.lua`.
- [Lua API](./lua-api.md) - the `Kora.sql.*` functions.
- [Write queue](./write-queue.md) - `enqueue`, `enqueueMany`, `upsert`, `flush`, dead-letters and durability.
- [Schema management](./schema.md) - `ensureTable` and `ensureTables` specs and safe `modify` rules.
- [Exports](./exports.md) - the server exports of `kora_sql` itself.
- [Compatibility](./compatibility.md) - oxmysql, mysql-async and ghmattimysql surfaces, typecast, and the native bridges.
- [Commands](./commands.md) - the `/kora_sql` console command.
- [Events](./events.md) - events kora_sql listens for and triggers.
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
