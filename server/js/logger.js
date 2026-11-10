'use strict';

let debugEnabled = false;

function setDebug(on) {
    debugEnabled = !!on;
}

module.exports = {
    setDebug,
    info(tag, msg) {
        console.log(`^5[kora_sql:${tag}]^7 ${msg}`);
    },
    warn(tag, msg) {
        console.log(`^3[kora_sql:${tag}]^7 ${msg}`);
    },
    error(tag, msg) {
        console.log(`^1[kora_sql:${tag}]^7 ${msg}`);
    },
    debug(tag, msg) {
        if (debugEnabled) console.log(`^8[kora_sql:${tag}:debug]^7 ${msg}`);
    },
};
