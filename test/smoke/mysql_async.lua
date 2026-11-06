-- mysql-async deployment: kora_sql no longer provides the name; stubs/mysql-async
-- is a standalone resource whose lib/MySQL.lua is loaded into the consumer VM
-- exactly like a stock `@mysql-async/lib/MySQL.lua` include, and the raw
-- exports['mysql-async']:mysql_* surface forwards to kora_sql.
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

h.test('stub manifest is a deployable standalone resource', function()
    local m = readFile('stubs/mysql-async/fxmanifest.lua')
    h.assertTrue(m:match("\nname 'mysql%-async'"), 'name')
    h.assertTrue(m:match("\nversion '%d+%.%d+%.%d+'"), 'version')
    h.assertTrue(m:match("dependency 'kora_sql'"), 'dependency')
    h.assertTrue(m:match("'lib/MySQL.lua'"), 'ships lib/MySQL.lua')
    h.assertTrue(not m:match("\nprovide"), 'stub provides nothing')
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

-- Consumer VM: load the stub include the way FXServer resolves @mysql-async/...
GetNumResourceMetadata = function() return 0 end
GetResourceMetadata = function() return nil end
Citizen.CreateThreadNow = function(fn) fn() end
CreateThreadNow = Citizen.CreateThreadNow
LoadResourceFile = function(res, file)
    assert(res == 'kora_sql', 'stub must load kora_sql, got ' .. tostring(res))
    return readFile(file)
end
MySQL = nil
dofile('stubs/mysql-async/lib/MySQL.lua')

h.test('stock mysql-async MySQL.Async / MySQL.Sync / MySQL.ready API is present', function()
    for _, name in ipairs({ 'fetchAll', 'fetchScalar', 'execute', 'insert', 'transaction' }) do
        h.assertTrue(type(MySQL.Async[name]) == 'table' or type(MySQL.Async[name]) == 'function', 'Async.' .. name)
        h.assertTrue(type(MySQL.Sync[name]) == 'function', 'Sync.' .. name)
    end
    h.assertTrue(type(MySQL.Async.store) == 'function' and type(MySQL.Sync.store) == 'function', 'store')
    h.assertTrue(type(MySQL.ready) == 'table' or type(MySQL.ready) == 'function', 'MySQL.ready')
end)

h.test('MySQL.Async/Sync forward to kora_sql (Async.execute = update)', function()
    local got
    MySQL.Async.fetchAll('SELECT 1', {}, function(r) got = r end)
    h.assertTrue(got and got.ok and handle.lastCallExact('oxQuery') ~= nil)
    MySQL.Async.execute('UPDATE t SET a = 1', {}, function() end)
    h.assertTrue(handle.lastCallExact('oxUpdate') ~= nil, 'execute -> update')
    MySQL.Async.insert('INSERT INTO t VALUES (1)', {}, function() end)
    h.assertTrue(handle.lastCallExact('oxInsert') ~= nil)
    MySQL.Async.fetchScalar('SELECT 1', {}, function() end)
    h.assertTrue(handle.lastCallExact('oxScalar') ~= nil)
    MySQL.Async.transaction({ 'SELECT 1' }, function() end)
    h.assertTrue(handle.lastCallExact('transaction') ~= nil)
    local r = MySQL.Sync.fetchScalar('SELECT 1', {})
    h.assertTrue(r ~= nil)
end)

h.report('mysql-async')
