-- Smoke test: the console command is registered as /kora_sql with /qbsql kept
-- as an alias and kora_sql log prefixes (F#276), and config.lua no longer
-- carries the dead installMySQLGlobal toggle (F#274).

local h = dofile('test/harness.lua')

local registered, printed, aces = {}, {}, {}
function _G.RegisterCommand(name, fn) registered[name] = fn end
function _G.IsPlayerAceAllowed(_, ace) return aces[ace] == true end
function _G.CreateThread(fn) fn() end
function _G.GetCurrentResourceName() return 'kora_sql' end
local realPrint = print
_G.Ready = { await = function() return true end }

dofile('server/commands.lua')

local function capture(fn)
    printed = {}
    _G.print = function(...) printed[#printed + 1] = table.concat({ ... }, ' ') end
    local ok, err = pcall(fn)
    _G.print = realPrint
    assert(ok, err)
    return printed
end

h.test('registers /kora_sql and keeps /qbsql as an alias with the same handler', function()
    h.assertTrue(registered.kora_sql ~= nil, '/kora_sql must be registered')
    h.assertTrue(registered.qbsql ~= nil, '/qbsql alias must stay registered')
    h.assertTrue(registered.kora_sql == registered.qbsql, 'both commands share one handler')
end)

h.test('usage output uses the kora_sql prefix', function()
    local out = capture(function() registered.qbsql(0, { 'nope' }) end)
    h.assertTrue(out[1] and out[1]:find('[kora_sql]', 1, true) ~= nil, tostring(out[1]))
    h.assertTrue(out[1]:find('/kora_sql', 1, true) ~= nil, tostring(out[1]))
end)

h.test('either ace unlocks the command for players', function()
    aces = { ['command.kora_sql'] = true }
    h.assertEqual(#capture(function() registered.kora_sql(1, { 'nope' }) end), 1)
    aces = { ['command.qbsql'] = true }
    h.assertEqual(#capture(function() registered.kora_sql(1, { 'nope' }) end), 1)
    aces = {}
    h.assertEqual(#capture(function() registered.kora_sql(1, { 'nope' }) end), 0)
end)

h.test('config.lua drops the dead installMySQLGlobal toggle', function()
    local passthrough = function(v) return v end
    local descriptions
    _G.Kora = { config = {
        boolean = passthrough, integer = passthrough,
        adopt = function(cfg, opts) descriptions = opts.descriptions; return cfg end,
    } }
    _G.Config = nil
    dofile('config.lua')
    h.assertEqual(Config.compat.installMySQLGlobal, nil)
    h.assertEqual(descriptions['compat.installMySQLGlobal'], nil)
    h.assertTrue(Config.compat.oxmysql == true, 'other compat toggles stay')
    h.assertTrue(descriptions['sql.awaitTimeout']:find('Retained', 1, true) == nil,
        'awaitTimeout description should no longer say it is unused')
end)

h.report('commands_config')
