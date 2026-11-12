---@meta

-- Resource manifest directives (fxmanifest.lua / __resource.lua).
-- These are not globals: plugin.lua binds each field to a local at the top of manifest files only,
-- so they never leak into runtime scripts (and `exports` keeps its runtime signature elsewhere).
-- [Documentation](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/)

---Directives may be chained to pass extra values, e.g. `data_file 'TYPE' 'path'`.
---@alias CfxManifestChain fun(value: any): CfxManifestChain

---@class CfxManifest
---@field fx_version fun(version: 'cerulean' | 'bodacious' | 'adamant'): CfxManifestChain
---@field game fun(game: 'gta5' | 'rdr3' | 'common'): CfxManifestChain
---@field games fun(games: ('gta5' | 'rdr3' | 'common')[]): CfxManifestChain
---@field rdr3_warning fun(text: string): CfxManifestChain
---@field lua54 fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field use_experimental_fxv2_oal fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field node_version fun(version: string): CfxManifestChain
---@field clr_disable_task_scheduler fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field author fun(author: string): CfxManifestChain
---@field description fun(description: string): CfxManifestChain
---@field version fun(version: string): CfxManifestChain
---@field repository fun(url: string): CfxManifestChain
---@field client_script fun(path: string): CfxManifestChain
---@field client_scripts fun(paths: string[]): CfxManifestChain
---@field server_script fun(path: string): CfxManifestChain
---@field server_scripts fun(paths: string[]): CfxManifestChain
---@field shared_script fun(path: string): CfxManifestChain
---@field shared_scripts fun(paths: string[]): CfxManifestChain
---@field file fun(path: string): CfxManifestChain
---@field files fun(paths: string[]): CfxManifestChain
---@field ui_page fun(path: string): CfxManifestChain
---@field loadscreen fun(path: string): CfxManifestChain
---@field loadscreen_manual_shutdown fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field loadscreen_cursor fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field export fun(name: string): CfxManifestChain
---@field exports fun(names: string[]): CfxManifestChain
---@field server_export fun(name: string): CfxManifestChain
---@field server_exports fun(names: string[]): CfxManifestChain
---@field dependency fun(resource: string): CfxManifestChain
---@field dependencies fun(resources: string[]): CfxManifestChain
---@field provide fun(resource: string): CfxManifestChain
---@field data_file fun(type: string): CfxManifestChain
---@field this_is_a_map fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field server_only fun(enabled: 'yes' | 'no'): CfxManifestChain
---@field before_level_meta fun(path: string): CfxManifestChain
---@field after_level_meta fun(path: string): CfxManifestChain
---@field replace_level_meta fun(path: string): CfxManifestChain
---@field convar_category fun(category: string): CfxManifestChain

---@type CfxManifest
__cfx_manifest = nil

fx_version = __cfx_manifest.fx_version
game = __cfx_manifest.game
games = __cfx_manifest.games
rdr3_warning = __cfx_manifest.rdr3_warning
lua54 = __cfx_manifest.lua54
use_experimental_fxv2_oal = __cfx_manifest.use_experimental_fxv2_oal
node_version = __cfx_manifest.node_version
clr_disable_task_scheduler = __cfx_manifest.clr_disable_task_scheduler
author = __cfx_manifest.author
description = __cfx_manifest.description
version = __cfx_manifest.version
repository = __cfx_manifest.repository
client_script = __cfx_manifest.client_script
client_scripts = __cfx_manifest.client_scripts
server_script = __cfx_manifest.server_script
server_scripts = __cfx_manifest.server_scripts
shared_script = __cfx_manifest.shared_script
shared_scripts = __cfx_manifest.shared_scripts
file = __cfx_manifest.file
files = __cfx_manifest.files
ui_page = __cfx_manifest.ui_page
loadscreen = __cfx_manifest.loadscreen
loadscreen_manual_shutdown = __cfx_manifest.loadscreen_manual_shutdown
loadscreen_cursor = __cfx_manifest.loadscreen_cursor
export = __cfx_manifest.export
exports = __cfx_manifest.exports
server_export = __cfx_manifest.server_export
server_exports = __cfx_manifest.server_exports
dependency = __cfx_manifest.dependency
dependencies = __cfx_manifest.dependencies
provide = __cfx_manifest.provide
data_file = __cfx_manifest.data_file
this_is_a_map = __cfx_manifest.this_is_a_map
server_only = __cfx_manifest.server_only
before_level_meta = __cfx_manifest.before_level_meta
after_level_meta = __cfx_manifest.after_level_meta
replace_level_meta = __cfx_manifest.replace_level_meta
convar_category = __cfx_manifest.convar_category

---@param value string
function name(value) end
