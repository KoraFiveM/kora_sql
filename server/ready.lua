-- Readiness fan-out. The JS runtime emits `qbsql:internal:ready` once the pool
-- is up; this file latches that and re-broadcasts a public `qbsql:ready` event
-- other resources can wait on, plus a Ready table other qbsql Lua files consult.
--
-- WHY a Lua latch rather than just calling exports.qbsql:isReady() everywhere:
-- a resource that loads before qbsql finishes its async boot would get
-- isReady()==false with no way to know when to retry. The event + the polling
-- helper below give both a push and a pull path.

local isReady = false

-- Latch the internal ready signal from server/js/index.js.
AddEventHandler('qbsql:internal:ready', function(version)
    isReady = true
    print(('^5[qbsql:ready]^7 driver up: %s'):format(version and version.server or 'unknown'))
    -- Public event. Late subscribers also get the answer via the poll below.
    TriggerEvent('qbsql:ready', version)
end)

-- A resource can call exports.qbsql:isReady() (JS) directly, but this Lua-side
-- copy avoids a boundary crossing for our own compat/command files.
Ready = Ready or {}

function Ready.isReady()
    return isReady
end

-- Block the CURRENT coroutine until the pool is up (or timeout). Only for use
-- from inside a CreateThread -- never call from the main resource-load path.
function Ready.await(timeoutMs)
    if isReady then return true end
    local deadline = GetGameTimer() + (timeoutMs or 60000)
    while not isReady do
        if GetGameTimer() > deadline then return false end
        Wait(50)
    end
    return true
end
