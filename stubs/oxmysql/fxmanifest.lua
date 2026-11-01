fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'oxmysql'
author 'Jamie'
-- kora_sql does not `provide 'oxmysql'`, so consumers that gate on
-- GetResourceMetadata('oxmysql', 'version', 0) (ox_inventory:
-- lib.checkDependency('oxmysql', '2.7.3')) read THIS value. 2.7.3 is the lowest version ox_inventory accepts;
-- we claim exactly that, not the current oxmysql release, because the MySQL.*
-- surface this placeholder forwards (query/single/scalar/insert/update/prepare/
-- rawExecute/transaction/ready/startTransaction) is what kora_sql implements
-- and what the tests pin. Bump deliberately, only after checking newer oxmysql
-- additions against lib/MySQL.lua.
version '2.7.3'
description 'oxmysql compatibility placeholder (forwards to kora_sql), not affiliated with Overextended'

-- Real FXServer needs a resource literally named `oxmysql` for a consumer's
-- `dependency 'oxmysql'` or `server_script '@oxmysql/lib/MySQL.lua'` (an
-- `@name/path` include resolves by resource name). This is the only resource
-- that owns the name (see README.md). Deploy this folder as
-- resources/[compat]/oxmysql and ensure it AFTER kora_sql. Never run real
-- oxmysql alongside it.

dependency 'kora_sql'

files {
    'lib/MySQL.lua'
}
