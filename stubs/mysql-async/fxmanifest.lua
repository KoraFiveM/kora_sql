fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mysql-async'
author 'Jamie'
version '1.0.0'
description 'Drop-in stub: forwards @mysql-async/lib/MySQL.lua includes to qbsql'

-- Fallback for third-party manifests containing
--   shared_script '@mysql-async/lib/MySQL.lua'
-- An `@name/path` include needs a resource literally named `mysql-async`;
-- `provide` alone is not relied on for it (see stubs/oxmysql/README.md). Copy this
-- folder into resources/ and ensure it after kora_sql when a consumer needs it.
-- Do not run mysql-async too.

dependency 'kora_sql'

files {
    'lib/MySQL.lua'
}
