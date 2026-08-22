-- Forwarder. A consumer's `shared_script '@oxmysql/lib/MySQL.lua'` lands here;
-- we immediately hand off to qbsql's real implementation, which builds the
-- MySQL global in the consumer's VM. Keeping this a pure forward means there is
-- one implementation to maintain (qbsql/lib/MySQL.lua), not two.
--
-- We cannot `shared_script '@qbsql/lib/MySQL.lua'` from HERE (that would run it
-- in the stub's VM, not the consumer's). Instead the consumer that included us
-- gets qbsql's file loaded into ITS VM via the load below.
local chunk = LoadResourceFile('qbsql', 'lib/MySQL.lua')
assert(chunk, '[oxmysql-stub] could not read qbsql/lib/MySQL.lua -- is qbsql present?')
local fn = assert(load(chunk, '@qbsql/lib/MySQL.lua'))
fn()
