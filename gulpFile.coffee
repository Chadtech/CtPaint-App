gulp = require "gulp"
stylus = require "./gulp-processes/stylus"
browserify = require "./gulp-processes/browserify"
elm = require "./gulp-processes/elm"
tests = require "./gulp-processes/tests"
coffeelint = require "gulp-coffeelint"

production = false
paths =
  development: "./development"
  distribution: "./distribution"
  mainElm: "./source/Main.elm"
  elm: "./source/**/*.elm"
  mainCss: "./source/Styles/main.styl"
  css: "./source/**/*.styl"
  mainJs: "./source/app.coffee"
  coffee: "./source/**/*.coffee",
  server: "./server.coffee",
  tests: "./tests/**/*.coffee"

{ mainJs, development } = paths
gulp.task "coffee", (browserify mainJs, development, production)

gulp.task "stylus", stylus paths
gulp.task "elm", [ "elm-format", "elm-make"]
gulp.task "elm-format", elm.format
gulp.task "elm-make", elm.make
gulp.task "tests", tests
gulp.task "server", -> require "./server.coffee"
gulp.task "lint", ->
  gulp.src paths.server
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

gulp.task "distribution", ->
  production = true
  gulp.start "default"
  gulp
    .src (paths.development + "/**/*")
    .pipe (gulp.dest path.distribution)

gulp.task "watch", ->
  gulp.watch paths.elm, [ "elm" ]
  gulp.watch paths.css, [ "stylus" ]
  gulp.watch paths.coffee, [ "coffee", "lint" ]
  gulp.watch paths.tests, [ "tests"]

gulp.task "default", [ "watch", "elm", "coffee", "tests", "stylus", "server" ]
