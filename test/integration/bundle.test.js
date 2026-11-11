'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

test('the packaged bundle registers exports and completes a real query', () => {
    const testDir = path.resolve(__dirname, '..');
    const result = spawnSync(process.execPath, ['integration/bundle-child.js'], {
        cwd: testDir,
        env: process.env,
        encoding: 'utf8',
        timeout: 15000,
    });

    assert.equal(result.error, undefined, result.error && result.error.message);
    assert.equal(result.status, 0, result.stderr || result.stdout);
    assert.match(result.stdout, /bundle round trip ok/);
});
