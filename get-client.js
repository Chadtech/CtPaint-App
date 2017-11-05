var cp = require("child_process");

function exec(cmd) {
    var stdout = String(cp.execSync(cmd));
    console.log(stdout);
};

function makeCmd(cmds) {
    return cmds.join(" && ");
};

var gitClone = "git clone git@github.com:Chadtech/CtPaint-Client.git client";

var npmInstall = makeCmd([
    "cd client",
    "npm install"
]);

var buildClient = makeCmd([
    "cd client",
    "gulp js"
]);

var moveClientJs = makeCmd([
    "cp ./client/bin/client.js ./development"
]);

var finish = "rm -rf client";

[ gitClone
, npmInstall
, buildClient
, moveClientJs
, finish
].forEach(exec);

