fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'oxmysql'
author 'Jamie'
version '1.0.0'
description 'Drop-in stub: forwards @oxmysql/lib/MySQL.lua includes to qbsql'

-- Optional fallback for older tooling/deployment scanners that insist on a
-- literal resource directory for third-party manifests containing
--   shared_script '@oxmysql/lib/MySQL.lua'
-- Current FXServer resolves that path through qbsql's provided identity
-- directly, so normal servers do not need this stub. If required, copy this
-- folder into resources/ and ensure it after qbsql. Do not run real oxmysql too.

dependency 'qbsql'

files {
    'lib/MySQL.lua'
}
