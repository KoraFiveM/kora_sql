package.path = package.path .. ';./?.lua'
local h = dofile('test/harness.lua')
local mocks = dofile('test/mocks.lua')
local handle = mocks.install()

local convars = {}
GetConvar = function(name, def)
    local v = convars[name]
    if v == nil then return def end
    return v
end
_G.Config = { compat = { oxmysql = true, warnOnSync = true } }
dofile('server/compat/oxmysql.lua')

local MULTI = 'DELETE FROM a; DELETE FROM b'
local function refused()
    local err
    handle.getExport('oxmysql', 'query')(MULTI, {}, function(_, e) err = e end)
    return err == 'multi-statement refused'
end

h.test('default (convar unset) refuses multi-statement', function()
    convars = {}
    h.assertTrue(refused())
end)

h.test('truthy values true/1/yes allow multi-statement', function()
    for _, v in ipairs({ 'true', '1', 'yes' }) do
        convars = { qbsql_allow_multiple_statements = v }
        h.assertFalse(refused(), v .. ' should allow')
    end
end)

h.test('false/0/no/empty/other values keep it refused (matches JS parsing)', function()
    for _, v in ipairs({ 'false', '0', 'no', '', 'TRUE', 'on' }) do
        convars = { qbsql_allow_multiple_statements = v }
        h.assertTrue(refused(), v .. ' should refuse')
    end
end)

h.test('a refusal answers a cross-resource callback (function reference table), also in the params slot', function()
    convars = {}
    local err
    local ref = setmetatable({ __cfx_functionReference = 'ref' }, { __call = function(_, _, e) err = e end })
    handle.getExport('oxmysql', 'query')(MULTI, {}, ref)
    h.assertEqual(err, 'multi-statement refused')
    err = nil
    handle.getExport('oxmysql', 'query')(MULTI, ref)
    h.assertEqual(err, 'multi-statement refused')
end)

h.test('single statements are unaffected either way', function()
    convars = {}
    local err = 'x'
    handle.getExport('oxmysql', 'query')('SELECT 1;', {}, function(_, e) err = e end)
    h.assertTrue(err ~= 'multi-statement refused')
end)

h.report('oxmysql-multistatement')
