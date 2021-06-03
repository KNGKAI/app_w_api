require('dotenv').config();

var viewConfig = require('./config/view');
var databseConfig = require('./config/database');
var authConfig = require('./config/auth');
var errorConfig = require('./config/error');
var utilitiesConfig = require('./config/utilities');
var routesConfig = require('./config/routes');

var express = require('express');

var app = express();

app.use(function(req,res,next){
    console.log(req.originalUrl);
    next();
});

viewConfig(app);
console.log("congigured views")
databseConfig(app);
console.log("congigured datebase")
authConfig(app);
console.log("congigured auth")
utilitiesConfig(app);
console.log("congigured utils")
routesConfig(app);
console.log("congigured routes")
errorConfig(app);
console.log("congigured errors")

module.exports = app;
