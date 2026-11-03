-- Readiness fan-out. The JS runtime emits `qbsql:internal:ready` once the pool
-- is up; this file latches that and re-broadcasts a public `qbsql:ready` event
-- other resources can wait on, plus a Ready table other kora_sql Lua files consult.
-- Nothing here polls: waiters park on a promise released by the ready event.
--
-- WHY a Lua latch rather than just calling exports.kora_sql:isReady() everywhere:
-- a resource that loads before kora_sql finishes its async boot would get
-- isReady()==false with no way to know when to retry. The event + the polling
-- helper below give both a push and a pull path.

local isReady = false
local waiters = {}

-- Latch the internal ready signal from server/js/index.js.
AddEventHandler('qbsql:internal:ready', function(version)
    isReady = true
    local parked = waiters
    waiters = {}
    for i = 1, #parked do parked[i](true) end
    print(('^5[kora_sql]^7 driver up: %s'):format(version and version.server or 'unknown'))
    -- Public event. Late subscribers also get the answer via the poll below.
    TriggerEvent('qbsql:ready', version)
end)

-- A resource can call exports.kora_sql:isReady() (JS) directly, but this Lua-side
-- copy avoids a boundary crossing for our own compat/command files.
Ready = Ready or {}

function Ready.isReady()
    return isReady
end

-- Block the CURRENT coroutine until the pool is up (or timeout). Only for use
-- from inside a CreateThread -- never call from the main resource-load path.
-- Parks on the ready latch instead of polling (F#272). `false` waits forever.
function Ready.await(timeoutMs)
    if isReady then return true end
    local p, settled = promise.new(), false
    local function settle(ok)
        if settled then return end
        settled = true
        if not ok then
            for i = #waiters, 1, -1 do
                if waiters[i] == settle then table.remove(waiters, i) break end
            end
        end
        p:resolve(ok)
    end
    waiters[#waiters + 1] = settle
    if timeoutMs ~= false then
        SetTimeout(timeoutMs or 60000, function() settle(false) end)
    end
    return Citizen.Await(p) == true
end
