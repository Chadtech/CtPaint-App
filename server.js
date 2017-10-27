var express = require("express");
var http = require("http");
var bodyParser = require("body-parser");

var app = express();

module.exports = function(PORT, log) {
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({
    extended: true
  }));
  app.use("/", express.static(__dirname + "/development"));
  app.get("/", function(req, res, next) {
    var indexPage;
    indexPage = __dirname + "/development/index.html";
    return (res.status(200)).sendFile(indexPage);
  });
  var server = http.createServer(app);
  return server.listen(PORT, function() {
    return log("Running at localhost:" + PORT);
  });
};

