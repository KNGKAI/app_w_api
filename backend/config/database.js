var mongo = require('mongodb');
var mongoose = require('mongoose');

module.exports = (app) => {
    var url = process.env.DBURL + process.env.DBNAME
    console.log('dbserver: ' + url);

    mongoose.Promise = global.Promise;
    mongoose.connect('mongodb://' + url, { useNewUrlParser: true , useUnifiedTopology: true });
    var db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));
    db.once('open', function() {
        console.log("db connected")
    });
};