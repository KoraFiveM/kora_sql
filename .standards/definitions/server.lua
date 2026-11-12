---@meta
---@type integer
source = 0
RegisterServerEvent = RegisterNetEvent
---@param name string
---@param target integer
---@param ... any
function TriggerClientEvent(name, target, ...) end
---@param name string
---@param target integer
---@param bps number
---@param ... any
function TriggerLatentClientEvent(name, target, bps, ...) end
---@param src integer|string
---@return string[]
function GetPlayerIdentifiers(src) end
---@param src integer|string
---@return string[]
function GetPlayerTokens(src) end
---@return string[]
function GetPlayers() end
---@param url string
---@param callback fun(status: integer, body?: string, headers?: table, errorData?: string)
---@param method? string
---@param data? string
---@param headers? table
---@param options? table
function PerformHttpRequest(url, callback, method, data, headers, options) end
