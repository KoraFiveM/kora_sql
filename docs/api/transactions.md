---
title: "Transactions"
sidebar_position: 3
---


# Transactions

Run several statements as one unit (`transaction`), as a sequence on one connection (`batch`), or as a checked unit that also verifies how many rows each statement touched (`transactionChecked`). Transactions use a dedicated connection from the write pool and need transactional tables (InnoDB).

Namespace: `Kora.sql` · Source: `init.lua, server/js/transaction.js`

## How it works

A transaction takes one connection from the write pool, issues BEGIN, runs each statement in order, then COMMIT. On any error it issues ROLLBACK, logs the failure and returns a failure value. `batch` uses one connection but no BEGIN/COMMIT. The checked variant compares each statement’s row count to `expectedRows` before it moves on, so a precondition such as “balance was high enough” is enforced inside the transaction. A connection whose ROLLBACK failed is destroyed, never reused.

## Follow these steps for money-like changes

1. **Write every statement as a guarded change** — Put the precondition in the SQL (`WHERE balance >= ?`) and set `expectedRows = 1`. Then a lost race or an insufficient balance rolls everything back instead of committing a wrong state.
2. **Write a receipt in the same transaction** — Insert a row with a unique key (for example the operation id) as one of the statements. A repeat of the same operation then fails with `duplicate` and cannot apply twice.
3. **Handle each outcome** — `success`: continue. `insufficient_funds` (your code): tell the player. `duplicate`: treat as already done. `unavailable`: safe to retry later. `indeterminate`: do not assume either result; read your receipt row to find out.
4. **Keep the transaction short** — Do reads and validation first, then run only the writes inside the transaction. Never wait on players, HTTP calls or other resources while it is open.

## Terms used on this page

| Term | Meaning |
| --- | --- |
| Rollback | Undoing every statement of the transaction because one failed or a precondition did not hold. |
| Indeterminate | Kora SQL cannot tell whether the changes were committed (the COMMIT reply was lost or the ROLLBACK failed). Never retry blindly; check a durable receipt. |
| Receipt | A row your own code writes inside the transaction (with a unique key) to prove the operation happened. It is what makes retries safe. |
| Operation key / fingerprint | Optional in-memory identifiers that let a repeated `transactionChecked` call join one that is still running. The fingerprint describes the terms; a same key with different terms is refused. |

## Statement fields

Each statement in a list can be one of: a plain SQL string (uses the shared `params` argument), a pair `{ 'SQL', { params } }`, or a table with these fields. A `?` after a name means the option is optional.

| Option | Type | Description |
| --- | --- | --- |
| `sql` | string | Required (or `query`). The statement text. |
| `query?` | string | Alias of `sql`. When both are present `query` wins. |
| `params??` | table | Bind values. Aliases: `values` and `parameters`. Lookup order is `parameters`, then `values`, then `params`. |
| `expectedRows??` | integer | `transactionChecked` only. Non-negative integer: the number of rows a SELECT must return, or the `affectedRows` a write must report. A different count rolls everything back. A negative or non-integer value raises a TypeError. |
| `failureCode??` | string | `transactionChecked` only. The `code` returned when this statement’s `expectedRows` does not match. Defaults to `'conflict'`. |

## Statement forms

`transaction` and `batch` accept: a list of strings with shared params `({ 'SQL1', 'SQL2' }, sharedParams)`; a list of tables `{ { sql = '...', params = {...} } }` or `{ { query = '...', values = {...} } }`; a list of pairs `{ { 'SQL', { ... } } }`; and one string with a list of parameter lists `('SQL', { { ... }, { ... } })`. `transactionChecked` takes a list only. Named `:name` / `@name` binds work in every form.

## Failure values differ by function

`batch` returns `nil, message`. `transaction` returns `false` with no message. `transactionChecked` returns `outcome` with `success = false` and a `code`, and returns `nil, message` only for an invalid call. Check the one you use.

## oxmysql:transaction-error

When `transaction` rolls back it triggers the server event `oxmysql:transaction-error` with a table `{ query, parameters, message, err, resource }`. `query` is every statement with its JSON-encoded binds, one per line. It can contain bound values, so do not forward it to untrusted channels. `transactionChecked`, `batch` and `startTransaction` do not trigger it.

## Limits of rollback

