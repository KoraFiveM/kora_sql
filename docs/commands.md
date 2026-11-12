---
title: "Commands"
sidebar_position: 4
---


# Commands

Kora SQL adds one command, `kora_sql`, with subcommands for health checks and statistics. It is registered unrestricted but checks the ACE `command.kora_sql` itself: the server console (source 0) is always allowed, a player needs the ACE, and anyone else is silently ignored. Output is printed to the server console.

## Built-in commands

### `kora_sql ping`

Waits up to 5 seconds for the pool, runs `SELECT VERSION() AS v` and prints the database version with the round-trip time.

| Field | Details |
| --- | --- |
| Context | Server console or admin · server command |
| Arguments | No arguments. |
| Access | Server console, or a player with the `command.kora_sql` ACE. |

**Example**

```text
kora_sql ping
```

**Result**

Prints `[kora_sql] pong: <version> (<n>ms RTT)`, or `not ready` / `ping failed: <reason>`.

### `kora_sql [stats]`

Prints query aggregates, write-queue coalescing counters and the ten queries with the most total time. `stats` is the default when no subcommand is given.

| Field | Details |
| --- | --- |
| Context | Server console or admin · server command |
| Arguments | No arguments. |
| Access | Server console, or a player with the `command.kora_sql` ACE. |

**Example**

```text
kora_sql
kora_sql stats
```

**Result**

Lines for total queries, errors, average ms and distinct fingerprints; queue crossings, rows in vs written, coalesce ratio, statements per flush and dead-lettered rows; flush count and average flush time; then the top queries (SQL cut to 70 characters). Prints `stats unavailable: the driver has not started` if boot has not completed.

### `kora_sql slow [n]`

Prints the `n` most recent slow queries (at or above `kora_sql_slow_threshold` ms) with the resource that issued each.

| Field | Details |
| --- | --- |
| Context | Server console or admin · server command |
| Arguments | n? — how many to show, default 20. |
| Access | Server console, or a player with the `command.kora_sql` ACE. |

**Example**

```text
kora_sql slow
kora_sql slow 5
```

**Result**

One line per query: `<ms>ms [<resource>] <sql cut to 90 characters>`. The resource shown is the real invoking resource of the call (`GetInvokingResource()`); `unknown` appears only when none can be determined.

### `kora_sql queue`

Prints the write-queue counters: boundary crossings, rows enqueued, rows written, retries and dead-lettered rows.

| Field | Details |
| --- | --- |
| Context | Server console or admin · server command |
| Arguments | No arguments. |
| Access | Server console, or a player with the `command.kora_sql` ACE. |

**Example**

```text
kora_sql queue
```

**Result**

A single line `crossings=… rowsIn=… rowsWritten=… retries=… deadLettered=…`.

### `kora_sql flush`

Forces every table in the write queue to drain now.

| Field | Details |
| --- | --- |
| Context | Server console or admin · server command |
| Arguments | No arguments. |
| Access | Server console, or a player with the `command.kora_sql` ACE. |

**Example**

```text
kora_sql flush
```

**Result**

Prints `flushed`, or `flush failed` when a write ended up dead-lettered.

### `kora_sql bench [n]`

Benchmarks `n` individual upserts against one `enqueueMany` plus flush of the same `n` rows. It creates the table `kora_sql_bench` if missing and runs `TRUNCATE` on it twice. Use it on a development database only.

| Field | Details |
| --- | --- |
| Context | Server console or admin · server command |
| Arguments | n? — number of rows, default 500. |
| Access | Server console, or a player with the `command.kora_sql` ACE. |

**Example**

```text
kora_sql bench
kora_sql bench 2000
```

**Result**

Prints wall-clock time, boundary crossings and approximate round trips for both paths and the speed-up ratio.

## Granting access to a player

Add an ACE to `server.cfg`, for example `add_ace group.admin command.kora_sql allow`. Without it only the console can run the command. Subcommands other than the ones above print `usage: /kora_sql ping | stats | slow [n] | queue | flush | bench [n]`.

## Other ways to reach the same data

The same statistics are available from code: `exports.kora_sql:stats()`, `exports.kora_sql:slowQueries(limit)` and `exports.kora_sql:resetStats()`. See the Driver exports module.

## Command summary

| Command | What it does |
| --- | --- |
| `/kora_sql` or `/kora_sql stats` | Query totals, errors, average time, distinct fingerprints, queue counters (boundary crossings, rows in and written, coalesce ratio, statements per flush, dead-lettered), flush count and average time, and the top queries by total time. |
| `/kora_sql ping` | Runs `SELECT VERSION()` and prints the server version and round-trip time. Waits up to 5 seconds for readiness. |
| `/kora_sql slow [n]` | Prints up to n entries (default 20) of the slow-query log with the issuing resource, newest first. |
| `/kora_sql queue` | Prints boundary crossings, rows enqueued and written, retries and dead-lettered rows. |
| `/kora_sql flush` | Drains the write queue and reports success or failure. |
| `/kora_sql bench [n]` | A/B on the scratch table `kora_sql_bench` (default n = 500): n individual upserts versus one `enqueueMany` plus `flush`. |

The command is defined in `server/commands.lua`. A player without the ACE `command.kora_sql` is silently ignored; the server console is always allowed.

```cfg title="server.cfg"
add_ace group.admin command.kora_sql allow
```

> `bench` creates the table `kora_sql_bench` if missing (`id varchar(32)` primary key, `v int`) and runs `TRUNCATE` on it twice. Do not use it on a database where a table of that name matters. See [Database](./database.md).
