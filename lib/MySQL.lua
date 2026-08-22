-- '@qbsql/lib/MySQL.lua' -- the mysql-async / oxmysql `MySQL` global.
--
-- A consumer written against mysql-async or oxmysql's Lua wrapper includes this
-- with `shared_script '@qbsql/lib/MySQL.lua'` (or, for zero-touch drop-in, via
-- the stubs/ folders that forward here). It builds the `MySQL` global in that
-- consumer's own VM, backed by exports.qbsql.
--
-- NOTE ON ATTRIBUTION: because this file runs in the CONSUMER's VM,
-- GetCurrentResourceName() here already IS the real caller -- no
-- GetInvokingResource() dance is needed (unlike the compat/oxmysql.lua shim,
-- which runs in qbsql's VM and must capture the invoker per-call).

MySQL = MySQL or {}

local resourceName = GetCurrentResourceName()

local function call(jsName, query, params, cb)
    exports.qbsql[jsName](exports.qbsql, query, params or {}, cb, resourceName)
end

local function sync(jsName, query, params)
    local p = promise.new()
    call(jsName, query, params, function(result, err)
        if err then p:reject(err) else p:resolve(result) end
    end)
    local ok, res = pcall(Citizen.Await, p)
    if not ok then return nil end
    return res
end

-- MySQL.ready(cb) -- run cb once the pool is up.
function MySQL.ready(cb)
    Citizen.CreateThread(function()
        while not exports.qbsql:isReady() do Wait(50) end
        if cb then cb() end
    end)
end

-- Async table (callback-style).
MySQL.Async = {
    fetchAll    = function(q, p, cb) call('query', q, p, cb) end,
    fetchScalar = function(q, p, cb) call('scalar', q, p, cb) end,
    fetchSingle = function(q, p, cb) call('single', q, p, cb) end,
    execute     = function(q, p, cb) call('update', q, p, cb) end,
    insert      = function(q, p, cb) call('insert', q, p, cb) end,
    store       = function(q, cb) local h = exports.qbsql:store(q); if cb then cb(h) end end,
    transaction = function(qs, p, cb)
        if type(p) == 'function' then cb, p = p, nil end
        exports.qbsql:transaction(qs, p, cb, resourceName)
    end,
}

-- Sync table (blocking).
MySQL.Sync = {
    fetchAll    = function(q, p) return sync('query', q, p) end,
    fetchScalar = function(q, p) return sync('scalar', q, p) end,
    fetchSingle = function(q, p) return sync('single', q, p) end,
    execute     = function(q, p) return sync('update', q, p) end,
    insert      = function(q, p) return sync('insert', q, p) end,
    store       = function(q) return exports.qbsql:store(q) end,
    transaction = function(qs, p)
        local pr = promise.new()
        exports.qbsql:transaction(qs, p, function(result, err)
            if err then pr:reject(err) else pr:resolve(result) end
        end, resourceName)
        local ok, res = pcall(Citizen.Await, pr)
        if not ok then return false end
        return res
    end,
}

-- oxmysql-era MySQL.query / MySQL.scalar / ... with a `.await` sub-field, plus
-- direct callable form. `MySQL.query(sql, params, cb)` OR `MySQL.query.await(sql, params)`.
local function makeDual(jsName)
    return setmetatable({
        await = function(q, p) return sync(jsName, q, p) end,
    }, {
        __call = function(_, q, p, cb) call(jsName, q, p, cb) end,
    })
end

MySQL.query       = makeDual('query')
MySQL.scalar      = makeDual('scalar')
MySQL.single      = makeDual('single')
MySQL.insert      = makeDual('insert')
MySQL.update      = makeDual('update')
MySQL.prepare     = makeDual('execute')
MySQL.rawExecute  = makeDual('execute')

MySQL.transaction = setmetatable({
    await = function(qs, p)
        local pr = promise.new()
        exports.qbsql:transaction(qs, p, function(result, err)
            if err then pr:reject(err) else pr:resolve(result) end
        end, resourceName)
        local ok, res = pcall(Citizen.Await, pr)
        if not ok then return false end
        return res
    end,
}, {
    __call = function(_, qs, p, cb)
        if type(p) == 'function' then cb, p = p, nil end
        exports.qbsql:transaction(qs, p, cb, resourceName)
    end,
})
