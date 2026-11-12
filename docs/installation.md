---
title: "Installation"
sidebar_position: 2
---


# Installation

Kora SQL is the database driver for the Kora stack: a Node.js driver built on mysql2 with split read/write connection pools, a prepared-statement cache and a write-coalescing queue. It is server-only and also answers to the `oxmysql`, `mysql-async` and `ghmattimysql` export names. Follow these steps in order.

## Install Kora SQL

1. **Add the folder** — Place the `kora_sql` folder in your resources directory (on the Kora recipe it is `resources/[pre]/kora_sql`). Keep the folder name unchanged: consumers call `exports.kora_sql` and load `@kora_sql/init.lua` by that name.

2. **Have a MariaDB or MySQL database ready** — Create an empty database and a user that may `CREATE`, `ALTER`, `INSERT`, `UPDATE`, `DELETE` and `SELECT` in it, and read `information_schema`. The schema helper creates tables and adds columns, indexes and foreign keys, so the user needs those privileges. Kora SQL probes `SELECT VERSION()` once at boot and picks the right upsert syntax for MariaDB or MySQL 8.0.20+ automatically.

3. **Set the connection string and start it** — Add the connection string convar before `ensure kora_sql`, and start Kora SQL after Kora Lib and before every resource that queries. Kora SQL declares `dependency 'kora_lib'`.

   ```bash title="server.cfg" {2}
   # Connection string: the only required setting. Same convar name as oxmysql.
   set mysql_connection_string "mysql://kora:change-me@127.0.0.1:3306/kora_dev?charset=utf8mb4"

   # Optional tuning (defaults shown)
   set kora_sql_read_pool_size 16
   set kora_sql_write_pool_size 8
   set kora_sql_statement_cache 256
   set kora_sql_flush_interval 250
   set kora_sql_max_pending_rows 500
   set kora_sql_slow_threshold 150

   ensure kora_theme
   ensure kora_lib
   ensure kora_sql
   # ...then every resource that queries the database
   ensure kora_core
   ```

4. **Connect your resource** — In the manifest of every resource that uses `Kora.sql.*`, list the Kora Lib loader as a shared script and the Kora SQL loader as a server script. The highlighted line installs the `Kora.sql` functions into your resource’s own Lua VM.

   ```lua title="fxmanifest.lua" {14}
   fx_version 'cerulean'
   game 'gta5'
   lua54 'yes'

   name 'my_shop'

   dependency 'kora_lib'
   dependency 'kora_sql'

   shared_scripts {
       '@kora_lib/init.lua',  -- creates the Kora namespace (must come first)
       'config.lua',
   }

   server_scripts {
       '@kora_sql/init.lua',  -- installs Kora.sql.* into THIS resource's Lua VM (server-only)
       'server/schema.lua',
       'server/main.lua',
   }
   ```

5. **Confirm it is up** — The console prints `[kora_sql:ready] driver up: <server version>` once the pool is connected. From the server console you can also run `kora_sql ping`, which prints the database version and the round-trip time.

## Requirements and packaging

- A running MySQL or MariaDB server.
- The `kora_lib` resource. `fxmanifest.lua` declares `dependency 'kora_lib'`, and `config.lua` uses `Kora.config` from it.
- The packaged `dist/build.js`, which bundles mysql2. Servers need neither Yarn nor `node_modules`. Contributors run `yarn install` and `yarn build` after changing anything in `server/js` and commit the rebuilt bundle.
- kora_sql ships nothing to players: there are no client scripts, shared scripts or `files`.

## Connection string formats

The `mysql_connection_string` convar accepts two forms. The database name is required in both: if it is missing Kora SQL refuses to start and logs `connection string is missing a database name`. If the convar is not set at all it logs `no mysql_connection_string convar set`.

```bash title="server.cfg"
# URI form (mysql:// or mariadb://). User, password and database name are URL-decoded,
# so encode special characters in a password (for example @ as %40).
set mysql_connection_string "mysql://user:pass@localhost:3306/kora?charset=utf8mb4"

# Semicolon form (keys are case-insensitive)
set mysql_connection_string "host=localhost;port=3306;user=kora;password=secret;database=kora;charset=utf8mb4"
```

- Defaults when a part is omitted: host `127.0.0.1`, port `3306`, user `root`, empty password, charset `utf8mb4`.
- Semicolon-form key aliases: `host`/`server`, `user`/`uid`/`userid`, `password`/`pwd`, `database`/`db`, plus `port` and `charset`. In URI form only `charset` is read from the query string.
- `charset=utf8mb4` selects the connection collation `utf8mb4_unicode_ci`. A value that already contains an underscore (for example `utf8mb4_general_ci`) is used as given.
- The connection uses UTC (`timezone: Z`), `decimalNumbers`, `supportBigNumbers` and `namedPlaceholders`, and keeps connections alive. These are fixed in the code, not configurable.

## Keep the connection string private

Use `set`, never `setr` or `sets`, for `mysql_connection_string`. `setr` replicates the convar to every client and `sets` publishes it to the server list, which would leak the password. If that happened, rotate the password.

