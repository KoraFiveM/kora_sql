fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'oxmysql'
author 'Jamie'
-- GetResourceMetadata('oxmysql', 'version', 0) does NOT follow `provide`, so
-- consumers that gate on it (ox_inventory: lib.checkDependency('oxmysql',
-- '2.7.3')) read THIS value. 2.7.3 is the lowest version ox_inventory accepts;
-- we claim exactly that, not the current oxmysql release, because the MySQL.*
-- surface this placeholder forwards (query/single/scalar/insert/update/prepare/
-- rawExecute/transaction/ready/startTransaction) is what kora_sql implements
-- and what the tests pin. Bump deliberately, only after checking newer oxmysql
-- additions against lib/MySQL.lua.
version '2.7.3'
description 'oxmysql compatibility placeholder (forwards to kora_sql), not affiliated with Overextended'

-- Real FXServer needs a resource literally named `oxmysql` for a consumer's
-- `server_script '@oxmysql/lib/MySQL.lua'` (an `@name/path` include resolves by
-- resource name; `provide` only satisfies dependency checks, ~90% confidence --
-- verify on a scratch server, see README.md). Deploy this folder as
-- resources/[compat]/oxmysql and ensure it AFTER kora_sql. Never run real
-- oxmysql alongside it.

dependency 'kora_sql'

files {
    'lib/MySQL.lua'
}
