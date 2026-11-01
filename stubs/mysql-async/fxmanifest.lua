fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mysql-async'
author 'Jamie'
-- Stock mysql-async is 3.3.2; claim the same so GetResourceMetadata version
-- gates written against it keep passing.
version '3.3.2'
description 'mysql-async compatibility stub (forwards to kora_sql), not affiliated with the original mysql-async'

-- Standalone resource named `mysql-async`. kora_sql does NOT `provide
-- 'mysql-async'` any more, so this stub alone owns the name that a consumer's
--   dependency 'mysql-async'
--   server_script '@mysql-async/lib/MySQL.lua'
-- needs. The `@mysql-async/lib/MySQL.lua` include runs in the CONSUMER's VM and
-- hands off to kora_sql's lib/MySQL.lua (MySQL.Async.*, MySQL.Sync.*,
-- MySQL.ready, ...). The raw exports['mysql-async']:mysql_* calls are served by
-- kora_sql's server/compat/mysql-async.lua; this resource registers none.
--
-- Deploy: copy this folder to resources/[compat]/mysql-async and `ensure` it
-- AFTER kora_sql. Never run the real mysql-async alongside it.

dependency 'kora_sql'

files {
    'lib/MySQL.lua'
}
