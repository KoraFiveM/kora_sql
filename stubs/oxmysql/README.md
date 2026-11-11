# oxmysql compatibility placeholder

A content-free resource named `oxmysql` so stock resources that do
`dependencies { 'oxmysql' }`, `server_scripts { '@oxmysql/lib/MySQL.lua' }` or
`lib.checkDependency('oxmysql', '2.7.3')` (for example ox_inventory) work on top
of kora_sql. It is a compatibility placeholder, not affiliated with Overextended.
`lib/MySQL.lua` loads kora_sql's own `lib/MySQL.lua` into the including resource's
VM, so there is one implementation. Exports (`exports.oxmysql:*`) are still served by
kora_sql's `server/compat/oxmysql.lua`; this resource registers none.

## Deploy

Copy this folder to `resources/[compat]/oxmysql`. Ensure order:

```
ensure kora_lib
ensure kora_sql
ensure oxmysql        # this placeholder
ensure ox_lib         # the ox_lib shim
ensure ox_inventory
```

The placeholder must start after kora_sql (it declares `dependency 'kora_sql'`) and
before anything that includes `@oxmysql/lib/MySQL.lua`. **Real oxmysql must not run
alongside it** (two `oxmysql` resources cannot coexist, and real oxmysql would also
fight kora_sql over the `__cfx_export_oxmysql_*` handlers).

## When it is needed

kora_sql does **not** `provide 'oxmysql'`; this placeholder alone owns the name.
(Both claiming it meant `stop oxmysql` also stopped kora_sql, and after `restart
kora_sql` the name resolved to kora_sql, so ox_inventory saw version 1.0.0 instead of
2.7.3.) Resources that declare `dependency 'oxmysql'`, include
`@oxmysql/lib/MySQL.lua` or call `lib.checkDependency('oxmysql', '2.7.3')` need this
placeholder ensured after kora_sql. `exports.oxmysql:*` works without it, served by
kora_sql's `__cfx_export_oxmysql_*` handlers.

## Version

`version '2.7.3'` is the minimum ox_inventory accepts; `GetResourceMetadata` reads it
from this manifest.

## Scratch-server checks

1. `ensure oxmysql` starts the placeholder and `oxmysql` shows `started` in `resources`.
2. A consumer with `server_script '@oxmysql/lib/MySQL.lua'` loads and
   `MySQL.query.await('SELECT 1')` works.
3. `exports.oxmysql:query(...)` reaches kora_sql, with and without the placeholder.
4. `stop oxmysql` does not stop kora_sql; `restart kora_sql` restarts the placeholder
   (dependency) and `GetResourceMetadata('oxmysql', 'version', 0)` still returns `2.7.3`.

## Semantics ox_inventory relies on

`*.await` throws on SQL error (`pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory')`
detects a missing table); `MySQL.prepare.await` returns the single value for one-column
one-row selects and accepts an array of parameter arrays; `MySQL.query` works without a
callback; DDL and `INTERVAL` clauses pass through unchanged. Pinned by
`test/smoke/oxmysql_placeholder.lua` and `test/js/execute.test.js`.

## Write coalescing

Ad-hoc `MySQL.*` calls (everything ox_inventory does) run directly through the executor
and never enter kora_sql's write-coalescing queue, which only serves the explicit
`Kora.sql.enqueue*` API. So DDL and inventory saves cannot be delayed past
`txAdmin:events:serverShuttingDown`, `scheduledRestart` or `onResourceStop`.
