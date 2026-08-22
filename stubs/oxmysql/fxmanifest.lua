fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'oxmysql'
author 'Jamie'
version '1.0.0'
description 'Drop-in stub: forwards @oxmysql/lib/MySQL.lua includes to qbsql'

-- This stub exists ONLY to satisfy third-party manifests that contain
--   shared_script '@oxmysql/lib/MySQL.lua'
-- FiveM resolves that '@oxmysql/...' path against a REAL resource directory
-- named `oxmysql` -- no export/identity-hijack trick can reach a file include.
-- So we ship a real resource named `oxmysql` whose lib/MySQL.lua simply pulls
-- in qbsql's implementation. Copy this folder into resources/ (out of the
-- stubs/ tree) and `ensure` it AFTER qbsql. Do NOT run a real oxmysql too.

dependency 'qbsql'

files {
    'lib/MySQL.lua'
}
