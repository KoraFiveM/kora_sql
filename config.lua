-- Lua-side behaviour ONLY. Everything the JS pool needs at boot (connection
-- string, pool sizes, cache sizes, flush timing) is read from CONVARS in
-- server/js/config.js, because the Node host cannot read this table. See
-- AGENTS.md "Configuration split" for why.

Config = Config or {}

Config.compat = {
    oxmysql = true,            -- register the exports.oxmysql:* identity hijack
    mysqlAsync = true,         -- register exports['mysql-async']:* and the MySQL global
    ghmattimysql = true,       -- register exports.ghmattimysql:*
    installMySQLGlobal = true, -- create the mysql-async `MySQL` global in a consumer VM that loads @qbsql/lib/MySQL.lua
    warnOnSync = true,         -- print once per calling resource when a blocking *Sync API is used
}

Config.sql = {
    awaitTimeout = 30000,      -- ms QB.sql.* waits for a query before rejecting
    readyTimeout = 60000,      -- ms QB.sql.ready() waits for the pool before giving up
}

-- Registers qbsql's Lua-side settings with qblib. Pool boot options remain
-- server convars because the Node host cannot read this Lua table.
Config = QB.config.adopt(Config)
