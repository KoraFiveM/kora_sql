local M = {}

function M.install()
    local exportEventHandlers = {}
    local providedExports = {}
    local jsCalls = {}
    local invokingResource = nil

    function _G.AddEventHandler(name, cb)
        exportEventHandlers[name] = cb
        if name:match('^__cfx_export_') then
            cb(function(func)
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
        if p and p.__resolved ~= nil then return p.__value end
        if p and p.__rejected then error(p.__error) end
        return nil
    end

    _G.promise = {
        new = function()
            return {
                resolve = function(self, v) self.__resolved = true; self.__value = v end,
                reject = function(self, e) self.__rejected = true; self.__error = e end,
            }
        end,
    }

    local kora_sql = {}
    setmetatable(kora_sql, {
        __index = function(_, name)
            return function(_self, ...)
                local args = { ... }
                table.insert(jsCalls, { name = name, args = args })
                for _, a in ipairs(args) do
                    if type(a) == 'function' then a({ ok = true, name = name }, nil) end
                end
                return { ok = true, name = name }
            end
        end,
    })
    _G.exports = { kora_sql = kora_sql }

    return {
        providedExports = providedExports,
        jsCalls = jsCalls,
        getExport = function(resource, name)
            return providedExports[resource .. '_' .. name]
        end,
        setInvokingResource = function(r) invokingResource = r end,
        lastCall = function(name)
            local ox = 'ox' .. name:sub(1, 1):upper() .. name:sub(2)
            for i = #jsCalls, 1, -1 do
                if jsCalls[i].name == name or jsCalls[i].name == ox then return jsCalls[i] end
            end
            return nil
        end,
        lastCallExact = function(name)
            for i = #jsCalls, 1, -1 do
                if jsCalls[i].name == name then return jsCalls[i] end
            end
            return nil
        end,
    }
end

return M
