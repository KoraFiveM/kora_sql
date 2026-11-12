# Kora Framework definition provenance

FiveM signatures and runtime annotations are derived from
https://github.com/overextended/fivem-lls-addon at
`ef5f08e5e1d4a176586a5befbe0a9ff8400c58fc` (MIT; see LICENSE-FIVEM).
GTAV native signatures are client-only; CFX signatures retain upstream realm
markers. Runtime event/NUI declarations are split manually by documented realm.
Native prose is omitted; parameter/return annotations and signatures are retained.
No addon plugin or transformation code executes during checks.

Kora Framework declarations are a local snapshot of kora_lib/types.lua, split using its
existing [client], [server], [shared] and [client/server] field markers.
Unmarked data types remain available in every runtime realm. The snapshot does
not invent signatures for dynamic exports or guarantee every API is annotated.
Resource API annotations and these snapshots must evolve together.

Library diagnostics are disabled for these declaration files, not resource code.
Unknown runtime globals and fields remain diagnostics. Add narrow declarations
for genuine APIs, never a catch-all Kora Framework field or a global-name wildcard.

Kora Framework shared-registry and SQL extension signatures are manually reviewed against
kora_core/init.lua and kora_sql/init.lua. SQL declarations are server-only. These
opt-in APIs still require the corresponding include/dependency at runtime.

---

Copyright © 2026 Kora Framework.
