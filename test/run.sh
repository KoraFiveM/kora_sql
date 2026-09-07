#!/usr/bin/env bash
# Runs the Lua smoke tests (plain lua, no busted) and then the JS suite via
# Node's built-in test runner. Exits non-zero if anything failed.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
lua_bin="${LUA:-lua}"
status=0

for file in "$dir"/smoke/*.lua; do
    echo "== $(basename "$file" .lua) =="
    if ! ( cd "$dir/.." && "$lua_bin" "test/smoke/$(basename "$file")" ); then status=1; fi
    echo
done

echo "== js (node --test) =="
# The resource path contains '[test]', which Node's --test treats as a glob
# character class -- an absolute path fails to match. cd into the test dir so
# the paths handed to Node are bracket-free and relative.
if ! ( cd "$dir" && node --test js/batch.test.js js/queue.test.js js/migrate.test.js js/params.test.js js/execute.test.js js/exports.test.js js/transaction.test.js js/startup.test.js ); then status=1; fi

# Integration tests need a live DB; only run when a DSN is provided.
if [ -n "${QBSQL_TEST_DSN:-}" ]; then
    echo "== integration =="
    if ! ( cd "$dir" && node --test integration/*.test.js ); then status=1; fi
fi

exit "$status"
