-- Mocks for smoke-testing qbsql's Lua compat layer under plain lua5.4 (no DB,
-- no FiveM). The compat files register handlers via the __cfx_export_ event and
-- forward calls into a mocked `exports.qbsql`; these mocks capture both so a
-- test can assert what was registered and what the JS side would have received
-- (including the crucial invokingResource attribution).

local M = {}

function M.install()
    local exportEventHandlers = {}   -- '__cfx_export_<res>_<name>' -> handler(setCB)
    local providedExports = {}       -- 'res:name' -> func (resolved via setCB)
    local jsCalls = {}               -- recorded exports.qbsql:<name>(...) calls
    local invokingResource = nil     -- what GetInvokingResource() returns

    function _G.AddEventHandler(name, cb)
        exportEventHandlers[name] = cb
        -- Immediately resolve the export by invoking setCB, mimicking FiveM
        -- calling the handler when another resource looks the export up.
        if name:match('^__cfx_export_') then
            cb(function(func)
                -- Key by the raw suffix (`<res>_<name>`). Splitting res from
                -- name is ambiguous (either can contain '_'), so getExport()
                -- below reconstructs the exact suffix from its two args.
                local key = name:gsub('^__cfx_export_', '')
                providedExports[key] = func
            end)
        end
    end

    function _G.GetInvokingResource() return invokingResource end
    function _G.GetCurrentResourceName() return 'consumer-under-test' end

    _G.GetGameTimer = (function()
        local t = 0
        return function() t = t + 16; return t end
    end)()

    function _G.Wait(_) end
    _G.Citizen = _G.Citizen or {}
    _G.Citizen.CreateThread = function(fn) fn() end
    _G.Citizen.Await = function(p)
        -- The mock promise resolves synchronously; return its stored value.
        if p and p.__resolved ~= nil then return p.__value end
        if p and p.__rejected then error(p.__error) end
        return nil
    end

    -- Minimal promise compatible with the compat files' usage.
    _G.promise = {
        new = function()
            return {
                resolve = function(self, v) self.__resolved = true; self.__value = v end,
                reject = function(self, e) self.__rejected = true; self.__error = e end,
            }
        end,
    }

    -- Mock exports table. exports.qbsql:<name>(self, ...) records the call and,
    -- for callback-style calls, invokes the trailing callback synchronously with
    -- a canned result so await paths resolve.
    local qbsql = {}
    setmetatable(qbsql, {
        __index = function(_, name)
            return function(_self, ...)
                local args = { ... }
                table.insert(jsCalls, { name = name, args = args })
                -- If a callback was passed (any arg is a function), call it with
                -- a canned success + no error.
                for _, a in ipairs(args) do
                    if type(a) == 'function' then a({ ok = true, name = name }, nil) end
                end
                return { ok = true, name = name }
            end
        end,
    })
    _G.exports = { qbsql = qbsql }

    return {
        providedExports = providedExports,
        jsCalls = jsCalls,
        -- Resolve a provided export by (resource, name) -- reconstructs the
        -- exact `<res>_<name>` suffix the __cfx_export_ event carried.
        getExport = function(resource, name)
            return providedExports[resource .. '_' .. name]
        end,
        setInvokingResource = function(r) invokingResource = r end,
        lastCall = function(name)
            for i = #jsCalls, 1, -1 do
                if jsCalls[i].name == name then return jsCalls[i] end
            end
            return nil
        end,
    }
end

return M
