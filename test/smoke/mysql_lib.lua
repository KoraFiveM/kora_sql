local h = dofile('test/harness.lua')
local mocks = dofile('test/mocks.lua')
local handle = mocks.install()

GetNumResourceMetadata = function() return 0 end
GetResourceMetadata = function() return nil end
Citizen.CreateThreadNow = function(fn) fn() end

dofile('lib/MySQL.lua')

h.test('top-level oxmysql dual methods and await variants are complete', function()
    for _, name in ipairs({ 'query', 'single', 'scalar', 'insert', 'update', 'prepare', 'rawExecute', 'transaction' }) do
        h.assertTrue(type(MySQL[name]) == 'table', 'missing MySQL.' .. name)
        h.assertTrue(type(MySQL[name].await) == 'function', 'missing MySQL.' .. name .. '.await')
    end
    h.assertTrue(type(MySQL.ready.await) == 'function')
    h.assertTrue(type(MySQL.startTransaction) == 'function')
end)

h.test('callback-as-second-argument is normalized and attributed', function()
    local result
    MySQL.query('SELECT 1', function(value) result = value end)
    h.assertTrue(result and result.ok)
    local call = handle.lastCall('query')
    h.assertEqual(call.args[#call.args], 'consumer-under-test')
    h.assertEqual(type(call.args[2]), 'table')
end)

h.test('stored queries resolve through Async and Sync aliases', function()
    local stored = MySQL.Sync.store('SELECT ?')
    local result = MySQL.Sync.fetchAll(stored, { 1 })
    h.assertTrue(result and result.ok)
    local call = handle.lastCall('query')
    h.assertEqual(call.args[1], 'SELECT ?')
end)

h.test('ready await and startTransaction forward to qbsql', function()
    h.assertTrue(MySQL.ready.await())
    MySQL.startTransaction(function() return true end)
    h.assertTrue(handle.lastCall('startTransaction') ~= nil)
end)

h.report('mysql-lib')
