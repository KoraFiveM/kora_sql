// Declarative table setup. A resource describes a table as data (columns, keys,
// foreign keys, seed rows); this module creates it if missing and, when it exists,
// ADDS whatever is missing. It never alters or drops anything that already
// exists: type/nullability/collation differences are reported as warnings only.
//
// Everything interpolated into DDL is validated first (identifiers, types,
// keywords). Values (seed rows) are always bound parameters; column DEFAULTs
// cannot be bound in DDL, so they go through mysql2's escape().

'use strict';

const { escape } = require('mysql2');
const log = require('./logger');

const NULL_SENTINEL = '\u0000qbsql:null\u0000';
const IDENT = /^[A-Za-z0-9_]{1,64}$/;
const BASE_TYPE = /^(?:(?:tiny|small|medium|big)?int(?:\(\d{1,2}\))?|integer|decimal\(\d{1,2}(?:,\d{1,2})?\)|numeric\(\d{1,2}(?:,\d{1,2})?\)|float|double|(?:var)?char\(\d{1,5}\)|(?:var)?binary\(\d{1,5}\)|tinytext|text|mediumtext|longtext|tinyblob|blob|mediumblob|longblob|json|date|time(?:\(\d\))?|datetime(?:\(\d\))?|timestamp(?:\(\d\))?|year|boolean|bool|enum|set)$/i;
const RAW_DEFAULT = /^(?:CURRENT_TIMESTAMP|NOW|LOCALTIMESTAMP)(?:\(\d?\))?$/i;
const EXPRESSION_BANNED = /;|--|\/\*|\*\//;
const FK_ACTIONS = new Set(['CASCADE', 'SET NULL', 'RESTRICT', 'NO ACTION', 'SET DEFAULT']);
const COLLATION = /^[a-z0-9_]{1,64}$/i;

const q = (name) => '`' + name + '`';
const list = (names) => names.map(q).join(', ');

function assertIdent(value, what) {
    if (typeof value !== 'string' || !IDENT.test(value)) throw new Error(`qbsql schema: invalid ${what} '${value}'`);
}

function assertExpression(value, what) {
    if (typeof value !== 'string' || value.trim() === '' || EXPRESSION_BANNED.test(value)) throw new Error(`qbsql schema: invalid ${what}`);
}

function assertNames(value, what) {
    if (!Array.isArray(value) || value.length === 0) throw new Error(`qbsql schema: ${what} must be a non-empty list`);
    value.forEach((name) => assertIdent(name, what));
}

