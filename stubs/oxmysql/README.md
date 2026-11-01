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

## Version

`version '2.7.3'` is the minimum ox_inventory accepts. `GetResourceMetadata` does not
follow `provide`, so the placeholder must declare it itself.

## Coexistence with kora_sql's `provide 'oxmysql'`

kora_sql keeps `provide 'oxmysql'`. With a real resource also named `oxmysql`, the
expected behaviour is that the real-named resource wins for `@oxmysql/...` includes,
`GetResourceState('oxmysql')` and `GetResourceMetadata('oxmysql', ...)`, while `provide`
still satisfies `dependency 'oxmysql'` for resources that do not look at the name.
This is unverified (about 90% confidence). Risks to check on a **scratch server**:

1. `ensure oxmysql` starts the placeholder (not "resource not found" or a conflict with
   the provided name) and `oxmysql` shows `started` in `resources`.
2. A consumer with `server_script '@oxmysql/lib/MySQL.lua'` loads and
   `MySQL.query.await('SELECT 1')` works (the file resolves from this folder).
3. `exports.oxmysql:query(...)` still reaches kora_sql (kora_sql's export hijack
   answers; the placeholder has no exports to shadow it).
4. Stopping or restarting the placeholder does not stop kora_sql, and restarting
   kora_sql restarts the placeholder (dependency) without leaving ox_inventory stale.
5. `GetResourceMetadata('oxmysql', 'version', 0)` returns `2.7.3`.
6. No "multiple resources provide/are named oxmysql" error at boot. If there is one, the
   fallback is to drop `provide 'oxmysql'` from kora_sql's manifest (not done here).

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
