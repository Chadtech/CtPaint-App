util = require "gulp-util"
cp = require "child_process"

module.exports = ->
  cp.exec cmd, (error, stdout) ->
    util.log (util.colors.cyan "Tests"), stdout


cmd = [
  "mocha"
  "--compilers"
  "coffee:coffee-script/register"
  "tests/main.coffee"
].join " "