DDL (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`) commits implicitly in MySQL and cannot be rolled back. Neither can anything outside the database: item grants in memory, events sent to players, HTTP calls. Run those after a successful commit.

## In-flight deduplication

Operations passed with `operation.key` are tracked in memory only while they run. A second call with the same key and the same fingerprint returns the first call’s outcome; the same key with a different fingerprint returns an `indeterminate` failure. This is a bridge for restarts, not durable idempotency: durability needs your own receipt row. `exports.kora_sql:hasActivePlayerOperation(citizenid)` returns true while a running checked operation lists that citizen id in `operation.citizenids`.

## Functions

Three runners, plus two helpers for the checked runner’s in-flight operations. Statements can be written in several shapes (below).

### `Kora.sql.batch(statements)`

Runs a list of statements one after another on one connection from the write pool. There is no transaction: a failure leaves earlier statements committed. Use it to avoid taking a connection per statement for independent writes.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `statements` | table[] | Required list. Each entry is a statement table `{ sql = ..., params = {...} }`, a pair `{ 'SQL', {...} }` or a plain SQL string (see Statement forms below). |

**Returns**

- **results** — list with one raw mysql2 result per statement (result header for writes, row array for SELECT).
- **err** — `nil` on success, otherwise the message (results is `nil`). Statements before the failing one have already been applied.

**Example**

```lua
local results, err = Kora.sql.batch({
    { sql = 'INSERT INTO my_log (citizenid, action) VALUES (?, ?)', params = { cid, 'login' } },
    { sql = 'UPDATE players SET last_seen = NOW() WHERE citizenid = ?', params = { cid } },
})
if err then print('batch stopped:', err) end
```

**Representative console output**

```text
Statements run through prepared statements on the pinned connection, in order. The connection is released afterwards, success or failure.
```

### `Kora.sql.transaction(statements, params?)`

Runs every statement between `BEGIN` and `COMMIT` on one connection. Any error rolls everything back and returns `false`. Also accepts one SQL string with a list of parameter lists, which runs that statement once per list inside the same transaction.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `statements` | table[] \| string | Required. A list of statements (see Statement forms) or a single SQL string. |
| `params?` | table | With a list of strings, parameters shared by every statement. With a single SQL string, a list of parameter lists `{ {p1}, {p2}, ... }`; one list is also accepted. |

**Returns**

- **ok** — `true` after COMMIT, `false` after a rollback.
- **No error string is returned. Failures are printed to the console as `kora_sql transaction rolled back: <message>` and also raised as the event `oxmysql:transaction-error`.**

**Example**

```lua
local ok = Kora.sql.transaction({
    { sql = 'UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?', params = { 500, fromId, 500 } },
    { sql = 'UPDATE accounts SET balance = balance + ? WHERE id = ?', params = { 500, toId } },
})
if not ok then
    return false, 'transfer_failed'
end

-- One statement, many parameter sets, all in one transaction:
Kora.sql.transaction('INSERT INTO my_items (owner, name) VALUES (?, ?)', {
    { cid, 'bread' }, { cid, 'water' }, { cid, 'phone' },
})
```

**Representative console output**

```text
Statements run through mysql2’s text protocol on the pinned connection (values are escaped by the driver). If the ROLLBACK itself fails the connection is destroyed instead of returned to the pool. A statement that merely matches zero rows is not an error: use transactionChecked when that matters.
```

### `Kora.sql.transactionChecked(statements, operation?)`

A transaction that also verifies row counts before committing and returns a structured outcome instead of a boolean. Use it for money, inventory and ownership changes where "the SQL ran" is not the same as "the change was valid".

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `statements` | table[] | Required, non-empty list of statements. Each may carry `expectedRows` and `failureCode` (see Statement fields). |
| `operation?` | table | Optional `{ key = string, fingerprint = string, citizenids? = string[] }` that lets a repeated call join the one already running. Both `key` and `fingerprint` must be strings or the call fails with `Checked operation needs key and fingerprint`. |

**Returns**

- **outcome** — `{ success = true, results = {...} }` after COMMIT (`results` holds one raw mysql2 result per statement), or `{ success = false, code, statement, message }` after a rollback.
- **err** — `nil` normally. Set (with `outcome` nil) only when the call itself was invalid: empty or non-table statements, a bad `expectedRows`, a missing key or fingerprint.

**Example**

```lua
local outcome, err = Kora.sql.transactionChecked({
    { sql = 'UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?', params = { 500, fromId, 500 },
      expectedRows = 1, failureCode = 'insufficient_funds' },
    { sql = 'UPDATE accounts SET balance = balance + ? WHERE id = ?', params = { 500, toId }, expectedRows = 1 },
    { sql = 'INSERT INTO transfer_receipts (receipt_id, from_id, to_id, amount) VALUES (?, ?, ?, ?)', params = { receiptId, fromId, toId, 500 } },
})
if err then return false, err end                 -- invalid call
if not outcome.success then
    if outcome.code == 'insufficient_funds' then return false, 'not_enough_money' end
    if outcome.code == 'indeterminate' then return false, 'check_receipt_first' end
    return false, outcome.code
end
return true
```

**Representative console output**

```text
Failure codes: your `failureCode` (default `conflict`) for a row-count mismatch; `duplicate` for a duplicate-key error; `unavailable` for any other database error; `indeterminate` when the COMMIT reply was lost or the rollback failed. `statement` is the 1-based index of the statement that was running. For anything except your own failureCode, `message` is the generic text `Database transaction could not be confirmed`.
```

### `Kora.sql.awaitCheckedOperation(key, fingerprint?)`

Joins a checked operation that is already running under `key` without sending any SQL. After a consumer resource restarts it lets you wait for the work the previous instance started before you read its receipt.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `key` | string | The `operation.key` given to `transactionChecked`. |
| `fingerprint?` | string | When given, it must equal the running operation’s fingerprint; otherwise the result is an indeterminate failure. |

**Returns**

- **state** — `{ active = false }` when nothing is running under that key, otherwise `{ active = true, result = outcome }` once the operation settles.
- **err** — `nil` on success, otherwise the message.

**Example**

```lua
local state = Kora.sql.awaitCheckedOperation('transfer:' .. receiptId, fingerprint)
if state and state.active then
    -- state.result is the same outcome table transactionChecked returned
    print('earlier worker finished with', state.result.success and 'success' or state.result.code)
end
```

**Representative console output**

```text
A fingerprint mismatch returns `{ active = true, result = { success = false, code = 'indeterminate', message = 'Another request owns this operation key' } }`.
```

### `Kora.sql.awaitCheckedOperations(prefix)`

Waits for every currently running checked operation whose key starts with `prefix`. It never runs SQL. Use it once at startup before you load caches that those operations may still be changing.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| `prefix` | string | Required non-empty key prefix. |

**Returns**

- **summary** — `{ settled = n }` with the number of operations that were waited on.
- **err** — `nil` on success; `An operation key prefix is required` for an empty or non-string prefix.

**Example**

```lua
local summary = Kora.sql.awaitCheckedOperations('transfer:')
print(('waited for %d pending transfers'):format(summary and summary.settled or 0))
```

**Representative console output**

```text
It waits for operations that exist at the moment of the call and ignores ones started later.
```

## Binds inside transactions and batches

Array or table binds inside a transaction or batch use the text protocol, where an array expands to a comma list (`WHERE id IN (?)` with `{ {1,2,3} }`). A table bound to `SET ?` is sent as JSON text and is never expanded into assignments. `transaction` also accepts the other oxmysql shapes: a list of strings, and `{ query, parameters }` or `{ sql, values }` objects.

## transactionChecked outcomes

- Success: `{ success = true, results = { ... } }`.
- Confirmed rollback: `{ success = false, code = 'conflict' | 'duplicate' | 'unavailable' | failureCode }`.
- Lost COMMIT reply or failed rollback: `code = 'indeterminate'`. Reconcile with a durable receipt instead of assuming failure.
- A second call with the same `operation.key` joins the in-flight worker; different terms return an indeterminate result. This is an in-memory bridge for a consumer restart, not a durable idempotency store.
- `Kora.sql.transaction`, `transactionChecked`, `awaitCheckedOperation` and `awaitCheckedOperations` are never subject to `Config.sql.awaitTimeout` (see [Queries](./queries.md)).

## Limits and related APIs

Server only. Requires a transactional engine (InnoDB). A transaction holds one write-pool connection for its whole duration (default pool size 8), so long transactions reduce write capacity. `startTransaction` (oxmysql’s callback style) is available as `exports.kora_sql:startTransaction` and has a fixed 30-second deadline; it is documented under Driver exports.

## Related guides

- [Queries](./queries.md)
- [Driver exports](./driver-exports.md)
