-- Forwarder. A consumer's `shared_script '@oxmysql/lib/MySQL.lua'` lands here;
-- we immediately hand off to kora_sql's real implementation, which builds the
-- MySQL global in the consumer's VM. Keeping this a pure forward means there is
-- one implementation to maintain (kora_sql/lib/MySQL.lua), not two.
--
-- This file already runs in the consumer's VM (it was included by the consumer's
-- manifest), so GetCurrentResourceName() inside kora_sql's file is the consumer,
-- which keeps slow-query attribution correct. We just load kora_sql's source here.
local chunk = LoadResourceFile('kora_sql', 'lib/MySQL.lua')
assert(chunk, '[oxmysql-stub] could not read kora_sql/lib/MySQL.lua -- is kora_sql present?')
local fn = assert(load(chunk, '@kora_sql/lib/MySQL.lua'))
fn()
