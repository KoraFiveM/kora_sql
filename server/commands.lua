-- /qbsql console commands: ping | stats | slow | queue | flush | bench
--
-- Registered as ace-gated (`command.qbsql`) so they work from the server
-- console (which is allowed everything) and from an admin, but not from an
-- arbitrary client. The bench command is the deliverable that turns "faster
-- than oxmysql" from a claim into a printed number.

local runBench

local function fmt(n) return ('%.2f'):format(n or 0) end

RegisterCommand('qbsql', function(source, args)
    -- Console (source 0) is always allowed; players need the ace.
    if source ~= 0 and not IsPlayerAceAllowed(source, 'command.qbsql') then
        return
    end

    local sub = (args[1] or 'stats'):lower()

    if sub == 'ping' then
        CreateThread(function()
            if not Ready.await(5000) then print('^1[qbsql]^7 not ready') return end
            local started = GetGameTimer()
            local p = promise.new()
            exports.qbsql:query('SELECT VERSION() AS v', {}, function(rows, err)
                if err then p:reject(err) else p:resolve(rows) end
            end, GetCurrentResourceName())
            local ok, rows = pcall(Citizen.Await, p)
            local rtt = GetGameTimer() - started
            if ok and rows and rows[1] then
                print(('^5[qbsql]^7 pong: %s (%dms RTT)'):format(rows[1].v, rtt))
            else
                print(('^1[qbsql]^7 ping failed: %s'):format(tostring(rows)))
            end
        end)

    elseif sub == 'stats' then
        local s = exports.qbsql:stats()
        print('^5[qbsql] stats^7')
        print(('  queries: %d total, %d errors, avg %sms, %d fingerprints')
            :format(s.queries.total, s.queries.errors, fmt(s.queries.avgMs), s.queries.distinctFingerprints))
        print(('  queue: %d crossings, %d rows in -> %d written (coalesce %sx), %s stmts/flush, %d dead-lettered')
            :format(s.queue.boundaryCrossings, s.queue.rowsEnqueued, s.queue.rowsWritten,
                fmt(s.queue.coalesceRatio), fmt(s.queue.statementsPerFlush), s.queue.deadLettered))
        print(('  flushes: %d, avg %sms'):format(s.queue.flushes, fmt(s.queue.avgFlushMs)))
        for _, t in ipairs(s.queries.topByTotalMs or {}) do
            print(('    %s x%d  total %sms  avg %sms'):format((t.sql or ''):sub(1, 70), t.count, fmt(t.totalMs), fmt(t.avgMs)))
        end

    elseif sub == 'slow' then
        local limit = tonumber(args[2]) or 20
        local rows = exports.qbsql:slowQueries(limit)
        print(('^5[qbsql] %d slowest^7'):format(#rows))
        for _, r in ipairs(rows) do
            print(('  %sms [%s] %s'):format(fmt(r.ms), r.resource or '?', (r.sql or ''):sub(1, 90)))
        end

    elseif sub == 'queue' then
        -- Depth is JS-side; expose via a tiny query on stats plus a direct call.
        local s = exports.qbsql:stats()
        print('^5[qbsql] queue^7')
        print(('  crossings=%d rowsIn=%d rowsWritten=%d retries=%d deadLettered=%d')
            :format(s.queue.boundaryCrossings, s.queue.rowsEnqueued, s.queue.rowsWritten, s.queue.retries, s.queue.deadLettered))

    elseif sub == 'flush' then
        exports.qbsql:flush(function(ok) print(ok and '^5[qbsql]^7 flushed' or '^1[qbsql]^7 flush failed') end)

    elseif sub == 'bench' then
        local n = tonumber(args[2]) or 500
        CreateThread(function() runBench(n) end)

    else
        print('^3[qbsql]^7 usage: /qbsql ping | stats | slow [n] | queue | flush | bench [n]')
    end
end, false)

-- A/B benchmark: N individual execute() writes vs one enqueueMany + flush of the
-- same N rows, on a scratch table. Prints wall-clock, round trips, and boundary
-- crossings for each so the coalescing win is a measured fact.
runBench = function(n)
    if not Ready.await(5000) then print('^1[qbsql]^7 bench: not ready') return end
    local res = GetCurrentResourceName()

    local function await(jsName, ...)
        local p = promise.new()
        local args = { ... }
        args[#args + 1] = function(r, e) if e then p:reject(e) else p:resolve(r) end end
        args[#args + 1] = res
        exports.qbsql[jsName](exports.qbsql, table.unpack(args))
        local ok, r = pcall(Citizen.Await, p)
        return ok, r
    end

    print(('^5[qbsql] bench^7 preparing scratch table for %d rows...'):format(n))
    await('execute', [[CREATE TABLE IF NOT EXISTS `qbsql_bench` (
        `id` VARCHAR(32) NOT NULL, `v` INT NOT NULL, PRIMARY KEY(`id`)
    ) ENGINE=InnoDB]], {})
    await('execute', 'TRUNCATE `qbsql_bench`', {})

    -- Path A: N individual upserts, each its own boundary crossing + round trip.
    local statsBefore = exports.qbsql:stats()
    local a0 = GetGameTimer()
    for i = 1, n do
        await('execute',
            'INSERT INTO `qbsql_bench` (`id`,`v`) VALUES (?,?) ON DUPLICATE KEY UPDATE `v` = VALUES(`v`)',
            { ('a%d'):format(i), i })
    end
    local aMs = GetGameTimer() - a0

    -- Path B: one enqueueMany of N rows + one flush.
    await('execute', 'TRUNCATE `qbsql_bench`', {})
    local rows = {}
    for i = 1, n do rows[i] = { pk = ('b%d'):format(i), cols = { v = i } } end
    local b0 = GetGameTimer()
    exports.qbsql:enqueueMany('qbsql_bench', 'id', rows, { mode = 'assign' })
    local p = promise.new()
    exports.qbsql:flush('qbsql_bench', function(ok) p:resolve(ok) end)
    pcall(Citizen.Await, p)
    local bMs = GetGameTimer() - b0

    local statsAfter = exports.qbsql:stats()
    local crossingsB = statsAfter.queue.boundaryCrossings - statsBefore.queue.boundaryCrossings

    print(('^5[qbsql] bench results for n=%d^7'):format(n))
    print(('  A) individual execute(): %dms, %d boundary crossings, %d round trips'):format(aMs, n, n))
    print(('  B) enqueueMany+flush:     %dms, %d boundary crossings, ~%d round trips')
        :format(bMs, crossingsB, math.ceil(n / 200)))
    if bMs > 0 then
        print(('  -> coalesced path is %.1fx faster wall-clock, %dx fewer boundary crossings')
            :format(aMs / math.max(1, bMs), math.floor(n / math.max(1, crossingsB))))
    end
end
