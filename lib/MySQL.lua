-- oxmysql/mysql-async compatible MySQL global for consumer resources.
-- This file runs inside the consumer VM, so resource attribution is explicit
-- and every callback/promise is created in the same Lua runtime as its caller.

local promise = promise
local Await = Citizen.Await
local resourceName = GetCurrentResourceName()

local options = { return_callback_errors = false }
for i = 1, GetNumResourceMetadata(resourceName, 'mysql_option') do
    local option = GetResourceMetadata(resourceName, 'mysql_option', i - 1)
    options[option] = true
end

local function isCallable(value)
    if type(value) == 'function' then return true end
    if type(value) ~= 'table' then return false end
    if rawget(value, '__cfx_functionReference') then return true end
    local mt = getmetatable(value)
    return mt ~= nil and mt.__call ~= nil
end

local queryStore = {}

local function safeArgs(query, parameters, cb, transaction)
    local queryType = type(query)
    if queryType == 'number' then
        query = queryStore[query]
        assert(query, 'First argument received invalid query store reference')
    elseif transaction then
        if queryType ~= 'table' then
            error(("First argument expected table, received '%s'"):format(queryType))
        end
    elseif queryType ~= 'string' then
        error(("First argument expected string, received '%s'"):format(queryType))
    end

    if parameters ~= nil then
        local parameterType = type(parameters)
        if parameterType ~= 'table' and not isCallable(parameters) then
            error(("Second argument expected table or function, received '%s'"):format(parameterType))
        end
        if isCallable(parameters) then cb, parameters = parameters, nil end
    end

    if cb ~= nil and not isCallable(cb) then
        error(("Third argument expected function, received '%s'"):format(type(cb)))
    end
    return query, parameters, cb
end

local function call(method, query, parameters, cb)
    exports.qbsql[method](exports.qbsql, query, parameters or {}, function(result, err)
        if not cb then return end
        if options.return_callback_errors then cb(result, err) else cb(result) end
    end, resourceName)
end

local function await(method, query, parameters)
    local p = promise.new()
    exports.qbsql[method](exports.qbsql, query, parameters or {}, function(result, err)
        if err then return p:reject(err) end
        p:resolve(result)
    end, resourceName)
    return Await(p)
end

local MySQL = setmetatable(MySQL or {}, {
    __index = function(_, index)
        return function(...)
            return exports.qbsql[index](exports.qbsql, ...)
        end
    end,
})

local methodMt = {
    __call = function(self, query, parameters, cb)
        query, parameters, cb = safeArgs(query, parameters, cb, self.method == 'transaction')
        if self.method == 'transaction' then
            exports.qbsql:transaction(query, parameters or {}, function(result, err)
                if cb then
                    if options.return_callback_errors then cb(result, err) else cb(result) end
                end
            end, resourceName)
            return
        end
        return call(self.method, query, parameters, cb)
    end,
}

for _, method in ipairs({
    'scalar', 'single', 'query', 'insert', 'update', 'prepare', 'transaction', 'rawExecute',
}) do
    MySQL[method] = setmetatable({
        method = method,
        await = function(query, parameters)
            query, parameters = safeArgs(query, parameters, nil, method == 'transaction')
            return await(method, query, parameters)
        end,
    }, methodMt)
end

local aliases = {
    fetchAll = 'query',
    fetchScalar = 'scalar',
    fetchSingle = 'single',
    insert = 'insert',
    execute = 'update',
    transaction = 'transaction',
    prepare = 'prepare',
}

local aliasMt = {
    __index = function(self, key)
        local methodName = aliases[key]
        if methodName then
            local method = MySQL[methodName]
            MySQL.Async[key] = method
            MySQL.Sync[key] = method.await
            aliases[key] = nil
            return self[key]
        end
    end,
}

local function addStore(query, cb)
    assert(type(query) == 'string', 'The SQL Query must be a string')
    local handle = #queryStore + 1
    queryStore[handle] = query
    if cb then cb(handle) end
    return handle
end

MySQL.Sync = setmetatable({ store = addStore }, aliasMt)
MySQL.Async = setmetatable({ store = addStore }, aliasMt)

local function onReady(cb)
    exports.qbsql:awaitConnection()
    if cb then cb() end
    return true
end

MySQL.ready = setmetatable({ await = onReady }, {
    __call = function(_, cb)
        Citizen.CreateThreadNow(function() onReady(cb) end)
    end,
})

function MySQL.startTransaction(cb)
    assert(isCallable(cb), 'startTransaction requires a callback')
    return exports.qbsql:startTransaction(cb, resourceName)
end

_ENV.MySQL = MySQL
