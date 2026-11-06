local scriptDir = debug.getinfo(1, 'S').source:match('@?(.*/)') or './'
local testDir = scriptDir .. '../'
local repoRoot = testDir .. '../'
package.path = testDir .. '?.lua;' .. package.path

local harness = require('harness')
local net = require('mocks').install()

Kora = {
    util = {
        fnv1a = function(value) return 'sum:' .. value end,
    },
}

dofile(repoRoot .. 'init.lua')

harness.test('checked transaction and recovery wrappers preserve operation context', function()
    Kora.sql.transactionChecked({ { query = 'UPDATE receipt', expectedRows = 1 } }, { key = 'claim', fingerprint = 'terms', citizenids = { 'CID' } })
    local call = net.lastCall('transactionChecked')
    harness.assertEqual(call.args[1][1].expectedRows, 1)
    harness.assertEqual(call.args[2].fingerprint, 'terms')
    Kora.sql.awaitCheckedOperation('claim', 'terms')
    call = net.lastCall('awaitCheckedOperation')
    harness.assertEqual(call.args[1], 'claim')
    harness.assertEqual(call.args[2], 'terms')
    Kora.sql.awaitCheckedOperations('qbhousing:')
    call = net.lastCall('awaitCheckedOperations')
    harness.assertEqual(call.args[1], 'qbhousing:')
end)

harness.test('ensureTable and ensureTables pass the spec and calling resource to the driver', function()
    local spec = { name = 'demo_t', columns = { { name = 'id', type = 'int' } } }
    local result, err = Kora.sql.ensureTable(spec)
    harness.assertTrue(result ~= nil, tostring(err))
    local call = net.lastCall('ensureTable')
    harness.assertEqual(call.args[1], spec)
    harness.assertEqual(call.args[2], 'consumer-under-test')

    Kora.sql.ensureTables({ spec })
    call = net.lastCall('ensureTables')
    harness.assertEqual(call.args[1][1], spec)
    harness.assertEqual(call.args[2], 'consumer-under-test')

    local got
    Kora.sql.ensureTableAsync(spec, function(report) got = report end)
    harness.assertTrue(got ~= nil)
    call = net.lastCall('ensureTable')
    harness.assertEqual(call.args[3], 'consumer-under-test')
end)

harness.test('awaitTables passes names, timeout and calling resource to the driver', function()
    local ok, err = Kora.sql.awaitTables({ 'players' }, 1500)
    harness.assertTrue(ok ~= nil, tostring(err))
    local call = net.lastCall('awaitTables')
    harness.assertEqual(call.args[1][1], 'players')
    harness.assertEqual(call.args[2], 1500)
    harness.assertEqual(call.args[3], 'consumer-under-test')
    Kora.sql.awaitTables({ 'players' })
    harness.assertEqual(net.lastCall('awaitTables').args[2], 60000)
end)

harness.test('a stopped driver returns nil, err (and not ready) instead of raising', function()
    local real = getmetatable(exports.kora_sql)
    setmetatable(exports.kora_sql, { __index = function(_, name)
        return function() error('No such export ' .. name .. ' in resource kora_sql') end
    end })
    local ok, raised = pcall(function()
        local rows, err = Kora.sql.query('SELECT 1')
        harness.assertEqual(rows, nil)
        harness.assertTrue(tostring(err):find('No such export', 1, true) ~= nil, tostring(err))
        local ready, readyErr = Kora.sql.ready(100)
        harness.assertFalse(ready)
        harness.assertTrue(readyErr ~= nil)
        local flushed, flushErr = Kora.sql.flush('players')
        harness.assertFalse(flushed)
        harness.assertTrue(flushErr ~= nil)
        local got, gotErr = 'unset', nil
        Kora.sql.queryAsync('SELECT 1', {}, function(r, e) got, gotErr = r, e end)
        harness.assertEqual(got, nil)
        harness.assertTrue(gotErr ~= nil, 'async callback answered with the error')
    end)
    setmetatable(exports.kora_sql, real)
    if not ok then error(raised, 0) end
end)

harness.report('init')
