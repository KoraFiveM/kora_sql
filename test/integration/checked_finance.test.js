// Run only against an explicitly supplied disposable Unix-socket database.
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const mysql = require('mysql2/promise');
const { TransactionRunner } = require('../../server/js/transaction');

test('checked finance SQL commits receipts and rejects zero-row domain changes on MariaDB', {
    skip: !process.env.QBSQL_TEST_SOCKET,
}, async () => {
    const pool = mysql.createPool({ socketPath: process.env.QBSQL_TEST_SOCKET, user: 'root', database: 'finance_test', multipleStatements: true });
    const runner = new TransactionRunner({ write: pool });
    try {
        await pool.query(`CREATE TABLE players (citizenid VARCHAR(50) PRIMARY KEY, money LONGTEXT, deleted_at TIMESTAMP NULL) ENGINE=InnoDB;
            CREATE TABLE property (id INT PRIMARY KEY, owner VARCHAR(50), revision INT) ENGINE=InnoDB;`);
        const root = path.resolve(__dirname, '../..');
        await pool.query(fs.readFileSync(path.join(root, '../kora_banking/banking.sql'), 'utf8'));
        await pool.query(fs.readFileSync(path.join(root, '../kora_banking/sql/001_durable_operations.sql'), 'utf8'));
        await pool.query(fs.readFileSync(path.join(root, '../kora_core/sql/010_player_column_operations.sql'), 'utf8'));
        await pool.query(`INSERT INTO players VALUES ('BUYER', '{"bank":1000,"cash":25}', NULL), ('SELLER','{"bank":0}',NULL);
            INSERT INTO property VALUES (1,'SELLER',1);
            INSERT INTO bank_accounts (account_name,account_balance,account_type) VALUES ('society',0,'job');`);
        const source = fs.readFileSync(path.join(root, '../kora_banking/server/finance.lua'), 'utf8');
        const playerUpdate = source.match(/query = \[\[(UPDATE `players`[\s\S]*?)\]\]/)[1];
        const accountUpdate = source.match(/query = \[\[(UPDATE `bank_accounts`[\s\S]*?)\]\]/)[1];
        const request = (key, expectedOwner = 'SELLER') => [
            { query: 'INSERT INTO bank_operations (resource,operation_key,request,receipt) VALUES (?,?,?,?)', values: ['kora_housing',key,'immutable','{"status":"completed"}'], expectedRows: 1 },
            { query: playerUpdate, values: [-100,'BUYER',100,100,-100], expectedRows: 1, failureCode: 'insufficient_funds' },
            { query: playerUpdate, values: [94,'SELLER',0,0,94], expectedRows: 1 },
            { query: accountUpdate, values: [6,'society',0,0,6], expectedRows: 1 },
            { query: 'UPDATE property SET owner=?,revision=revision+1 WHERE id=1 AND owner=? AND revision=1', values: ['BUYER',expectedOwner], expectedRows: 1 },
        ];
        assert.equal((await runner.transactionChecked(request('sale'))).success, true);
        assert.deepEqual((await pool.query('SELECT JSON_EXTRACT(money,"$.bank") AS balance FROM players ORDER BY citizenid'))[0].map(r => Number(r.balance)), [900,94]);
        assert.equal((await pool.query('SELECT account_balance FROM bank_accounts'))[0][0].account_balance, 6);
        assert.equal((await runner.transactionChecked(request('sale'))).code, 'duplicate');
        assert.equal((await runner.transactionChecked(request('stale','OLD_OWNER'))).code, 'conflict');
        assert.equal((await pool.query('SELECT COUNT(*) AS n FROM bank_operations'))[0][0].n, 1);
        assert.equal(Number((await pool.query('SELECT JSON_EXTRACT(money,"$.bank") AS balance FROM players WHERE citizenid="BUYER"'))[0][0].balance), 900);
        const poor = request('poor'); poor[1].values = [-1001,'BUYER',1001,1001,-1001];
        assert.equal((await runner.transactionChecked(poor)).code, 'insufficient_funds');
        const restarted = new TransactionRunner({ write: pool });
        assert.equal((await restarted.transactionChecked(request('sale'))).code, 'duplicate');
        assert.equal((await pool.query('SELECT owner,revision FROM property'))[0][0].revision, 2);
        assert.equal((await runner.transactionChecked([{ query: playerUpdate, values: [0,'BUYER',0,0,0], expectedRows: 1 }])).success, true, 'unchanged matched rows retain mysql2 FOUND_ROWS semantics');
        await pool.query('INSERT INTO qbcore_player_column_operations (citizenid,column_name,resource,operation_key,fingerprint) VALUES (?,?,?,?,?)', ['BUYER','money','kora_banking','qbhousing:sale','[["BUYER"],["money"]]']);
        assert.equal((await pool.query('SELECT COUNT(*) AS n FROM qbcore_player_column_operations'))[0][0].n, 1);
        await pool.query("UPDATE players SET money='{\"bank\":-100}' WHERE citizenid='SELLER'");
        assert.equal((await runner.transactionChecked([{ query: playerUpdate, values: [20,'SELLER',0,0,20], expectedRows: 1 }])).success, true);
        const receiptRead = source.match(/query = '(SELECT `request`,`receipt`[^']+FOR UPDATE)'/)[1];
        for (const commit of [true, false]) {
            const oldConnection = await pool.getConnection();
            const key = commit ? 'old-driver-commit' : 'old-driver-rollback';
            await oldConnection.beginTransaction();
            await oldConnection.query('INSERT INTO bank_operations (resource,operation_key,request,receipt) VALUES (?,?,?,?)', ['kora_housing',key,'terms','{"status":"completed"}']);
            // A fresh runner has no old worker map, as after a SQL-host restart.
            let finished = false;
            const lookup = restarted.transactionChecked([{ query: receiptRead, values: ['kora_housing', key] }]).then(result => { finished = true; return result; });
            await new Promise(resolve => setTimeout(resolve, 25));
            assert.equal(finished, false, 'locking absence checks wait for the old server-side receipt transaction');
            if (commit) await oldConnection.commit(); else await oldConnection.rollback();
            oldConnection.release();
            const outcome = await lookup;
            assert.equal(outcome.success, true);
            assert.equal(outcome.results[0].length, commit ? 1 : 0);
        }
    } finally { await pool.end(); }
});