// Normalises (and validates) a spec. Returns a fresh object; the input is untouched.
function validateSpec(input, defaults = {}) {
    if (!input || typeof input !== 'object') throw new Error('qbsql schema: spec must be a table');
    assertIdent(input.name, 'table name');
    if (!Array.isArray(input.columns) || input.columns.length === 0) {
        throw new Error(`qbsql schema: '${input.name}' needs at least one column`);
    }

    const spec = {
        name: input.name,
        engine: input.engine || defaults.engine || 'InnoDB',
        charset: input.charset || defaults.charset || 'utf8mb4',
        collate: input.collate || defaults.collate || null,
        createCollate: null,
        columns: [],
        primary: input.primary || null,
        indexes: input.indexes || [],
        foreign: input.foreign || [],
        checks: input.checks || [],
        extend: input.extend === true,
        comment: input.comment,
        seed: input.seed || null,
    };
    assertIdent(spec.engine, 'engine');
    assertIdent(spec.charset, 'charset');
    if (spec.collate !== null && !COLLATION.test(spec.collate)) throw new Error(`qbsql schema: invalid collation '${spec.collate}'`);
    // A table created with no collate gets the server's charset default (utf8mb4_0900_ai_ci
    // on MySQL 8), which then fails joins against Kora's utf8mb4_unicode_ci tables with
    // "Illegal mix of collations". Only CREATE TABLE uses this; existing tables are
    // never compared against it.
    const createCollate = typeof defaults.createCollate === 'string' ? defaults.createCollate : '';
    if (spec.collate === null && COLLATION.test(createCollate)
        && createCollate.toLowerCase().startsWith(spec.charset.toLowerCase() + '_')) {
        spec.createCollate = createCollate;
    }

    const seen = new Set();
    for (const col of input.columns) {
        assertIdent(col && col.name, 'column name');
        if (seen.has(col.name)) throw new Error(`qbsql schema: duplicate column '${col.name}' in '${spec.name}'`);
        seen.add(col.name);
        if (typeof col.type !== 'string' || !BASE_TYPE.test(col.type)) {
            throw new Error(`qbsql schema: unsupported type '${col.type}' for ${spec.name}.${col.name}`);
        }
        const base = col.type.toLowerCase();
        if ((base === 'enum' || base === 'set')
            && (!Array.isArray(col.values) || col.values.length === 0 || col.values.some((v) => typeof v !== 'string'))) {
            throw new Error(`qbsql schema: ${spec.name}.${col.name} needs a 'values' list`);
        }
        if (col.collate !== undefined && !COLLATION.test(col.collate)) throw new Error(`qbsql schema: invalid collation for ${spec.name}.${col.name}`);
        if (col.on_update !== undefined && !RAW_DEFAULT.test(String(col.on_update))) {
            throw new Error(`qbsql schema: unsupported on_update for ${spec.name}.${col.name}`);
        }
        if (col.default && typeof col.default === 'object' && !RAW_DEFAULT.test(String(col.default.raw))) {
            throw new Error(`qbsql schema: unsupported raw default for ${spec.name}.${col.name}`);
        }
        if (col.generated !== undefined) {
            assertExpression(col.generated.expr, `generated expression for ${spec.name}.${col.name}`);
            if (col.default !== undefined || col.auto_increment) throw new Error(`qbsql schema: generated column ${spec.name}.${col.name} cannot have a default or auto_increment`);
        }
        if (col.after !== undefined) assertIdent(col.after, 'after column');
        if (col.comment !== undefined && typeof col.comment !== 'string') throw new Error(`qbsql schema: invalid comment for ${spec.name}.${col.name}`);
        spec.columns.push(col);
    }

    if (spec.extend && (spec.primary || spec.seed)) throw new Error(`qbsql schema: extend table '${spec.name}' cannot declare a primary key or seed rows`);
    if (spec.comment !== undefined && typeof spec.comment !== 'string') throw new Error(`qbsql schema: invalid comment for '${spec.name}'`);
    for (const check of spec.checks) {
        assertIdent(check.name, 'check name');
        assertExpression(check.expr, `check expression '${check.name}'`);
    }
    if (spec.primary) {
        assertNames(spec.primary, 'primary key column');
        spec.primary.forEach((c) => { if (!seen.has(c)) throw new Error(`qbsql schema: primary key column '${c}' is not in '${spec.name}'`); });
    }
    for (const idx of spec.indexes) {
        assertIdent(idx.name, 'index name');
        assertNames(idx.columns, 'index column');
        idx.columns.forEach((c) => { if (!seen.has(c)) throw new Error(`qbsql schema: index '${idx.name}' column '${c}' is not in '${spec.name}'`); });
    }
    for (const fk of spec.foreign) {
        assertIdent(fk.name, 'foreign key name');
        assertIdent(fk.ref_table, 'foreign key table');
        assertNames(fk.columns, 'foreign key column');
        assertNames(fk.ref_columns, 'foreign key reference column');
        fk.columns.forEach((c) => { if (!seen.has(c)) throw new Error(`qbsql schema: foreign key '${fk.name}' column '${c}' is not in '${spec.name}'`); });
        for (const key of ['on_delete', 'on_update']) {
            if (fk[key] !== undefined && !FK_ACTIONS.has(String(fk[key]).toUpperCase())) {
                throw new Error(`qbsql schema: invalid ${key} for foreign key '${fk.name}'`);
            }
        }
    }
    if (spec.seed) {
        if (!Array.isArray(spec.seed.rows)) throw new Error(`qbsql schema: seed.rows for '${spec.name}' must be a list`);
        spec.seed.rows.forEach((row) => Object.keys(row).forEach((c) => {
            if (!seen.has(c)) throw new Error(`qbsql schema: seed column '${c}' is not in '${spec.name}'`);
        }));
    }
    return spec;
}

// The type as MariaDB/MySQL report it in information_schema (lowercase, with
// unsigned suffix) so we can compare without false warnings.
function expectedType(col) {
    let type = col.type.toLowerCase();
    if (type === 'enum' || type === 'set') type += '(' + col.values.map((v) => escape(v)).join(',') + ')';
    if (col.unsigned) type += ' unsigned';
    return normaliseType(type);
}

