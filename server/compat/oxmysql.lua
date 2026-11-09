if not (Config and Config.compat and Config.compat.oxmysql) then return end

local function provideExport(providedResource, exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(providedResource, exportName), function(setCB)
        setCB(func)
    end)
end

local warnedSync = {}

local function isCallable(value)
    if type(value) == 'function' then return true end
    if type(value) ~= 'table' then return false end
    if rawget(value, '__cfx_functionReference') then return true end
    local mt = getmetatable(value)
    return mt ~= nil and mt.__call ~= nil
end

local function warnSyncOnce(resource)
    if not Config.compat.warnOnSync or warnedSync[resource] then return end
    warnedSync[resource] = true
    print(('^3[qbsql:oxmysql-bridge]^7 \'%s\' is using the blocking Sync SQL API, which stalls the '
        .. 'server thread. Migrate to Kora.sql.* or the callback form.'):format(resource))
end

local oxName = {
    query = 'oxQuery', single = 'oxSingle', scalar = 'oxScalar', insert = 'oxInsert',
    update = 'oxUpdate', prepare = 'oxPrepare', rawExecute = 'oxRawExecute',
}

local function asyncCall(jsName)
    local target = oxName[jsName] or jsName
    return function(query, params, cb)
        if isCallable(params) and cb == nil then cb, params = params, nil end
        local resource = GetInvokingResource() or GetCurrentResourceName()
        if cb == nil then
            return exports.kora_sql[target](exports.kora_sql, query, params or {}, resource)
        end
        return exports.kora_sql[target](exports.kora_sql, query, params or {}, cb, resource)
    end
end

local function syncCall(jsName)
    return function(query, params)
        local resource = GetInvokingResource() or GetCurrentResourceName()
        warnSyncOnce(resource)
        local p = promise.new()
        exports.kora_sql[oxName[jsName] or jsName](exports.kora_sql, query, params or {}, function(result, err)
            if err then p:reject(err) else p:resolve(result) end
        end, resource)
        local ok, res = pcall(Citizen.Await, p)
        if not ok then
            print(('^1[qbsql:oxmysql-bridge]^7 sync %s failed: %s'):format(jsName, tostring(res)))
            return nil
        end
        return res
    end
end

local function looksMultiStatement(query)
    if type(query) ~= 'string' then return false end
    local inSingle, inDouble, inBacktick = false, false, false
    for i = 1, #query do
        local c = query:sub(i, i)
        if c == "'" and not inDouble and not inBacktick then inSingle = not inSingle
        elseif c == '"' and not inSingle and not inBacktick then inDouble = not inDouble
        elseif c == '`' and not inSingle and not inDouble then inBacktick = not inBacktick
        elseif c == ';' and not inSingle and not inDouble and not inBacktick then
            local rest = query:sub(i + 1):gsub('%s', '')
            if #rest > 0 then return true end
        end
    end
    return false
end

local function multipleStatementsAllowed()
    if Config.compat.allowMultipleStatements then return true end
    local raw = GetConvar('qbsql_allow_multiple_statements', '')
    return raw == 'true' or raw == '1' or raw == 'yes'
end

local function guarded(fn)
    return function(query, params, cb)
        if not multipleStatementsAllowed() and looksMultiStatement(query) then
            local resource = GetInvokingResource() or GetCurrentResourceName()
            print(('^1[qbsql:oxmysql-bridge]^7 multi-statement query refused from \'%s\' -- split it, or set '
                .. '`qbsql_allow_multiple_statements true` and accept the injection amplification. SQL: %s')
                :format(resource, tostring(query):sub(1, 120)))
            if cb == nil and isCallable(params) then cb = params end
            if isCallable(cb) then cb(nil, 'multi-statement refused') end
            return nil
        end
        return fn(query, params, cb)
    end
end

local function store(query, cb)
    if isCallable(cb) then cb(query) end
    return query
end

local function rawExecute(handle, params, cb)
    if isCallable(params) and cb == nil then cb, params = params, nil end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    if cb == nil then return exports.kora_sql:oxRawExecute(handle, params or {}, resource) end
    return exports.kora_sql:oxRawExecute(handle, params or {}, cb, resource)
end

local function isReady()
    return exports.kora_sql:isReady()
end

local function awaitConnection()
    while not exports.kora_sql:isReady() do Wait(0) end
    return true
end

local function startTransaction(callback)
    assert(isCallable(callback), 'startTransaction requires a callback')
    local resource = GetInvokingResource() or GetCurrentResourceName()
    return exports.kora_sql:startTransaction(callback, resource)
end

local query = guarded(asyncCall('query'))

local asyncNames = { 'scalar', 'single', 'insert', 'update', 'prepare' }
local registrations = {
    querySync = syncCall('query'),
    execute = query,
    executeSync = syncCall('query'),
    fetch = query,
    fetchSync = syncCall('query'),
}

for _, name in ipairs(asyncNames) do
    registrations[name] = guarded(asyncCall(name))
    registrations[name .. 'Sync'] = syncCall(name)
end

registrations.transaction = function(queries, params, cb)
    if isCallable(params) and cb == nil then cb, params = params, nil end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports.kora_sql:transaction(queries, params or {}, cb, resource)
end
registrations.transactionSync = function(queries, params)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    warnSyncOnce(resource)
    local p = promise.new()
    exports.kora_sql:transaction(queries, params, function(result, err)
        if err then p:reject(err) else p:resolve(result) end
    end, resource)
    local ok, res = pcall(Citizen.Await, p)
    if not ok then return false end
    return res
end
registrations.rawExecute = rawExecute
registrations.rawExecuteSync = function(handle, params)
    local p = promise.new()
    rawExecute(handle, params, function(result, err)
        if err then p:reject(err) else p:resolve(result) end
    end)
    local ok, res = pcall(Citizen.Await, p)
    if not ok then return nil end
    return res
end
registrations.store = store
registrations.awaitConnection = awaitConnection
registrations.awaitConnectionSync = awaitConnection
registrations.isReadySync = isReady
registrations.startTransaction = startTransaction
registrations.startTransactionSync = startTransaction
registrations.storeSync = store

provideExport('oxmysql', 'query', query)
provideExport('oxmysql', 'isReady', isReady)

for exportName, func in pairs(registrations) do
    provideExport('oxmysql', exportName, func)
end
