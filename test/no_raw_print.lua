-- Guard: fails if raw print()/Kora.print./console.* diagnostics reappear outside test/print_allowlist.txt.
-- Run from the repo root: lua test/no_raw_print.lua
local allow = {}
local f = io.open('test/print_allowlist.txt', 'r')
if f then
    for line in f:lines() do
        local path = line:match('^%s*([^:#]+):')
        if path then allow[#allow + 1] = path:gsub('%s+$', '') end
    end
    f:close()
end
local function allowed(path)
    for _, a in ipairs(allow) do
        if path == a or (a:sub(-1) == '/' and path:sub(1, #a) == a) then return true end
    end
    return false
end
local p = io.popen([[find . -type f \( -name '*.lua' -o -name '*.js' \) -not -path './node_modules/*' -not -path './.git/*' -not -path './test/*' -not -path './tests/*' -not -path '*/build/*' -not -path '*/dist/*' -not -name '*.min.js' | sed 's|^\./||' | sort]])
local bad = {}
for path in p:lines() do
    if not allowed(path) then
        local fh = io.open(path, 'r')
        if fh then
            local n = 0
            for line in fh:lines() do
                n = n + 1
                local code = line:gsub('%-%-.*$', ''):gsub('//.*$', '')
                if code:find('[^%w_.:]print%s*%(') or code:find('^%s*print%s*%(') or code:find('Kora%.print%.') or code:find('console%.[lw][oa][gr]')
                    or code:find('console%.error') then
                    bad[#bad + 1] = ('%s:%d: %s'):format(path, n, line:gsub('^%s+', ''):sub(1, 100))
                end
            end
            fh:close()
        end
    end
end
p:close()
if #bad > 0 then
    io.stderr:write(('no_raw_print: %d raw diagnostic call(s) found:\n  %s\n'):format(#bad, table.concat(bad, '\n  ')))
    os.exit(1)
end
print('no_raw_print: ok')
