---
title: "Security and best practices"
sidebar_position: 10
---


# Security and best practices

What Kora SQL protects you from, what it does not, and the habits a database resource needs. Read this before exposing any query to player input.

Namespace: `Kora.sql` · Source: `server/js/execute.js, server/js/schema.js, server/js/batch.js, server/compat/oxmysql.lua`

## How it works

Kora SQL always executes through bound parameters, keeps the connection string on the server, refuses multi-statement text by default, validates schema identifiers, and never logs bound values. It cannot see your intent: it does not check who a player is, what they may change, or whether the SQL text you built is safe.

## Checklist for every database call

1. **No player text in the SQL string** — Values go in `params`. Table and column names, sort orders and operators come from your own fixed lists.
2. **Identity comes from the server** — Use `source` to find the player. Never trust a citizen id, license or account id sent by a client event.
3. **Validate type, range and permission first** — Check types, limits, ownership and cooldowns on the server before the query. Reject early.
4. **Make changes atomic** — Put the precondition in the `WHERE` clause and check the affected rows, or use `transactionChecked` for several statements.
5. **Avoid duplicate records** — Add a UNIQUE index (`indexes = { { name = ..., columns = ..., unique = true } }`), then use upsert or catch `duplicate` instead of "check, then insert".
6. **Query less** — Read once, cache in memory, and save changed rows through the write queue instead of per action.

## Terms used on this page

| Term | Meaning |
| --- | --- |
| SQL injection | An attack where input is parsed as SQL, letting a player read or change data they should not. Parameters prevent it. |
| Parameterised query | A statement with placeholders and a separate list of values. |
| Atomic update | A single statement that checks and changes data together, so two requests cannot both pass the check. |
| TOCTOU | "Time of check, time of use": checking a value in one query and acting on it in another lets a second request slip in between. Use one guarded statement or a transaction. |

## Who protects what

Built-in protections versus developer responsibilities.

| Option | Type | Description |
| --- | --- | --- |
| `Bound values` | built in | Every value in `params` is sent apart from the SQL text, for all query functions, transactions and the write queue. |
| `Connection string server-side` | built in | Read from a convar in the server process. There are no client scripts or client exports. |
| `Multi-statement text refused` | built in | Pool setting `multipleStatements` is off by default; the oxmysql bridge also refuses text with a trailing statement. |
| `Bound values not logged` | built in | Error logs show the first 500 characters of the SQL and the resource name, never bind values. Exception: `oxmysql:transaction-error` carries them. |
| `Schema identifiers whitelisted` | built in | `ensureTable` validates names, types and keywords and escapes defaults, comments and seed values. |
| `Identifier quoting` | built in | The write queue validates the table, conflict-key and column names as plain identifiers (`A-Za-z0-9_`, 1 to 64 characters), refuses anything else, and quotes them with backticks. |
| `Which SQL text you build` | developer | Kora SQL runs whatever text you give it. String concatenation reintroduces injection. |
| `Who may ask for an action` | developer | Check permissions, ownership and distance in your server code. |
| `Input validation` | developer | Check type, length, range and allowed values before querying. |
| `Sensitive data` | developer | Do not store or return data you do not need (licenses, identifiers, IPs). Select only the columns required; never send whole rows to clients. Grant the database user only the privileges it needs. |
| `Race conditions and duplicates` | developer | Use guarded updates, unique indexes and transactions. |
| `Backups` | developer | Back up the database regularly. The queue can lose up to one flush interval on a hard crash. |

## Handling sensitive player data

Keep personal data (license, discord id, IP, phone) out of logs, chat and client payloads. Query only the columns you use, return the minimum to clients, and give each resource’s data a clear owner. The database user in the connection string should not be an administrator account on a shared host.

## Transactions safely

Keep them short, order statements consistently to avoid deadlocks, never call out to other resources or wait for players inside one, and handle `indeterminate` by reading a receipt rather than retrying blindly. Remember DDL and non-database effects cannot be rolled back.

## Why clients must not control queries

A client can send any value to any event. If a client could supply SQL, a table name or a `WHERE` fragment, it could read every player’s data or delete tables. Expose narrow server events that take simple values and run fixed SQL.

## Avoiding unnecessary queries

Cache data you read often, batch related reads into one query with `IN (...)`, use the write queue for frequent saves, index the columns you filter on, add `LIMIT`, and use `kora_sql slow` to find the worst queries.

## Functions

Patterns that keep a resource safe. Each shows what Kora SQL does and what you must do.

### `Kora.sql.query(sql, params)`

Built-in protection: values in `params` are sent separately from the SQL text, so a value can never be parsed as SQL. Developer responsibility: you must put values in `params` instead of building strings.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `params` | table | All variable values. |

**Returns**

- **Rows or `nil, err`.**

**Example**

```lua
-- WRONG: the player's name becomes part of the SQL.
-- Kora.sql.query("SELECT * FROM players WHERE name = '" .. name .. "'")

-- RIGHT:
local rows = Kora.sql.query('SELECT * FROM players WHERE name = ?', { name })
```

**Representative console output**

```text
Kora SQL cannot detect string concatenation in your SQL text. It does not escape or filter the SQL you pass.
```

### `local column = allowed[input]`

Identifiers cannot be bound. `enqueue` and `upsert` accept only plain-identifier table and column names (`A-Za-z0-9_`, 1 to 64 characters) and quote them with backticks; `ensureTable` validates identifiers against a strict pattern and a type and keyword whitelist. Your own `Kora.sql.query` text is never checked.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `input` | string | A value that selects an allowed identifier. |

**Returns**

- **A name from your own table, or `nil` to refuse.**

**Example**

```lua
local SORT = { name = 'name', newest = 'created_at' }
local column = SORT[sortKey]
if not column then return nil, 'bad_sort' end
local rows = Kora.sql.query(('SELECT * FROM my_orders ORDER BY %s DESC LIMIT 50'):format(column))
```

**Representative console output**

```text
Never place player input into the SQL text, even after "cleaning" it.
```

### `Kora.sql.update(sql, params)`

Check type, range and ownership on the server first. The database will accept any value of the right type.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `amount` | integer | Example value from a client event. |

**Returns**

- **Affected rows or nil, err.**

**Example**

```lua
RegisterNetEvent('my_shop:server:buy', function(item, amount)
    local src = source
    amount = math.tointeger(amount)
    if not amount or amount < 1 or amount > 20 then return end
    if type(item) ~= 'string' or not ShopItems[item] then return end
    local player = exports.kora_core:getPlayer(src)      -- from the server, not the event
    if not player then return end
    local affected = Kora.sql.update('UPDATE my_stock SET qty = qty - ? WHERE item = ? AND qty >= ?', { amount, item, amount })
    if affected ~= 1 then return end
end)
```

**Representative console output**

```text
The guard `AND qty >= ?` makes the check atomic in the database, so two players cannot both buy the last item.
```

## Limits and related APIs

Kora SQL is a driver, not a permission system. It cannot know which tables are sensitive or which player may run which action.

## Related guides

- [Queries](./queries.md)
- [Transactions](./transactions.md)
- [Write queue](./write-queue.md)
