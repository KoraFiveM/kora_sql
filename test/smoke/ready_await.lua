-- Smoke test: readiness and query waits park on events/promises instead of
-- polling (F#272, F#275), and Kora.sql.* honours Config.sql.awaitTimeout
-- (F#273). Uses a tiny coroutine scheduler with a fake clock so a test can
-- count how often the readiness export is consulted while a caller waits.

package.path = './test/?.lua;' .. package.path
local h = dofile('test/harness.lua')

local now, timers, handlers = 0, {}, {}
local isReadyCalls, ready = 0, false
local pendingCb = {}

local function reset()
    now, timers, handlers, isReadyCalls, ready, pendingCb = 0, {}, {}, 0, false, {}
end

function _G.GetGameTimer() return now end
function _G.SetTimeout(ms, fn) timers[#timers + 1] = { at = now + ms, fn = fn } end
function _G.AddEventHandler(name, fn)
    handlers[name] = handlers[name] or {}
    table.insert(handlers[name], fn)
end
function _G.TriggerEvent(name, ...)
    for _, fn in ipairs(handlers[name] or {}) do fn(...) end
end
function _G.GetCurrentResourceName() return 'consumer' end

-- Wait(ms) and Citizen.Await yield the running coroutine back to `advance`.
function _G.Wait(ms)
    local co = (coroutine.running())
    SetTimeout(ms, function() coroutine.resume(co) end)
    coroutine.yield()
end

_G.promise = {
    new = function()
        local p = { waiters = {} }
        function p:resolve(v)
            if self.done then return end
            self.done, self.value = true, v
            for _, co in ipairs(self.waiters) do coroutine.resume(co) end
        end
        function p:reject(e)
            if self.done then return end
            self.done, self.err = true, e
            for _, co in ipairs(self.waiters) do coroutine.resume(co) end
        end
        return p
    end,
}
_G.Citizen = {
    Await = function(p)
        if not p.done then
            table.insert(p.waiters, (coroutine.running()))
            coroutine.yield()
        end
        if p.err ~= nil then error(p.err, 0) end
        return p.value
    end,
}

_G.exports = {
    kora_sql = setmetatable({
        isReady = function() isReadyCalls = isReadyCalls + 1; return ready end,
    }, {
        __index = function(_, name)
            return function(_, ...)
                local args = { ... }
                pendingCb[name] = args[#args]
            end
        end,
    }),
}

-- Step the fake clock 16 ms at a time, firing due timers.
local function advance(ms)
    local stop = now + ms
    while now < stop do
        now = now + 16
        local due = {}
        for i = #timers, 1, -1 do
            if timers[i].at <= now then due[#due + 1] = table.remove(timers, i) end
        end
        for i = #due, 1, -1 do due[i].fn() end
    end
end

local function spawn(fn)
    local out = {}
    local co = coroutine.create(function() out.values = table.pack(fn()) end)
    assert(coroutine.resume(co))
    return out
end

Kora = { util = { fnv1a = function(v) return v end } }
Config = { sql = { awaitTimeout = 500, readyTimeout = 1000 } }
dofile('init.lua')

h.test('Kora.sql.ready waits on qbsql:ready instead of polling isReady', function()
    reset()
    local out = spawn(function() return Kora.sql.ready(5000) end)
    advance(2000)
    h.assertEqual(out.values, nil, 'ready must still be waiting')
    h.assertEqual(isReadyCalls, 1, 'isReady should be consulted once, not polled')
    ready = true
    TriggerEvent('qbsql:ready', 'test')
    h.assertEqual(out.values and out.values[1], true)
end)

h.test('Kora.sql.ready returns false at its deadline', function()
    reset()
    local out = spawn(function() return Kora.sql.ready(300) end)
    advance(400)
    h.assertEqual(out.values and out.values[1], false)
    h.assertEqual(out.values and out.values[2], 'qbsql not ready within timeout')
end)

h.test('Kora.sql.query times out after Config.sql.awaitTimeout', function()
    reset()
    local out = spawn(function() return Kora.sql.query('SELECT 1') end)
    advance(400)
    h.assertEqual(out.values, nil, 'query should still be pending before the deadline')
    advance(1200)
    h.assertTrue(out.values ~= nil, 'query should give up after awaitTimeout')
    h.assertEqual(out.values[1], nil)
    h.assertTrue(tostring(out.values[2]):find('timed out after 500 ms', 1, true) ~= nil, tostring(out.values[2]))
    -- A late driver reply after the timeout is ignored.
    pendingCb.query({ late = true }, nil)
    h.assertEqual(out.values[1], nil)
end)

h.test('a reply before the deadline wins and leaves no armed watchdog behind', function()
    reset()
    local out = spawn(function() return Kora.sql.scalar('SELECT 1') end)
    advance(100)
    pendingCb.scalar(7, nil)
    h.assertEqual(out.values and out.values[1], 7)
    advance(3000)
    h.assertEqual(#timers, 0, 'watchdog should stop once nothing is pending')
end)

h.test('awaitTimeout = 0 disables the query timeout', function()
    reset()
    Config.sql.awaitTimeout = 0
    local out = spawn(function() return Kora.sql.query('SELECT 1') end)
    advance(5000)
    h.assertEqual(out.values, nil, 'query should keep waiting with timeout disabled')
    pendingCb.query({ ok = true }, nil)
    h.assertEqual(out.values and out.values[1] and out.values[1].ok, true)
    Config.sql.awaitTimeout = 500
end)

h.test('migrations are never timed out', function()
    reset()
    local out = spawn(function() return Kora.sql.migrate('demo', {}) end)
    advance(5000)
    h.assertEqual(out.values, nil, 'migrate should not time out')
end)

-- Server-side latch used by oxmysql:awaitConnection (F#272).
Ready = nil
dofile('server/ready.lua')

h.test('Ready.await parks until the internal ready event', function()
    reset()
    handlers = {}
    Ready = nil
    dofile('server/ready.lua')
    local out = spawn(function() return Ready.await(false) end)
    advance(5000)
    h.assertEqual(out.values, nil, 'Ready.await(false) must wait without a deadline')
    h.assertEqual(#timers, 0, 'Ready.await must not poll with timers')
    TriggerEvent('qbsql:internal:ready', 'test')
    h.assertEqual(out.values and out.values[1], true)
end)

h.test('Ready.await(ms) returns false at its deadline', function()
    reset()
    handlers = {}
    Ready = nil
    dofile('server/ready.lua')
    local out = spawn(function() return Ready.await(200) end)
    advance(300)
    h.assertEqual(out.values and out.values[1], false)
end)

h.test('oxmysql awaitConnection uses the ready latch, not a Wait(0) spin', function()
    reset()
    handlers = {}
    Ready = nil
    dofile('server/ready.lua')
    local exportsFound = {}
    local realAdd = _G.AddEventHandler
    _G.AddEventHandler = function(name, cb)
        if name:match('^__cfx_export_') then
            cb(function(fn) exportsFound[name:gsub('^__cfx_export_oxmysql_', '')] = fn end)
        else
            realAdd(name, cb)
        end
    end
    _G.GetInvokingResource = function() return 'x' end
    _G.Config = { compat = { oxmysql = true, warnOnSync = false }, sql = Config.sql }
    dofile('server/compat/oxmysql.lua')
    _G.AddEventHandler = realAdd
    local out = spawn(function() return exportsFound.awaitConnection() end)
    advance(1000)
    h.assertEqual(out.values, nil, 'awaitConnection should still wait')
    h.assertEqual(isReadyCalls, 0, 'awaitConnection must not poll the isReady export')
    TriggerEvent('qbsql:internal:ready', 'test')
    h.assertEqual(out.values and out.values[1], true)
end)

h.report('ready_await')
