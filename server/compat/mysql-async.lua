-- mysql-async drop-in compatibility (the exports.'mysql-async':* surface).
--
-- Most mysql-async consumers use the `MySQL` global (see lib/MySQL.lua). A few
-- call the raw exports; this file provides those via the same identity hijack.
-- The MySQL global itself is installed per-consumer by lib/MySQL.lua, not here,
-- because it must live in the consumer's VM (see that file's attribution note).

if not (Config and Config.compat and Config.compat.mysqlAsync) then return end

local function provideExport(providedResource, exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(providedResource, exportName), function(setCB)
        setCB(func)
    end)
end

local function asyncCall(jsName)
    return function(query, params, cb)
        local resource = GetInvokingResource() or GetCurrentResourceName()
        exports.kora_sql[jsName](exports.kora_sql, query, params or {}, cb, resource)
    end
end

-- mysql-async's flat export names map onto our executors.
local registrations = {
    mysql_fetch_all    = asyncCall('query'),
    mysql_fetch_scalar = asyncCall('scalar'),
    mysql_insert       = asyncCall('insert'),
    mysql_execute      = asyncCall('update'),
}

registrations.mysql_transaction = function(queries, params, cb)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports.kora_sql:transaction(queries, params, cb, resource)
end

-- Stock mysql-async also exports mysql_store(query, cb) -> handle (consumed by
-- MySQL.Sync/Async.store users via the raw export) and is_ready().
registrations.mysql_store = function(query, cb)
    return exports.kora_sql:store(query, cb)
end
registrations.is_ready = function()
    return exports.kora_sql:isReady()
end

for exportName, func in pairs(registrations) do
    provideExport('mysql-async', exportName, func)
end