// Integer display widths (int(11)) are reported by MariaDB but not MySQL 8; boolean is tinyint(1).
function normaliseType(type) {
    return String(type).toLowerCase()
        .replace(/^(?:boolean|bool)$/, 'tinyint(1)')
        .replace(/\b(smallint|mediumint|bigint|int|integer)\(\d+\)/g, '$1')
        .replace(/\btinyint\((?!1\))\d+\)/g, 'tinyint')
        .replace(/\binteger\b/, 'int')
        .replace(/\s+/g, ' ').trim();
}

// MariaDB stores JSON as longtext, so either spelling satisfies a json column.
function typeMatches(want, got) {
    return want === got || (want === 'json' && got === 'longtext');
}

function columnDefinition(col, spec) {
    const parts = [q(col.name), col.type.toLowerCase() === 'enum' || col.type.toLowerCase() === 'set'
        ? `${col.type.toLowerCase()}(${col.values.map((v) => escape(v)).join(',')})`
        : col.type.toLowerCase()];
    if (col.unsigned) parts.push('UNSIGNED');
    const collate = col.collate || (spec.collate && /char|text|enum|set/i.test(col.type) ? spec.collate : null);
    if (collate) parts.push(`COLLATE ${collate}`);
    if (col.generated) {
        parts.push(`GENERATED ALWAYS AS (${col.generated.expr}) ${col.generated.stored === false ? 'VIRTUAL' : 'STORED'}`);
    } else {
        parts.push(col.null === true ? 'NULL' : 'NOT NULL');
        if (col.auto_increment) parts.push('AUTO_INCREMENT');
        if (col.default !== undefined) {
            if (col.default === NULL_SENTINEL || col.default === null) parts.push('DEFAULT NULL');
            else if (typeof col.default === 'object') parts.push(`DEFAULT ${String(col.default.raw).toUpperCase()}`);
            else parts.push(`DEFAULT ${escape(col.default)}`);
        }
        if (col.on_update) parts.push(`ON UPDATE ${String(col.on_update).toUpperCase()}`);
    }
    if (col.comment) parts.push(`COMMENT ${escape(col.comment)}`);
    return parts.join(' ');
}

const indexDefinition = (idx) => `${idx.unique ? 'UNIQUE ' : ''}KEY ${q(idx.name)} (${list(idx.columns)})`;

function foreignDefinition(fk) {
    let sql = `CONSTRAINT ${q(fk.name)} FOREIGN KEY (${list(fk.columns)}) REFERENCES ${q(fk.ref_table)} (${list(fk.ref_columns)})`;
    if (fk.on_delete) sql += ` ON DELETE ${String(fk.on_delete).toUpperCase()}`;
    if (fk.on_update) sql += ` ON UPDATE ${String(fk.on_update).toUpperCase()}`;
    return sql;
}

const checkDefinition = (check) => `CONSTRAINT ${q(check.name)} CHECK (${check.expr})`;

function buildCreate(spec) {
    const lines = spec.columns.map((c) => columnDefinition(c, spec));
    if (spec.primary) lines.push(`PRIMARY KEY (${list(spec.primary)})`);
    spec.indexes.forEach((idx) => lines.push(indexDefinition(idx)));
    spec.foreign.forEach((fk) => lines.push(foreignDefinition(fk)));
    spec.checks.forEach((check) => lines.push(checkDefinition(check)));
    let sql = `CREATE TABLE IF NOT EXISTS ${q(spec.name)} (\n  ${lines.join(',\n  ')}\n) ENGINE=${spec.engine} DEFAULT CHARSET=${spec.charset}`;
    if (spec.collate || spec.createCollate) sql += ` COLLATE=${spec.collate || spec.createCollate}`;
    if (spec.comment) sql += ` COMMENT=${escape(spec.comment)}`;
    return sql;
}

