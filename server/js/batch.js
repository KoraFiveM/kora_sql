// The batched-upsert SQL builder. This is the single most important file in
// qbsql: a silent bug here corrupts player data on every save. It is written as
// PURE FUNCTIONS with no database and no I/O so test/js/batch.test.js can assert
// the generated SQL byte-for-byte.
//
// Given a set of rows that all share the same column signature, it builds one
//   INSERT INTO tbl (pk, colA, colB) VALUES (?,?,?),(?,?,?),... ON DUPLICATE KEY UPDATE ...
// and returns { sql, params }.
//
// Two dialects (picked by the caller from the boot version probe):
//   * MySQL >= 8.0.20 : the `AS new` alias form. VALUES() in ON DUPLICATE KEY
//     UPDATE is DEPRECATED there and emits a warning on every write.
//   * MariaDB (all) and MySQL < 8.0.20 : the classic VALUES() form.
//
// Two modes:
//   * 'assign'     : col = new.col            (last write wins) -- padding-safe
//   * 'accumulate' : col = col + VALUES(col)  (counters)        -- padding UNSAFE

'use strict';

// Row-count buckets for prepared-statement text stability. A batch of N rows
// produces SQL whose text varies with N, which would give the prepared cache a
// ~0% hit rate on the hottest path. Quantising N up to the next bucket and
// padding the batch by repeating an existing row keeps the text stable across
// flushes. See padRows() for why the pad is a genuine no-op in assign mode.
const BUCKETS = [1, 2, 4, 8, 16, 32, 64, 128, 200];

function bucketFor(n) {
    for (const b of BUCKETS) {
        if (n <= b) return b;
    }
    // Larger than the biggest bucket: the caller is expected to have chunked to
    // maxRowsPerStatement (<= 200) already, so this is unreachable in practice,
    // but return n unpadded rather than throw.
    return n;
}

