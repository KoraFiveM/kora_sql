// Migration runner. qbsql owns the RUNNER; each resource owns its migration
// FILES (putting qbcore's DDL inside qbsql would be a layering inversion). A
// resource calls exports.qbsql:migrate('qbcore', migrations, cb) with a list of
// { version, name, sql, checksum, acceptedChecksums? }. The optional legacy
// list is only for an intentional, reviewed retry-safety rewrite of an
// already-shipped migration; arbitrary drift remains a hard failure.
//
// A checksum mismatch on an already-applied version is a HARD ABORT, not a
// warning: silently tolerating an edited migration is exactly how a schema
// drifts irreversibly between servers. The abort names the resource + version.

'use strict';

const log = require('./logger');

// Migration DDL is PARAMETERLESS by definition, so placeholder compilation must
// never run on it. The pool sets namedPlaceholders:true (for mysql-async's
// `@name` compat), which makes mysql2 hand any valueless query to the
// `named-placeholders` parser. That parser tracks quotes but has NO concept of
// SQL comments or backticks, so its /:([a-zA-Z][a-zA-Z0-9_]*)/ regex happily
// matches inside them -- a migration whose header comment mentions an event
// name like `qb-multicharacter:server:getSkin` gets read as two placeholders
// (`:server`, `:getSkin`) and dies with "Named query contains placeholders, but
// parameters object is undefined". mysql2 honours an explicit per-query false
// (see _resolveNamedPlaceholders in its base/connection.js), so opt out here
// rather than policing what our own DDL and its comments are allowed to say.
// Statements that DO bind values keep passing an array, which mysql2 already
// short-circuits past the named path.
function ddl(sql) {
    return { sql, namedPlaceholders: false };
}

const BOOTSTRAP = `
CREATE TABLE IF NOT EXISTS \`qbsql_migrations\` (
  \`resource\`    VARCHAR(64)  NOT NULL,
  \`version\`     INT UNSIGNED NOT NULL,
  \`name\`        VARCHAR(128) NOT NULL,
  \`checksum\`    CHAR(64)     NOT NULL,
  \`applied_at\`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  \`duration_ms\` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (\`resource\`,\`version\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;`;

const DEADLETTER = `
CREATE TABLE IF NOT EXISTS \`qbsql_deadletter\` (
  \`id\`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  \`table_name\` VARCHAR(64)     NOT NULL,
  \`pk\`         VARCHAR(191)    NOT NULL,
  \`cols_json\`  LONGTEXT        NOT NULL,
  \`error\`      VARCHAR(500)             DEFAULT NULL,
  \`failed_at\`  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (\`id\`),
  KEY \`idx_deadletter_table\` (\`table_name\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;`;

class Migrator {
    constructor(pools) {
        this.pools = pools;
        this._bootstrapped = false;
    }

    async _bootstrap() {
        if (this._bootstrapped) return;
        await this.pools.write.query(ddl(BOOTSTRAP));
        await this.pools.write.query(ddl(DEADLETTER));
        this._bootstrapped = true;
    }

    async migrate(resource, migrations) {
        await this._bootstrap();

        // Load what's already applied for this resource.
        const [applied] = await this.pools.write.query(
            'SELECT `version`, `checksum` FROM `qbsql_migrations` WHERE `resource` = ?',
            [resource]
        );
        const appliedByVersion = new Map(applied.map((r) => [r.version, r.checksum]));

        const sorted = migrations.slice().sort((a, b) => a.version - b.version);
        let ran = 0;

        for (const m of sorted) {
            const prior = appliedByVersion.get(m.version);
            if (prior !== undefined) {
                const acceptedLegacy = Array.isArray(m.acceptedChecksums)
                    && m.acceptedChecksums.some((checksum) => typeof checksum === 'string' && checksum === prior);
                if (prior !== m.checksum && !acceptedLegacy) {
                    throw new Error(
                        `qbsql: migration checksum mismatch for '${resource}' v${m.version} (${m.name}). ` +
                        `The file changed after it was applied. Refusing to continue -- ` +
                        `resolve the drift manually. (db=${prior} file=${m.checksum})`
                    );
                }
                continue;   // already applied, checksum matches
            }

            // MariaDB DDL implicitly commits, so wrapping it in a transaction
            // creates a false rollback guarantee. Multi-statement migrations
            // are accepted only when every statement is an idempotent CREATE
            // TABLE IF NOT EXISTS; a single DDL statement is atomic at the
            // statement boundary and can be retried safely after failure.
            const conn = await this.pools.write.getConnection();
            const started = process.hrtime.bigint();
            try {
                const statements = splitStatements(m.sql).filter((stmt) => stmt.trim());
                for (const stmt of statements) {
                    const withoutComments = stmt.replace(/^\s*(?:--[^\n]*\n\s*)*/g, '');
                    const safeCreate = /^CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS\b/i.test(withoutComments);
                    const allAdds = withoutComments.match(/\bADD\b/gi) || [];
                    const safeAdds = withoutComments.match(/\bADD\s+(?:COLUMN|INDEX)\s+IF\s+NOT\s+EXISTS\b/gi) || [];
                    const safeAlter = /^ALTER\s+TABLE\b/i.test(withoutComments)
                        && allAdds.length > 0 && allAdds.length === safeAdds.length;
                    if (!safeCreate && !safeAlter) {
                        throw new Error('DDL migrations must be retry-safe (CREATE TABLE IF NOT EXISTS or ALTER ADD ... IF NOT EXISTS)');
                    }
                }

                for (const stmt of statements) await conn.query(ddl(stmt));
                const ms = Number(process.hrtime.bigint() - started) / 1e6;
                await conn.query(
                    'INSERT INTO `qbsql_migrations` (`resource`,`version`,`name`,`checksum`,`duration_ms`) VALUES (?,?,?,?,?)',
                    [resource, m.version, m.name, m.checksum, Math.round(ms)]
                );
                ran++;
                log.info('migrate', `${resource} v${m.version} '${m.name}' applied (${ms.toFixed(0)}ms)`);
            } catch (err) {
                throw new Error(`qbsql: migration '${resource}' v${m.version} (${m.name}) failed: ${err.message}`);
            } finally {
                conn.release();
            }
        }

        return { ran, total: sorted.length };
    }
}

// Split a DDL blob on semicolons that terminate statements. This is a
// deliberately simple splitter for OUR OWN migration files -- it respects
// single/double quoted strings and line comments but does not handle stored
// procedures with embedded semicolons (which our schema does not use).
function splitStatements(sql) {
    const out = [];
    let buf = '';
    let inSingle = false, inDouble = false, inBacktick = false, inLineComment = false;
    for (let i = 0; i < sql.length; i++) {
        const c = sql[i];
        const next = sql[i + 1];
        if (inLineComment) {
            if (c === '\n') inLineComment = false;
            buf += c;
            continue;
        }
        if (!inSingle && !inDouble && !inBacktick && c === '-' && next === '-') {
            inLineComment = true; buf += c; continue;
        }
        if (c === "'" && !inDouble && !inBacktick) inSingle = !inSingle;
        else if (c === '"' && !inSingle && !inBacktick) inDouble = !inDouble;
        else if (c === '`' && !inSingle && !inDouble) inBacktick = !inBacktick;

        if (c === ';' && !inSingle && !inDouble && !inBacktick) {
            out.push(buf);
            buf = '';
        } else {
            buf += c;
        }
    }
    if (buf.trim()) out.push(buf);
    return out;
}

module.exports = { Migrator, splitStatements };
