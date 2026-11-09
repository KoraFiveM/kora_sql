'use strict';

const BUCKETS = [1, 2, 4, 8, 16, 32, 64, 128, 200];

function bucketFor(n) {
    for (const b of BUCKETS) {
        if (n <= b) return b;
    }
    return n;
}

function quoteIdent(id) {
    return '`' + String(id).replace(/`/g, '``') + '`';
}

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

function build(table, conflictKey, columns, rows, opts) {
    const mode = (opts && opts.mode) || 'assign';
    const dialect = (opts && opts.dialect) || 'values';
    const pad = opts && opts.pad;

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

    const composite = keyCols.length > 1;
    const tuple = composite ? '(' + keyCols.map(() => '?').join(',') + ')' : '?';
    const keyList = composite ? '(' + keyCols.map(quoteIdent).join(',') + ')' : quoteIdent(keyCols[0]);
    for (const row of effectiveRows) {
        const pkVals = Array.isArray(row.pk) ? row.pk : [row.pk];
        for (const value of pkVals) params.push(value);
    }
    const where = `${keyList} IN (${new Array(effectiveRows.length).fill(tuple).join(',')})`;

    return {
        sql: `UPDATE ${quoteIdent(table)} SET ${assignments.join(', ')} WHERE ${where}`,
        params,
        rowCount: effectiveRows.length,
    };
}

function dialectFor(version) {
    if (version && !version.isMariaDB) {
        if (version.major > 8 || (version.major === 8 && (version.minor > 0 || (version.minor === 0 && version.patch >= 20)))) {
            return 'alias';
        }
    }
    return 'values';
}

module.exports = { build, buildUpdate, dialectFor, bucketFor, BUCKETS, quoteIdent };
