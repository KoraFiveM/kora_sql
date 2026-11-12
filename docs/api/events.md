---
title: "Events"
sidebar_position: 8
---


# Events

Kora SQL has no client events and registers no network events. It triggers three server-local events: one for readiness and one for transaction rollbacks, plus an internal one it uses itself. Event names keep the legacy `kora_sql` and `oxmysql` spellings.

Namespace: `kora_sql:* · oxmysql:*` · Source: `server/ready.lua, server/js/index.js, server/js/transaction.js`

## How it works

The driver emits `kora_sql:internal:ready` when boot finishes. `server/ready.lua` latches it, prints the console line and triggers `kora_sql:ready`. A rolled-back `Kora.sql.transaction` triggers `oxmysql:transaction-error`. Events are local to the server; they cannot be triggered by a client.

## Functions

Subscribe with `AddEventHandler`. The listings show the handler signature.

### `AddEventHandler('kora_sql:ready', function(version) end)`

Server event triggered once, when the pool is connected. Use it to start code that needs the database.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `version` | table | The same table as `exports.kora_sql:version()`: `{ server, isMariaDB, driver }`. |

**Returns**

- **No return value. Registered by your resource; triggered by kora_sql with `TriggerEvent`.**

**Example**

```lua
AddEventHandler('kora_sql:ready', function(version)
    print('database up:', version.server)
    loadMyCaches()
end)
```

**Representative console output**

```text
A server-local event: it is never sent to clients. It fires once per start of kora_sql. A resource that subscribes after it fired never receives it, so also check `Kora.sql.ready()` or `exports.kora_sql:isReady()`.
```

### `AddEventHandler('kora_sql:internal:ready', function(version) end)`

Internal signal from the JavaScript driver to kora_sql’s own Lua file, which latches it and re-broadcasts `kora_sql:ready`. Registered inside kora_sql.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `version` | table | Version table. |

**Returns**

- **No return value.**

**Example**

```lua
-- Do not use this event from other resources. Listen to kora_sql:ready instead.
```

**Representative console output**

```text
Triggered with the driver’s `emit` once, after boot finishes. It also prints `[kora_sql:ready] driver up: <version>` to the console.
```

### `AddEventHandler('oxmysql:transaction-error', function(data) end)`

Server event triggered each time `Kora.sql.transaction` (and the oxmysql/mysql-async/ghmattimysql transaction exports) rolls back. Use it for logging or alerting.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `data` | table | `{ query = string, parameters = any, message = string, err = table, resource = string }`. `query` has one line per statement with JSON-encoded binds. `resource` is the caller or `unknown`. |

**Returns**

- **No return value. Registered by your resource; triggered by kora_sql.**

**Example**

```lua
AddEventHandler('oxmysql:transaction-error', function(data)
    print(('transaction from %s rolled back: %s'):format(data.resource, data.message))
end)
```

**Representative console output**

```text
The payload can contain bound values (identifiers, money). Do not send it to players or external services without removing them. It is not triggered by `transactionChecked`, `batch` or `startTransaction`.
```

## Other events kora_sql handles

| Event | Direction | Payload | Notes |
| --- | --- | --- | --- |
| `kora_sql:ready` | triggered | `{ server, isMariaDB, driver }` | Fired once the pools are up and `kora_sql_schema_owners` and `kora_sql_deadletter` exist. Resources that start before kora_sql can wait on it or call `Kora.sql.ready()`. |
| `oxmysql:transaction-error` | triggered | `{ query, parameters, message, err, resource }` | Fired when a `transaction` rolls back. `resource` is the calling resource or `'unknown'`. Not fired by `transactionChecked` or `startTransaction`. |
| `onResourceStop` | handled | resource name | When kora_sql stops, the queue is flushed and pools are closed. Stops of `kora_inventory` and `kora_housing` reject pending native-bridge requests. |
| `__cfx_export_oxmysql_*`, `__cfx_export_mysql-async_*`, `__cfx_export_ghmattimysql_*` | handled | export setter | The export-identity mechanism used by the compatibility layers. See [Compatibility](./compatibility.md). |

Data exports use a trailing callback `cb(result, errString)` (see [Driver exports](./driver-exports.md)). `flush` and `awaitReady` call `cb(ok, errString)`.

## Limits and related APIs

Server only. Never forward `oxmysql:transaction-error` data to a client. The readiness event fires only once, so combine it with `Kora.sql.ready()` for resources that may start later.

## Related guides

- [Transactions](./transactions.md)
- [Driver exports](./driver-exports.md)
