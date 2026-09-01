'use strict';

const { build } = require('esbuild');

build({
    bundle: true,
    entryPoints: ['server/js/index.js'],
    outfile: 'dist/build.js',
    keepNames: true,
    legalComments: 'inline',
    platform: 'node',
    target: ['node16'],
    format: 'cjs',
    logLevel: 'info',
}).catch(() => process.exit(1));
