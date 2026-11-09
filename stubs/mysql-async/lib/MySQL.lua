local chunk = LoadResourceFile('kora_sql', 'lib/MySQL.lua')
assert(chunk, '[mysql-async-stub] could not read kora_sql/lib/MySQL.lua -- is kora_sql present?')
local fn = assert(load(chunk, '@kora_sql/lib/MySQL.lua'))
fn()
