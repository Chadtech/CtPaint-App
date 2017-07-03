gulp = require "gulp"
source = require "vinyl-source-stream"
buffer = require "vinyl-buffer"
cp = require "child_process"
stylus = require "gulp-stylus"
coffeeify = require "coffeeify"
browserify = require "browserify"
concat = require "gulp-concat"
util = require "gulp-util"


paths =
    development: "./development"
    distribution: "./distribution"
    mainElm: "./source/Main.elm"
    elm: "./source/**/*.elm"
    css: "./source/**/*.styl"
    coffee: "./source/**/*.coffee"

production = false


gulp.task "coffee", ->

    config =
        debug: not production
        cash: {}

    b = browserify "./source/app.coffee", config

    b
        .transform coffeeify
        .bundle()
        .pipe (source "app.js")
        .pipe buffer()
        .pipe (gulp.dest paths.development)


gulp.task "stylus", ->
    gulp
        .src [ "./source/Styles/main.styl", paths.css ]
        .pipe (concat "style.styl")
        .pipe stylus()
        .pipe (gulp.dest paths.development)


gulp.task "elm", [ "elm-format", "elm-make" ]


gulp.task "elm-format", ->
    cmd = "elm-format ./source --yes"
    cp.exec cmd, ->


gulp.task "elm-make", ->
    cmd = [
        "elm-make"
        paths.mainElm
        "--warn"
        "--output"
        paths.development + "/elm.js"
    ].join " "

    cp.exec cmd, (error, stdout, stderr) ->
        if error
            error = (String error).slice 0, (String error).length - 1
            (error.split "\n").forEach (line) ->
                util.log (util.colors.red (String line))
        else
            stderr = stderr.slice 0, stderr.length - 1
            (stderr.split "\n").forEach (line) ->
                util.log (util.colors.yellow (String line))

        stdout = stdout.slice 0, stdout.length - 1
        (stdout.split "\n").forEach (line) ->
            util.log (util.colors.cyan "Elm"), line


gulp.task "server", ->
    (require "./server")(2965, util.log)


gulp.task "distribution", ->
    production = true
    gulp.task "default"

    gulp
        .src (paths.development + "/**/*")
        .pipe (gulp.dest paths.distribution)


gulp.watch paths.elm, [ "elm" ]
gulp.watch paths.css, [ "stylus" ]
gulp.watch paths.coffee, [ "coffee" ]


gulp.task "default", [ "elm", "coffee", "stylus", "server" ]