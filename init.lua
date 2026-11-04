-- '@kora_sql/init.lua' -- installs Kora.sql.* into the CONSUMER's own Lua VM.
--
-- A consumer opts in with, in this order:
--     shared_script '@kora_lib/init.lua'
--     shared_script '@kora_sql/init.lua'
--
-- WHY THIS IS LEGAL: kora_lib/init.lua creates the global `Kora` as a plain table
-- whose metatable has only __index (no __newindex). So `Kora.sql = {...}` from a
-- later shared_script in the same VM is a plain rawset -- kora_lib's auto-vivifying
-- __index never fires for `sql` again. We install real LOCAL functions here, in
-- the caller's VM, so their promise.new()/Citizen.Await are same-VM: none of the
-- cross-resource promise-marshalling hazard that kora_lib's settleForExport exists
-- to work around applies.
--
-- WHY NOT a kora_lib/modules/sql module: kora_lib is zero-dependency and every
-- consumer loads it. Putting Kora.sql there would invert the graph (library
-- depends on an application resource), and kora_lib's finalise exports
-- unconditionally -- so Kora.sql.query would EXIST on servers not running kora_sql
-- and fail at runtime. This opt-in include is strictly safer.

assert(Kora, '@kora_sql/init.lua must be loaded AFTER @kora_lib/init.lua (add its shared_script first).')

Kora.sql = Kora.sql or {}

-- Explicit SQL NULL. A Lua table cannot store nil, so an optional bind value
-- written as `{a, nil, b}` reaches the JS driver either as a hole (mysql2:
-- "Bind parameters must not contain undefined") or as an array truncated at the
-- gap -- which is how kora_core's garage insert failed on every boot for a
-- job-fleet vehicle with no citizenid. Pass Kora.sql.NULL for an intentionally
-- null bind value; the JS side maps it back to null. Keep this literal in sync
-- with NULL_SENTINEL in server/js/execute.js.
Kora.sql.NULL = '\0qbsql:null\0'

local driver = exports.kora_sql

-- Run a JS export that returns a promise, and Await it on this coroutine.
-- Returns (value, errorString). The JS `dataExport` wrapper returns a promise
-- when no callback is passed; FiveM marshals its resolution back here.
local function await(name, ...)
    local args = { ... }
    local p = promise.new()
    -- We pass a Lua callback as the trailing argument; the JS side detects a
    -- callable last arg and calls cb(result, errString) instead of returning a
    -- promise. This avoids depending on cross-boundary promise marshalling.
    args[#args + 1] = function(result, err)
        if err then
            p:reject(err)
        else
            p:resolve(result)
        end
    end
    driver[name](driver, table.unpack(args))
    local ok, res = pcall(Citizen.Await, p)
    if not ok then
        return nil, tostring(res)
    end
    return res
end

-- The yielding API. Each returns (value, errorString); on error the value is
-- nil and the second return carries the message, per this codebase's
-- fallible-function convention (never throws across the call).
function Kora.sql.ready(timeoutMs)
    -- isReady is cheap and synchronous; poll it so a caller can gate on the pool.
    if exports.kora_sql:isReady() then return true end
    local deadline = GetGameTimer() + (timeoutMs or (Config and Config.sql and Config.sql.readyTimeout) or 60000)
    while not exports.kora_sql:isReady() do
        if GetGameTimer() > deadline then return false, 'qbsql not ready within timeout' end
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

-- The FIRE-AND-FORGET path. These NEVER yield -- they hand rows to the JS queue
-- and return immediately. This is the hot save path for kora_core's persistence.
function Kora.sql.enqueue(table_, key, row, opts)      exports.kora_sql:enqueue(table_, key, row, opts) end
function Kora.sql.enqueueMany(table_, key, rows, opts) exports.kora_sql:enqueueMany(table_, key, rows, opts) end

-- flush yields until the named table (or everything) has been drained.
function Kora.sql.flush(table_)
    local p = promise.new()
    exports.kora_sql:flush(table_, function(ok, err)
        if ok then p:resolve(true) else p:reject(err or 'flush failed') end
    end)
    local ok, res = pcall(Citizen.Await, p)
    if not ok then return false, tostring(res) end
    return res
end

-- Non-yielding callback variants for callers that don't want to spin up a
-- coroutine. cb(result, errorString).
local function asyncVariant(name)
    return function(sql, params, cb)
        exports.kora_sql[name](exports.kora_sql, sql, params, cb)
    end
end

Kora.sql.queryAsync   = asyncVariant('query')
Kora.sql.singleAsync  = asyncVariant('single')
Kora.sql.scalarAsync  = asyncVariant('scalar')
Kora.sql.executeAsync = asyncVariant('execute')
Kora.sql.insertAsync  = asyncVariant('insert')
Kora.sql.updateAsync  = asyncVariant('update')

function Kora.sql.ensureTableAsync(spec, cb)
    exports.kora_sql:ensureTable(spec, cb, GetCurrentResourceName())
end

function Kora.sql.ensureTablesAsync(specs, cb)
    exports.kora_sql:ensureTables(specs, cb, GetCurrentResourceName())
end
