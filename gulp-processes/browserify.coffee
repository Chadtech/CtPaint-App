browserify = require "browserify"
gulp = require "gulp"
source = require "vinyl-source-stream"
buffer = require "vinyl-buffer"
coffeeify = require "coffeeify"

module.exports = (from, to, production) ->
  config = {
    debug: not production
    cache: {}
    extensions: [ ".coffee" ]
  }

  b = browserify from, config
  b.transform coffeeify

  -> 
    b.bundle()
      .pipe source "app.js"
      .pipe buffer()
      .pipe gulp.dest to

