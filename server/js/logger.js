// Tiny namespaced logger. Every line is prefixed [qbsql:<tag>] so a server
// console full of resources stays greppable -- the same convention the Lua
// side of this codebase uses (`print("[qbsql:queue] ...")`).
//
// Colours use FiveM's console colour codes (^1 red ... ^7 reset), which the
// FXServer console renders and a plain terminal shows as literal text -- so
// they're kept minimal and always reset at end of line.

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
