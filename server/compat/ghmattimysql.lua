if not (Config and Config.compat and Config.compat.ghmattimysql) then return end

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

local function syncCall(jsName)
    return function(query, params)
        local resource = GetInvokingResource() or GetCurrentResourceName()
        local p = promise.new()
        exports.kora_sql[jsName](exports.kora_sql, query, params or {}, function(result, err)
            if err then p:reject(err) else p:resolve(result) end
        end, resource)
        local ok, res = pcall(Citizen.Await, p)
        if not ok then return nil end
        return res
    end
end

local registrations = {
    execute     = asyncCall('query'),
    executeSync = syncCall('query'),
    scalar      = asyncCall('scalar'),
    scalarSync  = syncCall('scalar'),
}

registrations.transaction = function(queries, params, cb)
    if cb == nil and isCallable(params) then cb, params = params, nil end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports.kora_sql:transaction(queries, params, cb, resource)
end

for exportName, func in pairs(registrations) do
    provideExport('ghmattimysql', exportName, func)
end
