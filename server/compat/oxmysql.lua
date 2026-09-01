-- oxmysql drop-in compatibility.
--
-- `provide 'oxmysql'` in fxmanifest.lua satisfies other resources' dependency
-- checks; it does NOT make exports.oxmysql:query() resolve here. Registering
-- the underlying __cfx_export_oxmysql_<name> event does -- the same identity
-- hijack qbtarget/client/compat/ox-target.lua uses. provideExport is duplicated
-- per compat file because separate Lua chunks can't share a local (a
-- constraint this codebase documents repeatedly).

if not (Config and Config.compat and Config.compat.oxmysql) then return end

local function provideExport(providedResource, exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(providedResource, exportName), function(setCB)
        setCB(func)
    end)
end

-- Which resources have already been warned about the blocking *Sync API, so the
-- warning prints once per resource rather than once per call.
local warnedSync = {}

local function warnSyncOnce(resource)
    if not (Config.compat.warnOnSync) or warnedSync[resource] then return end
    warnedSync[resource] = true
    print(('^3[qbsql:oxmysql-bridge]^7 \'%s\' is using the blocking Sync SQL API, which stalls the '
        .. 'server thread. Migrate to QB.sql.* or the callback form.'):format(resource))
end

-- THE ATTRIBUTION HANDOFF. qbtarget's rule is "call the impl directly so
-- GetInvokingResource() resolves to the real consumer." Here the impl lives in
-- the JS runtime, so a Lua shim MUST cross the boundary -- and JS would then see
-- `qbsql` as the invoker. Fix: capture GetInvokingResource() HERE, at call time
-- (it correctly resolves to the real caller because this function object belongs
-- to qbsql's VM but runs in the caller's invocation context), and forward it as
-- the trailing `invokingResource` argument the JS dataExport wrapper peels off.
--
-- `params` is always normalised to a table before crossing, because the JS
-- wrapper's trailing-argument peeling relies on a stable argument count.
local function asyncCall(jsName)
    return function(query, params, cb)
        local resource = GetInvokingResource() or GetCurrentResourceName()
        exports.qbsql[jsName](exports.qbsql, query, params or {}, cb, resource)
    end
end

-- Blocking variant: build a promise, Await it on a fresh coroutine so the
-- calling thread genuinely blocks (that IS the legacy contract), and return the
-- value. Unavoidable and correct for *Sync compat.
local function syncCall(jsName)
    return function(query, params)
        local resource = GetInvokingResource() or GetCurrentResourceName()
        warnSyncOnce(resource)
        local p = promise.new()
        exports.qbsql[jsName](exports.qbsql, query, params or {}, function(result, err)
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

-- Multi-statement guard. oxmysql lets a single string carry several
-- semicolon-separated statements; we refuse by default (the pool runs with
-- multipleStatements off) because it is a SQL-injection amplifier. Detect a
-- statement-terminating ';' outside string/identifier quotes and refuse loudly.
local function looksMultiStatement(query)
    if type(query) ~= 'string' then return false end
    local inSingle, inDouble, inBacktick = false, false, false
    for i = 1, #query do
        local c = query:sub(i, i)
        if c == "'" and not inDouble and not inBacktick then inSingle = not inSingle
        elseif c == '"' and not inSingle and not inBacktick then inDouble = not inDouble
        elseif c == '`' and not inSingle and not inDouble then inBacktick = not inBacktick
        elseif c == ';' and not inSingle and not inDouble and not inBacktick then
            -- trailing ';' with only whitespace after is fine
            local rest = query:sub(i + 1):gsub('%s', '')
            if #rest > 0 then return true end
        end
    end
    return false
end

local function guarded(fn)
    return function(query, params, cb)
        if not (Config.compat.allowMultipleStatements) and looksMultiStatement(query) then
            local resource = GetInvokingResource() or GetCurrentResourceName()
            print(('^1[qbsql:oxmysql-bridge]^7 multi-statement query refused from \'%s\' -- split it, or set '
                .. '`qbsql_allow_multiple_statements true` and accept the injection amplification. SQL: %s')
                :format(resource, tostring(query):sub(1, 120)))
            if type(cb) == 'function' then cb(nil, 'multi-statement refused') end
            return nil
        end
        return fn(query, params, cb)
    end
end

-- store()/rawExecute() forward straight through; the JS store is in-memory and
-- warns on an unknown handle after a restart rather than silently no-op'ing.
local function store(query)
    return exports.qbsql:store(query)
end

local function rawExecute(handle, params, cb)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    return exports.qbsql:rawExecute(handle, params or {}, cb, resource)
end

local function isReady()
    return exports.qbsql:isReady()
end

-- These are the two exports oxmysql consumers commonly use while booting:
-- isReady gates resource startup and query is the primary data path. Register
-- them explicitly below instead of relying on the bulk compatibility table so
-- the provider always installs the exact __cfx_export_oxmysql_* handlers.
local query = guarded(asyncCall('query'))

-- Registration table. Async names take (query, params, cb); Sync names block
-- and return. query/isReady and transaction/rawExecute/store are special-cased.
local asyncNames = { 'execute', 'scalar', 'single', 'insert', 'update', 'prepare' }
local registrations = {
    querySync = syncCall('query'),
}

for _, name in ipairs(asyncNames) do
    local jsName = name
    registrations[name] = guarded(asyncCall(jsName))
    registrations[name .. 'Sync'] = function(query, params) return syncCall(jsName)(query, params) end
end

registrations.transaction = function(queries, params, cb)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports.qbsql:transaction(queries, params, cb, resource)
end
registrations.transactionSync = function(queries, params)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    warnSyncOnce(resource)
    local p = promise.new()
    exports.qbsql:transaction(queries, params, function(result, err)
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
registrations.prepareSync = registrations.prepareSync or syncCall('prepare')

provideExport('oxmysql', 'query', query)
provideExport('oxmysql', 'isReady', isReady)

for exportName, func in pairs(registrations) do
    provideExport('oxmysql', exportName, func)
end
