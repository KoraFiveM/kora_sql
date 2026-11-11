# mysql-async compatibility stub

A small resource named `mysql-async` so stock resources that declare
`dependency 'mysql-async'` or include `@mysql-async/lib/MySQL.lua` work on top of
kora_sql. Not affiliated with the original mysql-async.

- `lib/MySQL.lua` loads kora_sql's own `lib/MySQL.lua` into the including resource's VM,
  giving it `MySQL.Async.fetchAll/fetchScalar/execute/insert/transaction`,
  `MySQL.Sync.*`, `MySQL.ready` (plus the oxmysql-style `MySQL.query` etc.).
- The raw exports (`exports['mysql-async']:mysql_fetch_all`, `mysql_fetch_scalar`,
  `mysql_execute`, `mysql_insert`, `mysql_transaction`, `mysql_store`, `is_ready`) are
  served by kora_sql's `server/compat/mysql-async.lua`; this stub registers none.

kora_sql no longer `provide`s `mysql-async`; this stub alone owns the name.

## Deploy

Copy this folder to `resources/[compat]/mysql-async` and ensure it after kora_sql:

```
ensure kora_lib
ensure kora_sql
ensure mysql-async    # this stub
ensure my_legacy_script
```

Never run the real mysql-async alongside it. Resources that only use
`exports['mysql-async']:*` or the `MySQL` global from `@kora_sql/lib/MySQL.lua` do not need
the stub.