// actual = { columns: [{COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE}], indexes: [{INDEX_NAME, COLUMN_NAME, SEQ_IN_INDEX, NON_UNIQUE}], foreign: [{CONSTRAINT_NAME}] }
// Returns ALTER statements for what is missing plus warnings for what differs.
function diff(spec, actual) {
    const statements = [];
    const added = { columns: [], modified: [], indexes: [], foreign: [], checks: [] };
    const warnings = [];
    const alter = (clause) => `ALTER TABLE ${q(spec.name)} ${clause}`;

    const have = new Map(actual.columns.map((c) => [c.COLUMN_NAME.toLowerCase(), c]));
    for (const col of spec.columns) {
        const existing = have.get(col.name.toLowerCase());
        if (!existing) {
            statements.push(alter(`ADD COLUMN ${columnDefinition(col, spec)}${col.after ? ` AFTER ${q(col.after)}` : ''}`));
            added.columns.push(col.name);
            continue;
        }
        const want = expectedType(col);
        const got = normaliseType(existing.COLUMN_TYPE);
        const wantNull = col.null === true;
        const typeDiffers = !typeMatches(want, got);
        const nullDiffers = !col.generated && wantNull !== (existing.IS_NULLABLE === 'YES');
        if (col.modify === true && !col.generated && (typeDiffers || nullDiffers)) {
            statements.push(alter(`MODIFY COLUMN ${columnDefinition(col, spec)}`));
            added.modified.push(col.name);
            continue;
        }
        if (typeDiffers) warnings.push(`${spec.name}.${col.name}: type is '${existing.COLUMN_TYPE}', schema expects '${want}' (not altered)`);
        if (nullDiffers) warnings.push(`${spec.name}.${col.name}: nullability differs from schema (not altered)`);
        const wantCollate = col.collate || (/char|text|enum|set/i.test(col.type) ? spec.collate : null);
        if (wantCollate && existing.COLLATION_NAME && existing.COLLATION_NAME.toLowerCase() !== wantCollate.toLowerCase()) {
            warnings.push(`${spec.name}.${col.name}: collation is '${existing.COLLATION_NAME}', schema expects '${wantCollate}' (not altered)`);
        }
    }

    const indexNames = new Set(actual.indexes.map((i) => i.INDEX_NAME.toLowerCase()));
    if (spec.primary && !indexNames.has('primary')) {
        statements.push(alter(`ADD PRIMARY KEY (${list(spec.primary)})`));
        added.indexes.push('PRIMARY');
    }
    for (const idx of spec.indexes) {
        if (indexNames.has(idx.name.toLowerCase())) continue;
        statements.push(alter(`ADD ${indexDefinition(idx)}`));
        added.indexes.push(idx.name);
    }

    const fkNames = new Set(actual.foreign.map((f) => f.CONSTRAINT_NAME.toLowerCase()));
    for (const fk of spec.foreign) {
        if (fkNames.has(fk.name.toLowerCase())) continue;
        statements.push(alter(`ADD ${foreignDefinition(fk)}`));
        added.foreign.push(fk.name);
    }

    const checkNames = new Set((actual.checks || []).map((c) => c.CONSTRAINT_NAME.toLowerCase()));
    for (const check of spec.checks) {
        if (checkNames.has(check.name.toLowerCase())) continue;
        statements.push(alter(`ADD ${checkDefinition(check)}`));
        added.checks.push(check.name);
    }
    return { statements, added, warnings };
}

// INSERT IGNORE keeps seeding idempotent and never overwrites edits made after
// the first boot. Set seed.update = true to refresh the non-key columns instead.
function buildSeed(spec) {
    if (!spec.seed || spec.seed.rows.length === 0) return null;
    const columns = spec.columns.map((c) => c.name).filter((name) => spec.seed.rows.some((r) => r[name] !== undefined));
    const values = [];
    const placeholders = spec.seed.rows.map((row) => '(' + columns.map((name) => {
        if (row[name] === undefined) return 'DEFAULT';
        values.push(row[name] === NULL_SENTINEL ? null : row[name]);
        return '?';
    }).join(', ') + ')');
    let sql;
    if (spec.seed.update) {
        const key = new Set(spec.seed.key || spec.primary || []);
        const updatable = columns.filter((c) => !key.has(c));
        if (updatable.length === 0) throw new Error(`qbsql schema: seed.update on '${spec.name}' has no non-key columns`);
        sql = `INSERT INTO ${q(spec.name)} (${list(columns)}) VALUES ${placeholders.join(', ')} ON DUPLICATE KEY UPDATE ${updatable.map((c) => `${q(c)} = VALUES(${q(c)})`).join(', ')}`;
    } else {
        sql = `INSERT IGNORE INTO ${q(spec.name)} (${list(columns)}) VALUES ${placeholders.join(', ')}`;
    }
    return { sql, values };
}

const ddl = (sql) => ({ sql, namedPlaceholders: false });

class SchemaManager {
    constructor(pools, defaults = {}) {
        this.pools = pools;
        this.defaults = defaults;
        this._tails = new Map();
    }

