-- Placeholder test: loads stubs/oxmysql/lib/MySQL.lua exactly as a consumer's
-- `@oxmysql/lib/MySQL.lua` include would (LoadResourceFile -> load -> run) against a
-- mocked kora_sql backend, and exercises the call forms ox_inventory uses.
local h = dofile('test/harness.lua')
local mocks = dofile('test/mocks.lua')
mocks.install()

local calls = {}
local nextResult = { value = nil, err = nil }

-- Backend: records every call and answers the trailing-callback style export.
local backend = setmetatable({}, { __index = function(_, name)
    return function(_self, ...)
        local args = { ... }
        calls[#calls + 1] = { name = name, args = args }
        for _, a in ipairs(args) do
            if type(a) == 'function' then a(nextResult.value, nextResult.err) end
        end
        if name == 'isReady' then return true end
    end
end })
_G.exports = { kora_sql = backend }

GetNumResourceMetadata = function() return 0 end
GetResourceMetadata = function() return nil end
Citizen.CreateThreadNow = function(fn) fn() end
CreateThreadNow = Citizen.CreateThreadNow
-- Real Await throws the rejection; the shared mock only knows about resolve.
Citizen.Await = function(p)
    if p.__rejected then error(p.__error, 0) end
    return p.__value
end

local function readFile(path)
    local f = assert(io.open(path, 'rb'))
    local s = f:read('a'); f:close(); return s
end
LoadResourceFile = function(res, file)
    assert(res == 'kora_sql', 'placeholder must load kora_sql, got ' .. tostring(res))
    return readFile('lib/' .. file:gsub('^lib/', ''))
end

dofile('stubs/oxmysql/lib/MySQL.lua')

local function last(name)
    local ox = 'ox' .. name:sub(1, 1):upper() .. name:sub(2)
    for i = #calls, 1, -1 do
        if calls[i].name == name or calls[i].name == ox then return calls[i] end
    end
end
local function reset(value, err) calls = {}; nextResult = { value = value, err = err } end

h.test('manifest: name oxmysql, version >= 2.7.3, kora_sql dependency, ships lib/MySQL.lua', function()
    local m = readFile('stubs/oxmysql/fxmanifest.lua')
    h.assertTrue(m:match("name 'oxmysql'"), 'name')
    h.assertTrue(m:match("dependency 'kora_sql'"), 'dependency')
    h.assertTrue(m:match("'lib/MySQL.lua'"), 'files')
    h.assertTrue(m:match("compatibility placeholder"), 'description')
    h.assertTrue(m:match("not affiliated with Overextended"), 'description')
    local a, b, c = m:match("\nversion '(%d+)%.(%d+)%.(%d+)'")
    a, b, c = tonumber(a), tonumber(b), tonumber(c)
    h.assertTrue(a == 2 and b == 7 and c == 3, 'version is exactly 2.7.3')
    h.assertTrue(a and (a > 2 or (a == 2 and (b > 7 or (b == 7 and c >= 3)))), 'version >= 2.7.3')
end)

h.test('kora_sql manifest does not provide oxmysql (placeholder owns the name)', function()
    local m = readFile('fxmanifest.lua')
    h.assertTrue(not m:match("\nprovide%s+['\"]oxmysql['\"]"), 'must not provide oxmysql')
    h.assertTrue(not m:match("\nprovide%s+['\"]mysql%-async['\"]"), 'must not provide mysql-async (stub owns the name)')
    h.assertTrue(m:match("\nprovide 'ghmattimysql'"), 'still provides ghmattimysql')
end)

h.test('prepare.await: positional ? params, forwarded with consumer attribution', function()
    reset(42)
    local v = MySQL.prepare.await('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', { 'a', 'b' })
    h.assertEqual(v, 42)
    local c = last('prepare')
    h.assertEqual(c.args[2][2], 'b')
    h.assertEqual(c.args[#c.args], 'consumer-under-test')
end)

h.test('prepare.await: scalar, row and batch shapes pass through unchanged', function()
    reset('{"slots":1}')
    h.assertEqual(MySQL.prepare.await('SELECT inventory FROM players WHERE citizenid = ?', { 'X' }), '{"slots":1}')
    local row = { citizenid = 'X', name = 'N' }
    reset(row)
    h.assertTrue(MySQL.prepare.await('SELECT citizenid, name FROM players WHERE citizenid = ?', { 'X' }) == row)
    local batch = { { 'i1', 'o1' }, { 'i2', 'o2' } }
    reset({ 1, 1 })
    local r = MySQL.prepare.await('UPDATE players SET inventory = ? WHERE citizenid = ?', batch)
    h.assertEqual(#r, 2)
    h.assertTrue(last('prepare').args[2] == batch, 'array-of-arrays sent as is')
end)

h.test('query.await / scalar.await / update.await / rawExecute.await / insert.await return results', function()
    reset({ { a = 1 } }); h.assertEqual(MySQL.query.await('SELECT 1 AS a')[1].a, 1)
    reset(7); h.assertEqual(MySQL.scalar.await('SELECT COUNT(*) FROM t'), 7)
    reset(3); h.assertEqual(MySQL.update.await('UPDATE t SET a = ?', { 1 }), 3)
    reset(9); h.assertEqual(MySQL.insert.await('INSERT INTO t VALUES (?)', { 1 }), 9)
    reset({ affectedRows = 1 })
    h.assertEqual(MySQL.rawExecute.await('UPDATE t SET a = ?', { 1 }).affectedRows, 1)
    h.assertTrue(last('rawExecute') ~= nil)
end)

h.test('every *.await throws on SQL error (pcall detects a missing table)', function()
    for _, name in ipairs({ 'query', 'scalar', 'update', 'insert', 'prepare', 'rawExecute' }) do
        reset(nil, "Table 'db.ox_inventory' doesn't exist")
        local ok, err = pcall(MySQL[name].await, 'SELECT 1 FROM ox_inventory')
        h.assertFalse(ok, name .. '.await must throw')
        h.assertTrue(tostring(err):find("doesn't exist", 1, true), 'error text preserved')
    end
    reset(nil, 'boom')
    local ok = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory')
    h.assertFalse(ok)
    reset(1)
    h.assertTrue((pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory')), 'success does not throw')
end)

h.test('MySQL.query without a callback is accepted; insert and update without callbacks too', function()
    reset({})
    MySQL.query('DELETE FROM ox_inventory WHERE lastupdated < NOW() - INTERVAL 6 MONTH')
    h.assertTrue(last('query') ~= nil)
    MySQL.insert('INSERT INTO t VALUES (?)', { 1 })
    h.assertTrue(last('insert') ~= nil)
    MySQL.update('UPDATE t SET a = 1')
    h.assertTrue(last('update') ~= nil)
end)

h.test('callback form still gets the result (no error argument by default)', function()
    reset({ 5 })
    local got, n
    MySQL.query('SELECT 5', function(r, ...) got = r; n = select('#', ...) end)
    h.assertEqual(got[1], 5)
    h.assertEqual(n, 0)
end)

h.test('DDL and INTERVAL clauses reach kora_sql untouched', function()
    local sqls = {
        'CREATE TABLE IF NOT EXISTS `ox_inventory` (`owner` varchar(60), `name` varchar(100), `data` longtext, `lastupdated` timestamp DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY `owner` (`owner`, `name`))',
        'ALTER TABLE `players` ADD COLUMN `inventory` LONGTEXT NULL',
        'DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL 6 MONTH)',
    }
    for _, sql in ipairs(sqls) do
        reset(0)
        MySQL.query.await(sql)
        h.assertEqual(last('query').args[1], sql)
    end
end)

h.test('MySQL.ready: callback form runs after awaitConnection; await form returns', function()
    reset(true)
    local ran = false
    MySQL.ready(function() ran = true end)
    h.assertTrue(ran, 'callback ran')
    h.assertTrue(last('awaitConnection') ~= nil)
    h.assertTrue(MySQL.ready.await())
end)

h.test('stub reports a clear error when kora_sql is missing', function()
    local saved = LoadResourceFile
    LoadResourceFile = function() return nil end
    local ok, err = pcall(dofile, 'stubs/oxmysql/lib/MySQL.lua')
    LoadResourceFile = saved
    h.assertFalse(ok)
    h.assertTrue(tostring(err):find('kora_sql', 1, true))
end)

h.test('mysql-async stub: named mysql-async, depends on kora_sql, forwards to kora_sql lib', function()
    local m = readFile('stubs/mysql-async/fxmanifest.lua')
    h.assertTrue(m:match("name 'mysql%-async'"), 'name')
    h.assertTrue(m:match("dependency 'kora_sql'"), 'dependency')
    h.assertTrue(m:match("'lib/MySQL.lua'"), 'files')
    reset(5)
    MySQL = nil
    dofile('stubs/mysql-async/lib/MySQL.lua')
    h.assertEqual(MySQL.scalar.await('SELECT 5'), 5)
    h.assertTrue(last('scalar') ~= nil, 'forwarded to kora_sql')
end)

h.report('oxmysql-placeholder')
