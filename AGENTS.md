# kora_sql agent guide

## What this is
A high-throughput MySQL driver for FiveM, built to replace oxmysql. Node + mysql2
on the server; a thin Lua surface (`Kora.sql.*`) plus full drop-in compatibility
with `oxmysql`, `mysql-async`, and `ghmattimysql`. The performance thesis is
**architectural, not "mysql2 is fast"** — see below.

## The performance thesis (five mechanisms)
1. **Prepared-statement LRU** (`server/js/statements.js`). mysql2 caches prepared
   statements per connection; what it does NOT remember is that a given SQL text
   *cannot* be prepared. On `ER_UNSUPPORTED_PS`/`ER_WRONG_ARGUMENTS` we fall back
   to `query()` and **permanently mark that text unpreparable**, so the failed
   prepare is paid at most once per text.
2. **Split read/write pools** (`server/js/pool.js`). Writes serialise on InnoDB
   row locks anyway; a burst of slow SELECTs on a shared pool would starve the
   save flush. Two pools over one DSN make flush latency independent of read load.
3. **Write coalescing** (`server/js/queue.js`). The main event. Callers enqueue
   per-row writes; the queue merges them **by primary key** and, at flush time,
   groups rows by column signature and emits one batched
   `INSERT ... ON DUPLICATE KEY UPDATE` per group. N player saves collapse into a
   handful of round trips. Keying by PK (not by column-set) is a **correctness**
   requirement — see the long comment at the top of `queue.js`.
4. **Bucket padding** (`server/js/batch.js`). Batched SQL text varies with row
   count, wrecking the prepared cache. Row counts are quantised to buckets and
   padded by repeating an existing row — a genuine no-op under last-write-wins
   assignment. **Only sound in assign mode**; a hard `assert` forbids padding in
   accumulate mode (a duplicated row would double-count).
5. **One boundary crossing per flush**. `enqueueMany` takes an array of rows —
   N players, one Lua→JS crossing. `/qbsql bench` measures this A/B directly.

## Configuration split (why convars AND config.lua)
The Node host cannot read Lua's `Config`. Anything the pool needs at boot
(connection string, pool/cache sizes, flush timing) is a **convar** read in
`server/js/config.js`. `config.lua` holds only Lua-side behaviour
(`Config.compat.*`, `Config.sql.*`). Rejected alternatives: pushing Config into
JS at boot (startup race — a query could arrive before the pool exists); a second
JSON config format. `mysql_connection_string` is deliberately oxmysql's convar
name so an existing server.cfg migrates untouched.

At boot, transient network failures are retried by `server/js/startup.js` while
the one shared readiness promise remains pending. Do not reject readiness for a
recoverable `ECONNREFUSED`/`ETIMEDOUT`-style race: exports deliberately wait on
that promise so consumers resume without restarting once MySQL is reachable.

## The FiveM export-registration gotcha
FiveM's citizen `exports(name, fn)` registrar is the bare `exports` global **only
in the resource entry file**. In a `require()`'d CommonJS sub-module, bare
`exports` is `module.exports` and is not callable — which is why oxmysql bundles
to a single file. kora_sql follows that release model: esbuild emits
`dist/build.js`, and `server/js/index.js` captures `globalThis.exports` before
passing the registrar into `server/js/exports.js`. Never call bare
`exports(...)` from a sub-module.

## Compat and attribution
`server/compat/*.lua` register the foreign export surfaces via the
`__cfx_export_<res>_<name>` identity hijack (same technique as
`kora_target/client/compat/ox-target.lua`). Because the real impl lives in the JS
runtime, the Lua shim must cross the boundary — so it captures
`GetInvokingResource()` **at call time** and forwards it as the trailing
`invokingResource` argument, which the JS `dataExport` wrapper peels off and
hands to `stats.js`. Without this, every slow query is attributed to `kora_sql`.
`params` is always normalised to a table before crossing so the wrapper's
trailing-argument peeling has a stable argument count.

kora_sql does NOT `provide 'oxmysql'`. Sharing the name with the placeholder made
`stop oxmysql` stop kora_sql, and after `restart kora_sql` the name resolved to
kora_sql (version 1.0.0), breaking ox_inventory's version check. The placeholder
`stubs/oxmysql/` alone owns the name. Resources that declare `dependency 'oxmysql'`,
include `@oxmysql/lib/MySQL.lua` or check `lib.checkDependency('oxmysql', '2.7.3')`
(stock ox_inventory) REQUIRE it, deployed as `[compat]/oxmysql` (version 2.7.3,
ensured after kora_sql; real oxmysql must not run). `exports.oxmysql:*` works
without the placeholder (the manual `__cfx_export_oxmysql_*` handlers). `provide
'ghmattimysql'` is kept. kora_sql does NOT `provide 'mysql-async'` either:
`stubs/mysql-async/` owns that name the same way. Deploy it as
`resources/[compat]/mysql-async` (copy the folder), `ensure` it after kora_sql, for
consumers with `dependency 'mysql-async'` or an `@mysql-async/lib/MySQL.lua` include;
never run real mysql-async with it. Export identity always requires the manual handlers above.

## oxmysql typeCast
The oxmysql path (Lua bridge, `_async` exports, `lib/MySQL.lua`) calls the JS `ox*` export
variants (`oxQuery`, `oxSingle`, `oxScalar`, `oxInsert`, `oxUpdate`, `oxPrepare`,
`oxRawExecute`), which run `Executor.withOxTypeCast()` — a port of oxmysql's
`typeCast.ts` in `server/js/typecast.js` (plus JSON-as-string for oxmysql's
`jsonStrings`). Convar `kora_sql_ox_typecast` (default true) gates it; native exports and
`Kora.sql.*` never convert. Keep the ox names in sync when adding an executor to the bridge.
`dist/build.js` must be rebuilt (`yarn build`) after touching `server/js`.

## Refused, loudly
- Multi-statement queries (`multipleStatements: false`; config-gated escape hatch
  `qbsql_allow_multiple_statements`, default off).
- `store()` handles surviving a restart (in-memory `Map`; warns on unknown handle).
- Raw connection handles (no such API; the refusal points at `transaction`).
The first `*Sync` use per calling resource prints once, naming the resource.

## Migrations
kora_sql owns the runner (`server/js/migrate.js`); each resource owns its files. A
checksum mismatch on an already-applied version is a **hard boot abort** — never
a warning. `qbsql_migrations` and `qbsql_deadletter` are bootstrapped at boot.

## Build and distribution
Like oxmysql, kora_sql ships one server bundle containing mysql2. Run `yarn build`
after changing JS or dependencies and commit `dist/build.js`; FXServer does not
need a yarn builder or runtime `node_modules`. Keep `yarn.lock` committed and
`node_modules/` ignored. Source tests still run against the unbundled modules.

## Testing
`test/run.sh` runs the Lua smoke tests (plain lua5.4) then the JS suite
(`node --test`). The **golden SQL assertions in `test/js/batch.test.js` are the
highest-value test in the project** — the batch builder is where a silent
data-corruption bug would live, so its exact wire text is pinned byte-for-byte.
`test/js/queue.test.js` pins the coalescing contract against a fake pool (no DB).
`test/integration/` runs only when `QBSQL_TEST_DSN` is set. NOTE: the resource
path contains `[test]`, which Node's `--test` treats as a glob character class —
`run.sh` cd's into the test dir and uses relative, bracket-free paths.

When you change the export surface, update `docs.md` and add/adjust the matching
smoke test in the same change.
