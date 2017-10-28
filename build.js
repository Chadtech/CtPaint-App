var util = require("gulp-util");
var cp = require("child_process");
var gulp = require("gulp");
var concat = require("gulp-concat");
var browserify = require("browserify");
var source = require("vinyl-source-stream");
var buffer = require("vinyl-buffer");

module.exports = function() {
    var cmd = [
        "elm-make",
        "./source/Main.elm",
        "--output",
        "bin/paint-app-elm.js"
    ].join(" ");

    var stdout;
    stdout = cp.execSync(cmd);
    util.log(String(stdout));

    gulp.src(["./bin/paint-app-elm-loader.js", "./source/paint-app.js"])
        .pipe(concat("app.js"))
        .pipe(gulp.dest("./bin/"));

    var b = browserify("./bin/app.js", {debug: false})
        .bundle()
        .pipe(source("paint-app.js"))
        .pipe(buffer())
        .pipe(gulp.dest("./bin/"));
};
