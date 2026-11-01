-- Forwarder. A consumer's `server_script '@mysql-async/lib/MySQL.lua'` lands here;
-- we immediately hand off to kora_sql's real implementation, which builds the
-- MySQL global in the consumer's VM. Keeping this a pure forward means there is
-- one implementation to maintain (kora_sql/lib/MySQL.lua), not two.
--
-- We cannot `shared_script '@kora_sql/lib/MySQL.lua'` from HERE (that would run it
-- in the stub's VM, not the consumer's). Instead the consumer that included us
-- gets kora_sql's file loaded into ITS VM via the load below.
local chunk = LoadResourceFile('kora_sql', 'lib/MySQL.lua')
assert(chunk, '[mysql-async-stub] could not read kora_sql/lib/MySQL.lua -- is kora_sql present?')
local fn = assert(load(chunk, '@kora_sql/lib/MySQL.lua'))
fn()
