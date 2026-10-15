local scriptDir = debug.getinfo(1, 'S').source:match('@?(.*/)') or './'
local testDir = scriptDir .. '../'
local repoRoot = testDir .. '../'
package.path = testDir .. '?.lua;' .. package.path

local harness = require('harness')
local net = require('mocks').install()

QB = {
    util = {
        fnv1a = function(value) return 'sum:' .. value end,
    },
}

local files = {
    ['demo:sql/001.sql'] = 'SELECT 1;',
}

function _G.LoadResourceFile(resource, path)
    return files[resource .. ':' .. path]
end

dofile(repoRoot .. 'init.lua')

harness.test('migrateFiles loads and fingerprints migration files', function()
    local result, err = QB.sql.migrateFiles('demo', {
        { version = 1, name = 'core', file = 'sql/001.sql', acceptedChecksums = { 'old' } },
    })
    harness.assertTrue(result ~= nil, tostring(err))

    local call = net.lastCall('migrate')
    harness.assertEqual(call.args[1], 'demo')
    harness.assertEqual(call.args[2][1].sql, 'SELECT 1;')
    harness.assertEqual(call.args[2][1].checksum, 'sum:SELECT 1;')
    harness.assertEqual(call.args[2][1].file, nil)
    harness.assertEqual(call.args[2][1].acceptedChecksums[1], 'old')
end)

harness.test('migrateFiles reports a missing file without calling the driver', function()
    local before = #net.jsCalls
    local result, err = QB.sql.migrateFiles('demo', {
        { version = 2, name = 'missing', file = 'sql/002.sql' },
    })
    harness.assertEqual(result, nil)
    harness.assertTrue(err:find('sql/002.sql', 1, true) ~= nil)
    harness.assertEqual(#net.jsCalls, before)
end)

harness.test('checked transaction and recovery wrappers preserve operation context', function()
    QB.sql.transactionChecked({ { query = 'UPDATE receipt', expectedRows = 1 } }, { key = 'claim', fingerprint = 'terms', citizenids = { 'CID' } })
    local call = net.lastCall('transactionChecked')
    harness.assertEqual(call.args[1][1].expectedRows, 1)
    harness.assertEqual(call.args[2].fingerprint, 'terms')
    QB.sql.awaitCheckedOperation('claim', 'terms')
    call = net.lastCall('awaitCheckedOperation')
    harness.assertEqual(call.args[1], 'claim')
    harness.assertEqual(call.args[2], 'terms')
    QB.sql.awaitCheckedOperations('qbhousing:')
    call = net.lastCall('awaitCheckedOperations')
    harness.assertEqual(call.args[1], 'qbhousing:')
end)

harness.report('init')
