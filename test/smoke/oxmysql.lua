-- Smoke test: the oxmysql compat layer registers the expected export surface,
-- forwards the invoking resource for attribution, and refuses multi-statement
-- queries. Runs under plain lua5.4 with mocked exports/natives -- no DB.

package.path = package.path .. ';./?.lua'
local h = dofile('test/harness.lua')
local mocks = dofile('test/mocks.lua')

local handle = mocks.install()

-- The compat file guards on Config.compat.oxmysql; provide a Config.
_G.Config = { compat = { oxmysql = true, warnOnSync = true, allowMultipleStatements = false } }

-- Load the compat file into this process. It registers via AddEventHandler,
-- which our mock resolves immediately into handle.providedExports.
dofile('server/compat/oxmysql.lua')

h.test('registers the core oxmysql export surface', function()
    for _, name in ipairs({ 'execute', 'query', 'scalar', 'single', 'insert', 'update',
                            'executeSync', 'querySync', 'transaction', 'store', 'isReady' }) do
        h.assertTrue(handle.getExport('oxmysql', name) ~= nil,
            'missing export oxmysql:' .. name)
    end
end)

h.test('query forwards the invoking resource as the trailing argument', function()
    handle.setInvokingResource('some-other-resource')
    local query = handle.getExport('oxmysql', 'query')
    query('SELECT 1', { 42 }, function() end)

    local call = handle.lastCall('query')
    h.assertTrue(call ~= nil, 'expected a query call to reach exports.qbsql')
    -- args: (sql, params, cb, resource)
    local resource = call.args[#call.args]
    h.assertEqual(resource, 'some-other-resource', 'invoking resource not forwarded')
end)

h.test('isReady forwards the qbsql readiness result', function()
    exports.qbsql.isReady = function() return true end

    local isReady = handle.getExport('oxmysql', 'isReady')
    h.assertTrue(isReady(), 'oxmysql:isReady should return qbsql readiness')
end)

h.test('params default to an empty table when omitted-as-nil', function()
    handle.setInvokingResource('r')
    local query = handle.getExport('oxmysql', 'query')
    query('SELECT 1', nil, function() end)
    local call = handle.lastCall('query')
    h.assertEqual(type(call.args[2]), 'table', 'params should be normalised to a table')
end)

h.test('multi-statement queries are refused (callback gets an error)', function()
    handle.setInvokingResource('r')
    local query = handle.getExport('oxmysql', 'query')
    local errSeen = nil
    query('SELECT 1; DROP TABLE players', {}, function(_, err) errSeen = err end)
    h.assertTrue(errSeen ~= nil, 'multi-statement query should have been refused')
end)

h.test('a trailing semicolon alone is NOT treated as multi-statement', function()
    handle.setInvokingResource('r')
    local query = handle.getExport('oxmysql', 'query')
    local errSeen = 'sentinel'
    query('SELECT 1;   ', {}, function(_, err) errSeen = err end)
    -- Our mock cb is called with (result, nil) on a real forward; refusal calls
    -- (nil, 'multi-statement refused'). So no error means it was forwarded.
    h.assertTrue(errSeen == nil, 'a bare trailing semicolon must not be refused')
end)

h.report('oxmysql-compat')