    // Serialise work per table so two resources racing on the same table do not interleave DDL.
    _serial(name, fn) {
        const tail = (this._tails.get(name) || Promise.resolve()).catch(() => {});
        const run = tail.then(fn);
        this._tails.set(name, run);
        return run;
    }

    async _inspect(name) {
        const db = this.pools.write;
        const [tables] = await db.query(
            'SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', [name]);
        if (tables.length === 0) return null;
        const [columns] = await db.query(
            'SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLLATION_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', [name]);
        const [indexes] = await db.query(
            'SELECT INDEX_NAME, COLUMN_NAME, SEQ_IN_INDEX, NON_UNIQUE FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', [name]);
        const [foreign] = await db.query(
            'SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND CONSTRAINT_TYPE = \'FOREIGN KEY\'', [name]);
        const [checks] = await db.query(
            'SELECT CONSTRAINT_NAME FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND CONSTRAINT_TYPE = \'CHECK\'', [name]);
        return { columns, indexes, foreign, checks };
    }

    async ensureTable(input, resource) {
        const spec = validateSpec(input, this.defaults);
        return this._serial(spec.name, async () => {
            const report = { table: spec.name, created: false, added_columns: [], modified_columns: [], added_indexes: [], added_fks: [], added_checks: [], seeded: 0, warnings: [] };
            const actual = await this._inspect(spec.name);

            if (!actual && spec.extend) {
                throw new Error(`qbsql schema: table '${spec.name}' does not exist, so ${resource || 'the caller'} cannot extend it`);
            }
            if (!actual) {
                await this.pools.write.query(ddl(buildCreate(spec)));
                report.created = true;
                log.info('schema', `${resource || 'unknown'}: created table ${spec.name}`);
            } else {
                const result = diff(spec, actual);
                for (const stmt of result.statements) await this.pools.write.query(ddl(stmt));
                report.added_columns = result.added.columns;
                report.modified_columns = result.added.modified;
                report.added_checks = result.added.checks;
                report.added_indexes = result.added.indexes;
                report.added_fks = result.added.foreign;
                report.warnings = result.warnings;
                const changes = result.statements.length;
                if (changes > 0) log.info('schema', `${resource || 'unknown'}: ${spec.name} updated (${changes} addition${changes === 1 ? '' : 's'})`);
                if (result.warnings.length > 0) {
                    const shown = result.warnings.slice(0, 3).join('; ');
                    const more = result.warnings.length > 3 ? ` (+${result.warnings.length - 3} more in the report)` : '';
                    log.warn('schema', `${resource || 'unknown'}: ${spec.name} differs from its schema in ${result.warnings.length} place(s), nothing altered: ${shown}${more}`);
                }
            }

            const seed = spec.seed && spec.seed.once && !report.created ? null : buildSeed(spec);
            if (seed) {
                const [res] = await this.pools.write.query(seed.sql, seed.values);
                report.seeded = (res && res.affectedRows) || 0;
            }
            return report;
        });
    }

    // Resolves once every named table exists, so a resource can wait for tables another resource creates.
    async awaitTables(names, timeoutMs, resource) {
        if (!Array.isArray(names) || names.length === 0 || names.some((n) => typeof n !== 'string' || !IDENT.test(n))) {
            throw new Error('qbsql schema: awaitTables expects a list of table names');
        }
        const deadline = Date.now() + (Number(timeoutMs) > 0 ? Number(timeoutMs) : 60000);
        const unique = [...new Set(names)];
        for (;;) {
            const [rows] = await this.pools.write.query(
                'SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME IN (?)', [unique]);
            const have = new Set(rows.map((r) => r.TABLE_NAME.toLowerCase()));
            const missing = unique.filter((n) => !have.has(n.toLowerCase()));
            if (missing.length === 0) return true;
            if (Date.now() >= deadline) throw new Error(`tables not created within the timeout: ${missing.join(', ')} (waiting: ${resource || 'unknown'})`);
            await new Promise((resolve) => setTimeout(resolve, 250));
        }
    }

    // Runs in order so foreign key parents can be listed first. Stops at the first failure.
    async ensureTables(specs, resource) {
        if (!Array.isArray(specs)) throw new Error('qbsql schema: ensureTables expects a list of table specs');
        const reports = [];
        for (const spec of specs) reports.push(await this.ensureTable(spec, resource));
        return reports;
    }
}

module.exports = { SchemaManager, validateSpec, buildCreate, buildSeed, diff, NULL_SENTINEL };
