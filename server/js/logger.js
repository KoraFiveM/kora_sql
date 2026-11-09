'use strict';

let debugEnabled = false;

function setDebug(on) {
    debugEnabled = !!on;
}

module.exports = {
    setDebug,
    info(tag, msg) {
        console.log(`^5[qbsql:${tag}]^7 ${msg}`);
    },
    warn(tag, msg) {
        console.log(`^3[qbsql:${tag}]^7 ${msg}`);
    },
    error(tag, msg) {
        console.log(`^1[qbsql:${tag}]^7 ${msg}`);
    },
    debug(tag, msg) {
        if (debugEnabled) console.log(`^8[qbsql:${tag}:debug]^7 ${msg}`);
    },
};
