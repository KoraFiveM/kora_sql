---@meta
-- Kora Framework integration. Copyright © 2026 Kora Framework.
---@type EntityInterface
LocalPlayer = {}
---@param name string
---@param ... any
function TriggerServerEvent(name, ...) end
---@param name string
---@param bps number
---@param ... any
function TriggerLatentServerEvent(name, bps, ...) end
---@param name string
---@param callback fun(data: any, reply: function)
function RegisterNUICallback(name, callback) end
---@param data table
function SendNUIMessage(data) end
