express = require "express"
http = require "http"
bodyParser = require "body-parser"
util = require "gulp-util"


app = express()

PORT = 2977

app.use bodyParser.json()
app.use (bodyParser.urlencoded (extended: true))
app.use "/", (express.static (__dirname + "/development"))

app.get "/", (req, res, next) ->
    indexPage = __dirname + "/development/index.html"
    (res.status 200).sendFile indexPage

server = http.createServer app
server.listen PORT, ->
    util.log ("Running at localhost:" + PORT)
