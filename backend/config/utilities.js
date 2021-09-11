var logger = require('morgan');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var cors = require("cors");

module.exports = (app) => {;
    app.use(cors());
    app.use(logger('dev'));
    app.use(express.json({ limit: '10mb' }));
    app.use(express.urlencoded({ limit: '10mb' }))
    app.use(cookieParser());
    app.use(express.static(path.join(__dirname,'..','public')));
};