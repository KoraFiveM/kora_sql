if not (Config and Config.compat and Config.compat.mysqlAsync) then return end

local function provideExport(providedResource, exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(providedResource, exportName), function(setCB)
        setCB(func)
    end)
end

local function isCallable(value)
    if type(value) == 'function' then return true end
    if type(value) ~= 'table' then return false end
    if rawget(value, '__cfx_functionReference') then return true end
    local mt = getmetatable(value)
    return mt ~= nil and mt.__call ~= nil
end

local function asyncCall(jsName)
    return function(query, params, cb)
        if cb == nil and isCallable(params) then cb, params = params, nil end
        local resource = GetInvokingResource() or GetCurrentResourceName()
        exports.kora_sql[jsName](exports.kora_sql, query, params or {}, cb, resource)
    end
end

local registrations = {
    mysql_fetch_all    = asyncCall('query'),
    mysql_fetch_scalar = asyncCall('scalar'),
    mysql_insert       = asyncCall('insert'),
    mysql_execute      = asyncCall('update'),
}

registrations.mysql_transaction = function(queries, params, cb)
    if cb == nil and isCallable(params) then cb, params = params, nil end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports.kora_sql:transaction(queries, params, cb, resource)
end

registrations.mysql_store = function(query, cb)
    return exports.kora_sql:store(query, cb)
end
registrations.is_ready = function()
    return exports.kora_sql:isReady()
end

for exportName, func in pairs(registrations) do
    provideExport('mysql-async', exportName, func)
end
