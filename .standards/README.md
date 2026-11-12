# Kora Lua tooling

Standards revision: **2026-11-12.1**. Canonical policy:
[Contributing to Kora](https://github.com/KoraFiveM/kora_docker_dev/blob/main/CONTRIBUTING.md).
In a resource checkout, read `CONTRIBUTING.md` and local/module `AGENTS.md` first.

## Install once

Use Python 3.10+ and install these exact official releases on your PATH:

- [StyLua 2.6.0](https://github.com/JohnnyMorganz/StyLua/releases/tag/v2.6.0).
- [LuaLS 3.19.2](https://github.com/LuaLS/lua-language-server/releases/tag/3.19.2).

Choose the asset for your OS/architecture. Extract the **whole LuaLS distribution**,
not just its executable: it needs its scripts and standard library metadata.
On Windows, run these commands in WSL with Linux binaries. Verify `stylua --version`
and `lua-language-server --version`. Alternatively set `KORA_STYLUA` and
`KORA_LUA_LANGUAGE_SERVER` to executable paths (paths may contain spaces).

Tool versions and definition provenance are recorded in `versions.json` and
`definitions/PROVENANCE.md` alongside this guide. Definitions are included locally;
checks never fetch dependencies, execute source Lua, or start a server. No global
FiveM editor addon is needed for the CLI. Missing/wrong tool versions and missing
definitions are errors, not successful skipped checks.

## Commands in an adopted resource

Run from the resource root, independently of the Docker setup:

```sh
python3 tools/lua_quality.py check
python3 tools/lua_quality.py check server/server.lua
python3 tools/lua_quality.py lint --realm server
python3 tools/lua_quality.py lint --realm client
python3 tools/lua_quality.py format client/client.lua
python3 tools/lua_quality.py list
```

Use paths that exist in your resource; its CONTRIBUTING.md gives specific examples.
`check` runs StyLua without rewriting plus LuaLS. `lint` runs LuaLS only.
`format` rewrites only explicitly named files/directories and refuses no-target
invocation. `list` validates and prints the source/realm inventory without tools.
Targets are checkout-relative even when invoking the script from another directory.
An optional `--root PATH` supports testing a separate checkout.

Exit codes: 0 = clean, 1 = formatting/diagnostic findings, 2 = tooling/configuration
error. Source code is never rewritten by check/lint; temporary workspaces and logs
are removed after analysis. All selected diagnostics are printed with original
resource-relative filenames and realm labels. Undefined globals/fields, type mismatches and unused locals/functions/labels
are reported at warning level. Full-resource findings remain
visible; there is no debt baseline or suppression mechanism.

For a small change, run checks against the affected files and run relevant behavior
tests. Review findings in context: fix newly introduced diagnostics, and report
pre-existing failures separately. This adoption does not claim existing code passes.
Pipeline enforcement and hooks will be a separate PR.

## Source and realm inventory

`.standards/resource.json` lists client, server, shared, manifest and test Lua files.
Add new source files to it in the same change; unclassified or stale entries fail.
Keep the runtime manifest and inventory consistent. The inventory documents extra
files loaded dynamically or shipped for consumer includes as well as manifest scripts.
Never assign a server file to `shared` merely to silence a missing native.

Client/server checks each receive their own context plus shared source. Shared code
also gets a shared-only pass so client/server APIs cannot quietly leak into it.
Manifests get only manifest directive definitions. Each test program gets its own context (following literal local imports) and
mock definitions, without adding those mocks to runtime analysis. External test imports are reported as unindexed findings without reading sibling
repositories. Make these test dependencies local before expecting a clean full-resource check. Existing tests
that deliberately mix realms still need review; static diagnostics do not prove
mock fidelity. Explicit `IsDuplicityVersion()` branches in consumer includes may
need a narrowly documented exception or split implementation; no automatic
path-insensitive suppression is applied.

Native definitions preserve the upstream client/server/shared markers. Kora fields
are filtered by their documented realm annotations; unmarked data types remain
shared. Dynamic exports are not fully typed, so LuaLS cannot prove every cross-resource
call or permission check correct. Add accurate annotations to the owning API.
If resource-specific declarations are needed, add annotation-only Lua files under
`.standards/definitions-client/`, `definitions-server/`, `definitions-shared/`,
`definitions-test/` or `definitions-manifest/`; client/server contexts also load
shared declarations. No catch-all global or Kora field allowlists.

Dependencies, browser output, vendor trees, runtime data, definition snapshots and
generated lookup bundles are excluded explicitly. Runtime `build/initiate.lua` and
`build/finalise.lua` remain included: a directory called `build` is not necessarily
generated code. Do not add broad exclusions for first-party feature code.

## Editor setup

Use the StyLua extension as the Lua formatter with the committed `.stylua.toml`;
do not enable whole-workspace auto-formatting on adoption. Use the LuaLS extension
for annotated APIs and set runtime version to Lua 5.4 with the backtick CfxLua symbol.
Avoid a workspace-wide addon that registers every FiveM native in both realms.
The CLI's isolated contexts are authoritative for realm checks; an editor that
indexes client and server together cannot enforce that boundary by itself.
Editor-only settings must not broaden the committed CLI globals or suppress diagnostics.

## Updating the shared snapshot

The setup repo's `standards/lua/` owns templates, policy and pinned definitions.
`tools/sync_lua_standards.py --check` reports drift in adopted resources;
`python3 tools/sync_lua_standards.py` refreshes shared tooling copies only.
Review each resource diff separately. This explicit local command never commits,
pushes, switches branches, fetches resources, or changes runtime manifests.

Resource-specific inventories, local definitions and testing commands are maintained
in the resource and are not replaced on refresh. Change the revision when shared
templates change. Update definition provenance, pins and fixtures together; do not
replace precise declarations with `any` to get a clean check.

Maintainers can rebuild derived declarations with
`python3 tools/build_lua_definitions.py --addon /path/to/pinned-addon --kora-types resources/pre/kora_lib/types.lua`
from the setup checkout. Use the exact addon revision in versions.json and review
the manually maintained Kora extension declarations against their owning sources.
Keep the upstream MIT notice with every snapshot.
