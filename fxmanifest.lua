fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'kora_sql'
author 'Jamie'
version '1.0.0'
description 'High-throughput MySQL driver for FiveM with write coalescing and oxmysql/mysql-async compatibility'

dependency 'kora_lib'

-- `provide` only satisfies ANOTHER resource's `dependency`/`dependencies`
-- check. It does NOT make exports.oxmysql:query() resolve here -- that
-- additionally requires registering the underlying __cfx_export_oxmysql_query
-- event, which server/compat/oxmysql.lua does via its provideExport() helper
-- (same identity-hijack technique as kora_target/client/compat/ox-target.lua).
-- 'oxmysql' is deliberately NOT provided: the stubs/oxmysql placeholder owns that
-- name. Providing it too made `stop oxmysql` stop kora_sql, and after
-- `restart kora_sql` the name resolved to kora_sql (version 1.0.0).
-- 'mysql-async' is deliberately NOT provided either: deploy stubs/mysql-async as
-- resources/[compat]/mysql-async (it owns that name, like stubs/oxmysql owns oxmysql).
provide 'ghmattimysql'

-- No `files`, no shared/client scripts: kora_sql is server-only and ships
-- nothing to players. '@kora_sql/init.lua' and '@kora_sql/lib/MySQL.lua' are
-- server_scripts includes in consumers, which read straight from disk and do
-- not need `files`. Never add them to a consumer's shared or client scripts.

-- Load order here is deliberately NOT load-bearing, and that is the design
-- goal: the JS entry registers exports.kora_sql:* at its own load time, and every
-- Lua file below resolves `exports.kora_sql` LAZILY inside each call rather than
-- caching a reference at load time. FXServer runs the Lua and Node hosts
-- separately, so a load-time capture across that boundary is exactly the kind
-- of thing that works on one build and breaks on the next. Listed explicitly
-- (never globbed) so the intended sequence is documented, not implied by
-- alphabetical glob expansion.
--   0. @kora_lib/init.lua + config.lua  first: compat/* read Config.compat at load
--   1. dist/build.js        bundled driver + mysql2 + export surface
--   2. server/ready.lua     kora_sql:ready fan-out + isReady polling helper
--   3. server/commands.lua  /kora_sql console commands (consult ready.lua)
--   4. server/compat/*      pure translation layers, no internal dependents
server_scripts {
    '@kora_lib/init.lua',
    'config.lua',
    'dist/build.js',
    'server/ready.lua',
    'server/commands.lua',
    'server/compat/oxmysql.lua',
    'server/compat/mysql-async.lua',
    'server/compat/ghmattimysql.lua'
}

-- Like oxmysql's release artifact, the committed bundle contains mysql2.
-- FXServer needs neither a yarn builder nor runtime node_modules.
