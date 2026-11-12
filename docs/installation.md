---
title: Installation
sidebar_position: 2
---

## Requirements

- A running MySQL or MariaDB server.
- The `kora_lib` resource. `fxmanifest.lua` declares `dependency 'kora_lib'`, and `config.lua` uses `Kora.config` from it.
- The packaged `dist/build.js`, which bundles mysql2. Servers need neither Yarn nor `node_modules`. Contributors run `yarn install` and `yarn build` after changing anything in `server/js` and commit the rebuilt bundle.

kora_sql ships nothing to players: there are no client scripts, shared scripts or `files`.

## server.cfg

```cfg
set mysql_connection_string "mysql://user:pass@localhost/kora_core?charset=utf8mb4"
ensure kora_lib
ensure kora_sql
```

Use `set`, never `setr` or `sets`, for the connection string. `setr` replicates the convar to every client and `sets` publishes it to the server list, which would leak the password.

Ensure kora_sql before any resource that queries the database. If MySQL is still starting, kora_sql retries network-type connection failures (`ECONNREFUSED`, `ETIMEDOUT`, `ECONNRESET`, `EHOSTUNREACH`, `ENETUNREACH`, `EPIPE`, `PROTOCOL_CONNECTION_LOST`) every `kora_sql_connect_retry_interval` ms and holds database exports until it is reachable, so no restart is needed. Authentication, unknown-database and other non-network errors fail immediately with `FAILED TO START` in the console.

## Using it from another resource

```lua
shared_script '@kora_lib/init.lua'
server_scripts {
    '@kora_sql/init.lua',
    'server/main.lua',
}
```

`@kora_sql/init.lua` asserts that it is server-side and that `Kora` already exists, so it must come after `@kora_lib/init.lua`. Alternatively include `@kora_sql/lib/MySQL.lua` to get the oxmysql-style `MySQL` global (see [Compatibility](./compatibility.md)).

## Compatibility stubs

kora_sql serves `exports.oxmysql:*`, `exports['mysql-async']:*` and `exports.ghmattimysql:*` itself. It does not provide the resource names `oxmysql` or `mysql-async`. Resources that need those names (a `dependency 'oxmysql'`, an `@oxmysql/lib/MySQL.lua` include, or a version check such as ox_inventory's) need a stub deployed from this repository:

```cfg
ensure kora_lib
ensure kora_sql
ensure oxmysql        # copy of stubs/oxmysql in resources/[compat]/oxmysql
ensure mysql-async    # copy of stubs/mysql-async in resources/[compat]/mysql-async
```

Never run the real oxmysql or mysql-async alongside kora_sql. The manifest does `provide 'ghmattimysql'`. See [Compatibility](./compatibility.md) for details.

## Tests

`test/run.sh` runs the Lua smoke tests (plain `lua5.4`) and then the Node suite (`node --test`). Integration tests under `test/integration/` run only when `KORA_SQL_TEST_DSN` is set.