function quoteIdent(id) {
    // Backtick-quote, escaping embedded backticks. Column and table names come
    // from our own code (COLUMN_FOR map in kora_core), never from user input, but
    // quoting defends the golden-SQL contract regardless.
    return '`' + String(id).replace(/`/g, '``') + '`';
}

// Pad `rows` up to `targetCount` by repeating rows already present. In assign
// mode (col = new.col) applying the same row's values twice in one statement
// converges to the same final value, so the duplicate is a true no-op. This is
// ONLY sound in assign mode -- see build()'s assert.
function padRows(rows, targetCount) {
    if (rows.length === 0 || rows.length >= targetCount) return rows;
    const padded = rows.slice();
    let i = 0;
    while (padded.length < targetCount) {
        padded.push(rows[i % rows.length]);
        i++;
    }
    return padded;
}

// Build one upsert statement.
//   table      : string
//   conflictKey: string | string[]  (the PK/unique column(s), always first in the column list)
//   columns    : string[]           (the non-key columns being written, order-stable)
//   rows       : Array<{ pk, cols }> (pk is the conflictKey value or an array for composite keys)
//   opts       : { mode, dialect, pad }
// Returns { sql, params, rowCount }.
function build(table, conflictKey, columns, rows, opts) {
    const mode = (opts && opts.mode) || 'assign';
    const dialect = (opts && opts.dialect) || 'values';   // 'alias' | 'values'
    const pad = opts && opts.pad;

    // HARD invariant: padding duplicates a row, and in accumulate mode
    // (col = col + VALUES(col)) a duplicated row double-counts. This must never
    // be reachable -- it is programmer error, per the codebase's assert
    // convention -- so it throws rather than silently producing wrong sums.
    if (pad && mode === 'accumulate') {
        throw new Error('qbsql/batch: bucket padding is not sound in accumulate mode -- pass pad:false.');
    }

    const keyCols = Array.isArray(conflictKey) ? conflictKey : [conflictKey];
    const allCols = keyCols.concat(columns);

    const effectiveRows = pad ? padRows(rows, bucketFor(rows.length)) : rows;

    const placeholderGroup = '(' + allCols.map(() => '?').join(',') + ')';
    const valuesClause = new Array(effectiveRows.length).fill(placeholderGroup).join(',');

    const params = [];
    for (const row of effectiveRows) {
        const pkVals = Array.isArray(row.pk) ? row.pk : [row.pk];
        for (const v of pkVals) params.push(v);
        for (const c of columns) params.push(row.cols[c]);
    }

    // ON DUPLICATE KEY UPDATE assignments -- only the value columns, never the
    // key columns (updating a key column in an upsert is the corruption hazard
    // documented in the plan's schema section).
    const alias = dialect === 'alias';
    const aliasClause = alias ? ' AS `new`' : '';
    const incoming = (c) => (alias ? `\`new\`.${quoteIdent(c)}` : `VALUES(${quoteIdent(c)})`);
    const updateClause = columns
        .map((c) => `${quoteIdent(c)} = ${mode === 'accumulate' ? `${quoteIdent(c)} + ` : ''}${incoming(c)}`)
        .join(', ');

    const colList = allCols.map(quoteIdent).join(',');
    const sql =
        `INSERT INTO ${quoteIdent(table)} (${colList}) VALUES ${valuesClause}${aliasClause} ` +
        `ON DUPLICATE KEY UPDATE ${updateClause}`;

    return { sql, params, rowCount: effectiveRows.length };
}

// Build a batched UPDATE for rows the caller knows already exist. This is not
// interchangeable with an upsert: MariaDB validates every NOT NULL column on
// an INSERT before it reaches ON DUPLICATE KEY UPDATE, so a partial player save
// such as { citizenid, position } fails when `license` has no default even when
// that citizenid is already present. A CASE expression keeps the one-statement
// per column-signature batching property without ever attempting an insert.
//
// It supports composite conflict keys too. Padding is safe for assign mode
// (repeating the same assignment converges); it remains forbidden for
// accumulate mode for the same reason as the upsert builder.
function buildUpdate(table, conflictKey, columns, rows, opts) {
    const mode = (opts && opts.mode) || 'assign';
    const pad = opts && opts.pad;
    if (pad && mode === 'accumulate') {
        throw new Error('qbsql/batch: bucket padding is not sound in accumulate mode -- pass pad:false.');
    }

    const keyCols = Array.isArray(conflictKey) ? conflictKey : [conflictKey];
    const effectiveRows = pad ? padRows(rows, bucketFor(rows.length)) : rows;
    const keyMatch = () => keyCols.map((key) => `${quoteIdent(key)} = ?`).join(' AND ');

    const params = [];
    const assignments = columns.map((column) => {
        const branches = [];
        for (const row of effectiveRows) {
            const pkVals = Array.isArray(row.pk) ? row.pk : [row.pk];
            branches.push(`WHEN ${keyMatch()} THEN ${mode === 'accumulate' ? `${quoteIdent(column)} + ?` : '?'}`);
            for (const value of pkVals) params.push(value);
            params.push(row.cols[column]);
        }
        return `${quoteIdent(column)} = CASE ${branches.join(' ')} ELSE ${quoteIdent(column)} END`;
    });

    const where = [];
    for (const row of effectiveRows) {
        const pkVals = Array.isArray(row.pk) ? row.pk : [row.pk];
        where.push(`(${keyMatch()})`);
        for (const value of pkVals) params.push(value);
    }

    return {
        sql: `UPDATE ${quoteIdent(table)} SET ${assignments.join(', ')} WHERE ${where.join(' OR ')}`,
        params,
        rowCount: effectiveRows.length,
    };
}

// Pick the dialect string from the version probe.
function dialectFor(version) {
    if (version && !version.isMariaDB) {
        if (version.major > 8 || (version.major === 8 && (version.minor > 0 || (version.minor === 0 && version.patch >= 20)))) {
            return 'alias';
        }
    }
    return 'values';
}

module.exports = { build, buildUpdate, dialectFor, bucketFor, BUCKETS, quoteIdent };
