-- Lua-side behaviour ONLY. Everything the JS pool needs at boot (connection
-- string, pool sizes, cache sizes, flush timing) is read from CONVARS in
-- server/js/config.js, because the Node host cannot read this table. See
-- AGENTS.md "Configuration split" for why.

Config = Config or {}

Config.compat = {
    oxmysql = true,            -- register the exports.oxmysql:* identity hijack
    mysqlAsync = true,         -- register exports['mysql-async']:* and the MySQL global
    ghmattimysql = true,       -- register exports.ghmattimysql:*
    installMySQLGlobal = true, -- create the mysql-async `MySQL` global in a consumer VM that loads @kora_sql/lib/MySQL.lua
    warnOnSync = true,         -- print once per calling resource when a blocking *Sync API is used
}

Config.sql = {
    awaitTimeout = 30000,      -- ms Kora.sql.* waits for a query before rejecting
    readyTimeout = 60000,      -- ms Kora.sql.ready() waits for the pool before giving up
}

-- Registers kora_sql's Lua-side settings with kora_lib. Pool boot options remain
-- server convars because the Node host cannot read this Lua table.
Config.compat.oxmysql = Kora.config.boolean(Config.compat.oxmysql, { label = 'Support oxmysql scripts', advanced = false })
Config.compat.mysqlAsync = Kora.config.boolean(Config.compat.mysqlAsync, { label = 'Support mysql-async scripts', advanced = false })
Config.compat.ghmattimysql = Kora.config.boolean(Config.compat.ghmattimysql, { label = 'Support ghmattimysql scripts', advanced = false })
Config.compat.installMySQLGlobal = Kora.config.boolean(Config.compat.installMySQLGlobal, { label = 'Legacy MySQL global preference', advanced = true })
Config.compat.warnOnSync = Kora.config.boolean(Config.compat.warnOnSync, { label = 'Warn about blocking database calls', advanced = true })
Config.sql.awaitTimeout = Kora.config.integer(Config.sql.awaitTimeout, { label = 'Query wait preference (milliseconds)', advanced = true, min = 0 })
Config.sql.readyTimeout = Kora.config.integer(Config.sql.readyTimeout, { label = 'Database readiness wait preference (milliseconds)', advanced = true, min = 0 })
Config = Kora.config.adopt(Config, { descriptions = {
    ['compat.oxmysql'] = 'Allow scripts using oxmysql database exports to use kora_sql.',
    ['compat.mysqlAsync'] = 'Allow scripts using mysql-async database exports to use kora_sql.',
    ['compat.ghmattimysql'] = 'Allow scripts using ghmattimysql database exports to use kora_sql.',
    ['compat.installMySQLGlobal'] = 'Retained compatibility preference. The current MySQL include installs its global without reading this setting.',
    ['compat.warnOnSync'] = 'Log a warning once per calling resource when it uses an oxmysql blocking call.',
    ['sql.awaitTimeout'] = 'Retained query timeout preference. The current database query helper does not read this setting.',
    ['sql.readyTimeout'] = 'Readiness wait used by the SQL include in its calling resource. Editing kora_sql here does not change other resources that have their own Config table.',
} })
