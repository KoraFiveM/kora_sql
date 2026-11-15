local isReady = false

AddEventHandler('kora_sql:internal:ready', function(version)
    isReady = true
    Kora.logging.info('driver.ready', 'SQL driver is up', { version = version and version.server or 'unknown' })
    TriggerEvent('kora_sql:ready', version)
end)

Ready = Ready or {}

function Ready.isReady()
    return isReady
end

function Ready.await(timeoutMs)
    if isReady then return true end
    local deadline = GetGameTimer() + (timeoutMs or 60000)
    while not isReady do
        if GetGameTimer() > deadline then return false end
        Wait(50)
    end
    return true
end
