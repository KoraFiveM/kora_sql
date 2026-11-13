local h = dofile('test/harness.lua')
local mocks = dofile('test/mocks.lua')
local handle = mocks.install()

local function readFile(path)
    local f = assert(io.open(path, 'rb'))
    local s = f:read('a'); f:close(); return s
end

h.test('kora_sql manifest no longer provides mysql-async', function()
    local m = readFile('fxmanifest.lua')
    h.assertTrue(not m:match("\nprovide%s+['\"]mysql%-async['\"]"), 'provide removed')
    h.assertTrue(m:match("\nprovide 'ghmattimysql'"), 'ghmattimysql still provided')
    h.assertTrue(m:match("'server/compat/mysql%-async.lua'"), 'export shim still loaded')
end)

h.test('kora_sql manifest does not provide oxmysql (placeholder in KoraFiveM/compat owns the name)', function()
    local m = readFile('fxmanifest.lua')
    h.assertTrue(not m:match("\nprovide%s+['\"]oxmysql['\"]"), 'must not provide oxmysql')
end)

_G.Config = { compat = { mysqlAsync = true } }
dofile('server/compat/mysql-async.lua')

h.test('raw mysql-async exports forward to kora_sql with attribution', function()
    handle.setInvokingResource('legacy')
    for exportName, js in pairs({
        mysql_fetch_all = 'query', mysql_fetch_scalar = 'scalar',
        mysql_insert = 'insert', mysql_execute = 'update',
    }) do
        local fn = handle.getExport('mysql-async', exportName)
        h.assertTrue(fn ~= nil, 'missing ' .. exportName)
        fn('SELECT 1', { 1 }, function() end)
        local call = handle.lastCallExact(js)
        h.assertTrue(call ~= nil, exportName .. ' -> ' .. js)
        h.assertEqual(call.args[#call.args], 'legacy')
    end
    handle.getExport('mysql-async', 'mysql_transaction')({ 'SELECT 1' }, {}, function() end)
    h.assertTrue(handle.lastCallExact('transaction') ~= nil)
    handle.getExport('mysql-async', 'mysql_store')('SELECT 2', function() end)
    h.assertTrue(handle.lastCallExact('store') ~= nil, 'mysql_store')
    exports.kora_sql.isReady = function() return true end
    h.assertTrue(handle.getExport('mysql-async', 'is_ready')(), 'is_ready')
end)

h.test('raw (query, cb) calls shift the callback out of the params slot', function()
    handle.setInvokingResource('legacy')
    local cb = function() end
    handle.getExport('mysql-async', 'mysql_fetch_all')('SELECT 1', cb)
    local call = handle.lastCallExact('query')
    h.assertEqual(type(call.args[2]), 'table', 'params normalised to a table')
    h.assertEqual(call.args[3], cb, 'callback in the callback slot')
    h.assertEqual(call.args[4], 'legacy')

    _G.Config.compat.ghmattimysql = true
    dofile('server/compat/ghmattimysql.lua')
    handle.getExport('ghmattimysql', 'execute')('SELECT 2', cb)
    call = handle.lastCallExact('query')
    h.assertEqual(call.args[1], 'SELECT 2')
    h.assertEqual(call.args[3], cb)
    h.assertEqual(call.args[4], 'legacy')
end)

h.report('mysql-async')