## Using it from another resource

`@kora_sql/init.lua` asserts that it is server-side and that `Kora` already exists, so it must come after `@kora_lib/init.lua`, and it belongs in `server_scripts`, never in shared or client scripts. Alternatively include `@kora_sql/lib/MySQL.lua` to get the oxmysql-style `MySQL` global (see [Compatibility](./api/compatibility.md)).

```lua title="fxmanifest.lua"
shared_script '@kora_lib/init.lua'
server_scripts {
    '@kora_sql/init.lua', -- server-only; never client
    'server/main.lua',
}
```

## Start order and startup behavior

- Kora SQL registers all of its exports immediately when it loads, then opens the pools asynchronously. Every data export waits behind one shared readiness promise, so a resource that queries while it is still loading does not fail: its query simply runs once the pool is up.
- If MySQL is still starting, transient network errors (`ECONNREFUSED`, `ECONNRESET`, `ETIMEDOUT`, `EHOSTUNREACH`, `ENETUNREACH`, `EPIPE`, `PROTOCOL_CONNECTION_LOST`) are retried every `kora_sql_connect_retry_interval` ms (default 2000, minimum 250). Queries keep waiting and resume without any restart.
- Non-network failures are not retried: a wrong password, a missing database, a bad connection string or an oversized statement cache fail immediately. The console shows `FAILED TO START: <message>`, `isReady()` stays `false`, and every waiting data call returns that error.
- Once connected, Kora SQL creates its own tables `kora_sql_schema_owners` and `kora_sql_deadletter` (see [Database](./database.md) and [Write queue](./api/write-queue.md)) before it reports ready.
- When Kora SQL itself is stopped or restarted it flushes the write queue first, then closes both pools. A restart therefore does not drop queued writes.

## Migrating from oxmysql, mysql-async or ghmattimysql

An existing server.cfg keeps working because the convar name `mysql_connection_string` is the same. Remove the old driver, `ensure kora_sql`, and existing resources continue to call their usual exports. Two things need extra steps for resources that check for the old resource name:

- Resources that declare `dependency 'oxmysql'`, include `@oxmysql/lib/MySQL.lua` or call `lib.checkDependency('oxmysql', '2.7.3')` need the placeholder in `stubs/oxmysql`. Copy it to `resources/[compat]/oxmysql` and `ensure` it after `kora_sql`. Kora SQL deliberately does not `provide 'oxmysql'`, so `stop oxmysql` cannot stop the driver.
- The same applies to `mysql-async`: copy `stubs/mysql-async` to `resources/[compat]/mysql-async` and `ensure` it after `kora_sql` for resources that declare `dependency 'mysql-async'` or include `@mysql-async/lib/MySQL.lua`.
- Never run the real oxmysql or mysql-async next to Kora SQL: they would compete for the same `__cfx_export_*` handlers.
- `exports.oxmysql:*`, `exports['mysql-async']:*` and `exports.ghmattimysql:*` work without any placeholder. The manifest does `provide 'ghmattimysql'`.

## Compatibility stubs

kora_sql serves `exports.oxmysql:*`, `exports['mysql-async']:*` and `exports.ghmattimysql:*` itself. Resources that need the resource names `oxmysql` or `mysql-async` (a `dependency`, an `@oxmysql/lib/MySQL.lua` include, or a version check such as ox_inventory's) need a stub deployed from this repository, ensured after kora_sql:

```cfg title="server.cfg"
ensure kora_lib
ensure kora_sql
ensure oxmysql        # copy of stubs/oxmysql in resources/[compat]/oxmysql
ensure mysql-async    # copy of stubs/mysql-async in resources/[compat]/mysql-async
```

See [Compatibility](./api/compatibility.md) for what each stub declares.

## If it does not start

- Console says `no mysql_connection_string convar set`: add the convar above `ensure kora_sql`.
- Console says `connection string is missing a database name`: add `/dbname` (URI form) or `database=...` (semicolon form).
- Console says `kora_sql_statement_cache x total connections ... over the safe ceiling of 8000`: lower `kora_sql_statement_cache` or the pool sizes. The defaults (256 × 24 = 6144) pass.
- Console repeats `database unavailable (ECONNREFUSED); retry N`: MySQL is not reachable yet. Kora SQL keeps retrying. Check the host, port and that MySQL is running.
- Access denied or unknown database: fix the credentials or create the database. This is not retried, so restart `kora_sql` after fixing it.
- Your resource says `Kora.sql.* ... attempt to index a nil value` or `@kora_sql/init.lua must be loaded AFTER @kora_lib/init.lua`: the shared scripts are missing or in the wrong order. See the manifest above.
- Another resource reports that a required table does not exist: tables owned by other resources appear a few seconds after start on a blank database. Call `Kora.sql.awaitTables` before the first query (see Schema).

## Tests

`test/run.sh` runs the Lua smoke tests (plain `lua5.4`) and then the Node suite (`node --test`). Integration tests under `test/integration/` run only when `KORA_SQL_TEST_DSN` is set.
