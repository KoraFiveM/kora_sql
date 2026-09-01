fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'qbsql'
author 'Jamie'
version '1.0.0'
description 'High-throughput MySQL driver for FiveM with write coalescing and oxmysql/mysql-async compatibility'

-- `provide` only satisfies ANOTHER resource's `dependency`/`dependencies`
-- check. It does NOT make exports.oxmysql:query() resolve here -- that
-- additionally requires registering the underlying __cfx_export_oxmysql_query
-- event, which server/compat/oxmysql.lua does via its provideExport() helper
-- (same identity-hijack technique as qbtarget/client/compat/ox-target.lua).
provide 'oxmysql'
provide 'mysql-async'
provide 'ghmattimysql'

files {
    'init.lua',       -- '@qbsql/init.lua' -- installs QB.sql.* into a consumer VM
    'lib/MySQL.lua'   -- '@qbsql/lib/MySQL.lua' -- the mysql-async/oxmysql `MySQL` global
}

shared_scripts {
    'config.lua'
}

-- Load order here is deliberately NOT load-bearing, and that is the design
-- goal: the JS entry registers exports.qbsql:* at its own load time, and every
-- Lua file below resolves `exports.qbsql` LAZILY inside each call rather than
-- caching a reference at load time. FXServer runs the Lua and Node hosts
-- separately, so a load-time capture across that boundary is exactly the kind
-- of thing that works on one build and breaks on the next. Listed explicitly
-- (never globbed) so the intended sequence is documented, not implied by
-- alphabetical glob expansion.
--   1. dist/build.js        bundled driver + mysql2 + export surface
--   2. server/ready.lua     qbsql:ready fan-out + isReady polling helper
--   3. server/commands.lua  /qbsql console commands (consult ready.lua)
--   4. server/compat/*      pure translation layers, no internal dependents
server_scripts {
    'dist/build.js',
    'server/ready.lua',
    'server/commands.lua',
    'server/compat/oxmysql.lua',
    'server/compat/mysql-async.lua',
    'server/compat/ghmattimysql.lua'
}

-- Like oxmysql's release artifact, the committed bundle contains mysql2.
-- FXServer needs neither a yarn builder nor runtime node_modules.
