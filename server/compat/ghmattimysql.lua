-- ghmattimysql drop-in compatibility. A small surface -- execute/scalar +
-- transaction and their Sync variants -- but cheap to provide and it keeps
-- older resources working unmodified.

if not (Config and Config.compat and Config.compat.ghmattimysql) then return end

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
    execute     = asyncCall('query'),   -- ghmatti execute returns rows
    executeSync = syncCall('query'),
    scalar      = asyncCall('scalar'),
    scalarSync  = syncCall('scalar'),
}

registrations.transaction = function(queries, params, cb)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports.kora_sql:transaction(queries, params, cb, resource)
end

for exportName, func in pairs(registrations) do
    provideExport('ghmattimysql', exportName, func)
end
