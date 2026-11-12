# Contributing to kora_sql

Humans and agents use the [shared Kora contribution standards](https://github.com/KoraFiveM/kora_docker_dev/blob/main/CONTRIBUTING.md)
(revision **2026-11-12.1**) and the self-contained [local Lua tooling guide](.standards/README.md).
Read this resource's README where present, AGENTS.md and relevant module guides first.

For new and relevant changed code: use four spaces, camelCase and StyLua's single-quote/120-column
style; keep transport handlers thin, server authority explicit, and compatibility adapters
on the owning implementation. Reuse Kora APIs and validators; place generic mechanics in
kora_lib and domain rules with their owner. Document public APIs, yielding/failure behavior
and cleanup. Keep unrelated reformats and restructuring separate.

## Local commands

Install the pinned StyLua/LuaLS releases from the local tooling guide and Python 3.10+.
Run from this repository root:

```sh
python3 tools/lua_quality.py list
python3 tools/lua_quality.py check
python3 tools/lua_quality.py lint
python3 tools/lua_quality.py check config.lua
python3 tools/lua_quality.py format config.lua
```

Formatting requires explicit targets. Check/lint never rewrite source; full-resource
checks expose existing debt and may fail before your change. Fix introduced findings,
report pre-existing failures, and use `--realm client` or `--realm server` for focused diagnostics.
Add new Lua files to `.standards/resource.json` with their actual realm and update the
runtime manifest where needed. No pipeline enforcement or automatic hooks are installed.

## Behavior tests

- `bash test/run.sh` (follow the local guide for interpreter/dependency requirements).

Add focused regression coverage for meaningful rules, public contracts, adapters and
failure/lifecycle paths. State in-game checks separately. Update matching docs in the
same change, inspect the diff, and report what passed, failed or was not run.

## Local constraints and policy reconciliation

Local/module AGENTS.md constraints remain binding. The shared manifest policy
requires explicit ordering where it matters; kora_lib's existing order-independent
module globs remain supported. Older local wording that says every manifest must
be non-globbed does not require rewriting unrelated manifests. LuaLS CLI contexts
are isolated even when an existing smoke test intentionally loads both realms.

Keep database work server-only, preserve cross-runtime caller attribution and existing JS build/test requirements. The Lua tooling does not validate the Node driver.


Changes belong to this resource repository, separately from Docker setup and docs-site
changes. Shared tooling is a local snapshot; do not introduce a dependency on the setup
checkout. Keep resource-specific inventory and definitions when refreshing the snapshot.
