fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mysql-async'
author 'Jamie'
version '1.0.0'
description 'Drop-in stub: forwards @mysql-async/lib/MySQL.lua includes to qbsql'

-- Optional fallback for older tooling/deployment scanners that insist on a
-- literal resource directory for third-party manifests containing
--   shared_script '@mysql-async/lib/MySQL.lua'
-- Current FXServer resolves that path through kora_sql's provided identity
-- directly, so normal servers do not need this stub. If required, copy this
-- folder into resources/ and ensure it after kora_sql. Do not run mysql-async too.

dependency 'kora_sql'

files {
    'lib/MySQL.lua'
}
