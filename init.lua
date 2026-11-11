assert(type(IsDuplicityVersion) ~= 'function' or IsDuplicityVersion(), '@kora_sql/init.lua is server-only: list it in server_scripts, not shared/client scripts.')
assert(Kora, '@kora_sql/init.lua must be loaded AFTER @kora_lib/init.lua (add its shared_script first).')

Kora.sql = Kora.sql or {}

Kora.sql.NULL = '\0kora_sql:null\0'

local driver = exports.kora_sql

local function awaitTimeoutMs()
    local ms = Config and type(Config.sql) == 'table' and tonumber(Config.sql.awaitTimeout)
    if ms and ms > 0 then return ms end
    return nil
end

local pendingWaits = {}
local watchdogRunning = false
local function startWatchdog()
    if watchdogRunning then return end
    watchdogRunning = true
    Citizen.CreateThread(function()
        while next(pendingWaits) do
            Wait(100)
            local now = GetGameTimer()
            local expired = {}
            for token, w in pairs(pendingWaits) do
                if now >= w.deadline then expired[#expired + 1] = token end
            end
            for _, token in ipairs(expired) do
                local w = pendingWaits[token]
                pendingWaits[token] = nil
                if w then w.expire() end
            end
        end
        watchdogRunning = false
    end)
end

local NO_AWAIT_TIMEOUT = {
    awaitTables = true, ensureTable = true, ensureTables = true,
    upsert = true, transaction = true, transactionChecked = true,
    awaitCheckedOperation = true, awaitCheckedOperations = true,
}

local function await(name, ...)
    local args = { ... }
    local token = {}
    local p = promise.new()
    local settled = false
    args[#args + 1] = function(result, err)
        if settled then return end
        settled = true
        pendingWaits[token] = nil
        if err then
            p:reject(err)
        else
            p:resolve(result)
        end
    end
    local called, callErr = pcall(function() driver[name](driver, table.unpack(args)) end)
    if not called then return nil, tostring(callErr) end
    local limit = not NO_AWAIT_TIMEOUT[name] and awaitTimeoutMs() or nil
    if limit and not settled and type(GetGameTimer) == 'function' and Citizen and type(Citizen.CreateThread) == 'function' then
        pendingWaits[token] = {
            deadline = GetGameTimer() + limit,
            expire = function()
                if settled then return end
                settled = true
                p:reject(('kora_sql: no reply to %s within %dms; the statement may still complete'):format(name, limit))
            end,
        }
        startWatchdog()
    end
    local ok, res = pcall(Citizen.Await, p)
    if not ok then
        return nil, tostring(res)
    end
    return res
end

local function driverReady()
    local ok, ready = pcall(function() return exports.kora_sql:isReady() end)
    return ok and ready == true
end

function Kora.sql.ready(timeoutMs)
    if driverReady() then return true end
    local deadline = GetGameTimer() + (timeoutMs or (Config and Config.sql and Config.sql.readyTimeout) or 60000)
    while not driverReady() do
        if GetGameTimer() > deadline then return false, 'kora_sql not ready within timeout' end
        Wait(50)
    end
    return true
end

function Kora.sql.query(sql, params)    return await('query', sql, params) end
function Kora.sql.single(sql, params)   return await('single', sql, params) end
function Kora.sql.scalar(sql, params)   return await('scalar', sql, params) end
function Kora.sql.execute(sql, params)  return await('execute', sql, params) end
function Kora.sql.insert(sql, params)   return await('insert', sql, params) end
function Kora.sql.update(sql, params)   return await('update', sql, params) end
function Kora.sql.batch(statements)     return await('batch', statements) end
function Kora.sql.transaction(a, b)     return await('transaction', a, b) end
function Kora.sql.transactionChecked(statements, operation)
    if operation then return await('transactionChecked', statements, operation) end
    return await('transactionChecked', statements)
end

function Kora.sql.awaitCheckedOperation(key, fingerprint)
    return await('awaitCheckedOperation', key, fingerprint)
end

function Kora.sql.awaitCheckedOperations(prefix)
    return await('awaitCheckedOperations', prefix)
end
function Kora.sql.upsert(table_, key, rows, opts) return await('upsert', table_, key, rows, opts) end
---Creates the table if missing, otherwise adds any missing columns, keys and foreign keys.
---Existing columns are never altered; differences come back in `report.warnings`.
---@param spec table `name`, `columns`, and optionally `primary`, `indexes`, `foreign`, `seed`, `engine`, `charset`, `collate`.
---@return table? report `{ table, created, added_columns, added_indexes, added_fks, seeded, warnings }`
---@return string? error
function Kora.sql.ensureTable(spec)  return await('ensureTable', spec, GetCurrentResourceName()) end

---Yields until every named table exists (created by this or another resource). Returns true, or nil + error after `timeoutMs` (default 60000).
function Kora.sql.awaitTables(names, timeoutMs) return await('awaitTables', names, timeoutMs or 60000, GetCurrentResourceName()) end

---Same as `ensureTable` for an ordered list, so foreign key parents can come first.
function Kora.sql.ensureTables(specs) return await('ensureTables', specs, GetCurrentResourceName()) end

function Kora.sql.stats()               return exports.kora_sql:stats() end

local function fireAndForget(name, table_, key, rows, opts)
    local ok, err = pcall(function() exports.kora_sql[name](exports.kora_sql, table_, key, rows, opts) end)
    if not ok then print(('^3[kora_sql] %s(%s) failed: %s^7'):format(name, tostring(table_), tostring(err))) end
end
function Kora.sql.enqueue(table_, key, row, opts)      fireAndForget('enqueue', table_, key, row, opts) end
function Kora.sql.enqueueMany(table_, key, rows, opts) fireAndForget('enqueueMany', table_, key, rows, opts) end

function Kora.sql.flush(table_)
    local p = promise.new()
    local called, callErr = pcall(function()
        exports.kora_sql:flush(table_, function(ok, err)
            if ok then p:resolve(true) else p:reject(err or 'flush failed') end
        end)
    end)
    if not called then return false, tostring(callErr) end
    local ok, res = pcall(Citizen.Await, p)
    if not ok then return false, tostring(res) end
    return res
end

local function invoke(cb, name, ...)
    local args = table.pack(...)
    local ok, err = pcall(function() exports.kora_sql[name](exports.kora_sql, table.unpack(args, 1, args.n)) end)
    if not ok and cb then cb(nil, tostring(err)) end
end

local function asyncVariant(name)
    return function(sql, params, cb)
        invoke(cb, name, sql, params, cb)
    end
end

Kora.sql.queryAsync   = asyncVariant('query')
Kora.sql.singleAsync  = asyncVariant('single')
Kora.sql.scalarAsync  = asyncVariant('scalar')
Kora.sql.executeAsync = asyncVariant('execute')
Kora.sql.insertAsync  = asyncVariant('insert')
Kora.sql.updateAsync  = asyncVariant('update')

function Kora.sql.ensureTableAsync(spec, cb)
    invoke(cb, 'ensureTable', spec, cb, GetCurrentResourceName())
end

function Kora.sql.ensureTablesAsync(specs, cb)
    invoke(cb, 'ensureTables', specs, cb, GetCurrentResourceName())
end
