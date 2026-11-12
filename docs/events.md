---
title: Events
sidebar_position: 10
---

kora_sql has no network events and no client code.

## Local server events

| Event | Direction | Payload | Notes |
| --- | --- | --- | --- |
| `kora_sql:ready` | triggered | `{ server, isMariaDB, driver }` | Fired once the pools are up and `kora_sql_schema_owners` and `kora_sql_deadletter` exist. Resources that start before kora_sql can wait on it or call `Kora.sql.ready()`. |
| `kora_sql:internal:ready` | emitted by the JS host, handled by `server/ready.lua` | the same version table | Internal; it triggers `kora_sql:ready`. Do not rely on it. |
| `oxmysql:transaction-error` | triggered | `{ query, parameters, message, err, resource }` | Fired when a `transaction` rolls back, for compatibility with oxmysql listeners. `resource` is the calling resource or `'unknown'`. Not fired by `transactionChecked` or `startTransaction`. |
| `onResourceStop` | handled | resource name | On kora_sql stopping, the queue is flushed and pools are closed. Stops of `kora_inventory` and `kora_housing` reject pending native-bridge requests. |
| `__cfx_export_oxmysql_*`, `__cfx_export_mysql-async_*`, `__cfx_export_ghmattimysql_*` | handled | export setter | The export-identity mechanism used by the compat layers. See [Compatibility](./compatibility.md). |

## Callbacks

Data exports use a trailing callback `cb(result, errString)` (see [Exports](./exports.md)). `flush` and `awaitReady` call `cb(ok, errString)`.
