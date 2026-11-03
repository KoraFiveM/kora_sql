-- oxmysql drop-in compatibility.
--
-- kora_sql does NOT `provide 'oxmysql'`; the stubs/oxmysql placeholder owns that
-- name (needed for `dependency 'oxmysql'` and `@oxmysql/lib/MySQL.lua`). Registering
-- the underlying __cfx_export_oxmysql_<name> event is what makes
-- exports.oxmysql:query() resolve, with or without the placeholder -- the same
-- identity hijack kora_target/client/compat/ox-target.lua uses. provideExport is duplicated
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

-- THE ATTRIBUTION HANDOFF. kora_target's rule is "call the impl directly so
-- GetInvokingResource() resolves to the real consumer." Here the impl lives in
-- the JS runtime, so a Lua shim MUST cross the boundary -- and JS would then see
-- `kora_sql` as the invoker. Fix: capture GetInvokingResource() HERE, at call time
-- (it correctly resolves to the real caller because this function object belongs
-- to kora_sql's VM but runs in the caller's invocation context), and forward it as
-- the trailing `invokingResource` argument the JS dataExport wrapper peels off.
--
-- `params` is always normalised to a table before crossing, because the JS
-- wrapper's trailing-argument peeling relies on a stable argument count.
--
-- The oxmysql path calls the JS `ox*` export variants (see exports.js), which
-- apply oxmysql's typeCast when the `kora_sql_ox_typecast` convar is on.
-- Without a callback the argument is omitted entirely rather than passed as
-- nil, so no hole sits between `params` and `resource` (the JS side also
-- tolerates one).
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

-- Blocking variant: build a promise, Await it on a fresh coroutine so the
-- calling thread genuinely blocks (that IS the legacy contract), and return the
-- value. Unavoidable and correct for *Sync compat.
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

-- Same convar and truthy parsing as server/js/config.js getBoolConvar: only the
-- literal strings 'true', '1' and 'yes' enable it; unset/anything else is off.
-- Config.compat.allowMultipleStatements (never set by config.lua) can still force
-- it on. Read per call so a runtime `set` is honoured; GetConvar is cheap.
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
            if type(cb) == 'function' then cb(nil, 'multi-statement refused') end
            return nil
        end
        return fn(query, params, cb)
    end
end

-- Current oxmysql's store compatibility export returns the SQL string itself;
-- rawExecute accepts strings, so retain that exact observable contract. kora_sql's
-- own numeric store handles remain available through exports.kora_sql:store.
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

-- Parks on kora_sql's ready latch (server/ready.lua) instead of calling the
-- cross-runtime isReady export every frame (F#272). Same semantics: no timeout.
local function awaitConnection()
    if Ready and Ready.await then return Ready.await(false) end
    while not exports.kora_sql:isReady() do Wait(50) end
    return true
end

local function startTransaction(callback)
    assert(isCallable(callback), 'startTransaction requires a callback')
    local resource = GetInvokingResource() or GetCurrentResourceName()
    return exports.kora_sql:startTransaction(callback, resource)
end

-- These are the two exports oxmysql consumers commonly use while booting:
-- isReady gates resource startup and query is the primary data path. Register
-- them explicitly below instead of relying on the bulk compatibility table so
-- the provider always installs the exact __cfx_export_oxmysql_* handlers.
local query = guarded(asyncCall('query'))

-- Registration table. Async names take (query, params, cb); Sync names block
-- and return. query/isReady and transaction/rawExecute/store are special-cased.
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
