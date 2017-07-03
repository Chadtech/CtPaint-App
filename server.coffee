express = require "express"
http = require "http"
bodyParser = require "body-parser"


app = express()

module.exports = (PORT, log) ->

    app.use bodyParser.json()
    app.use (bodyParser.urlencoded (extended: true))
    app.use "/", (express.static (__dirname + "/development"))

    app.get "/", (req, res, next) ->
        indexPage = __dirname + "/development/index.html"
        (res.status 200).sendFile indexPage

    server = http.createServer app
    server.listen PORT, ->
        log ("Running at localhost:" + PORT)
