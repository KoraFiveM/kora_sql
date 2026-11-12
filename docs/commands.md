---
title: Commands
sidebar_position: 9
---

kora_sql registers one command, `/kora_sql`, in `server/commands.lua`. It can be run from the server console or by a player with the ACE `command.kora_sql`. A player without that ACE is silently ignored.

```cfg
add_ace group.admin command.kora_sql allow
```

| Command | What it does |
| --- | --- |
| `/kora_sql` or `/kora_sql stats` | Query totals, errors, average time, distinct fingerprints, queue counters (boundary crossings, rows in and written, coalesce ratio, statements per flush, dead-lettered), flush count and average time, and the top queries by total time. |
| `/kora_sql ping` | Runs `SELECT VERSION()` and prints the server version and round-trip time. Waits up to 5 seconds for readiness. |
| `/kora_sql slow [n]` | Prints up to n entries (default 20) of the slow-query log with the issuing resource. Entries are newest first. |
| `/kora_sql queue` | Prints boundary crossings, rows enqueued and written, retries and dead-lettered rows. |
| `/kora_sql flush` | Drains the write queue and reports success or failure. |
| `/kora_sql bench [n]` | Runs an A/B on the scratch table `kora_sql_bench` (default n = 500): n individual upserts versus one `enqueueMany` plus `flush`, printing wall-clock time and boundary crossings. |

Any other argument prints the usage line.

`bench` creates the table `kora_sql_bench` if missing and runs `TRUNCATE` on it twice. Do not use it on a database where a table of that name matters.
