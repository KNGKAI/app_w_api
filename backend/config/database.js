var mongo = require('mongodb');
var mongoose = require('mongoose');

module.exports = (app) => {
    var url = 'mongodb://' + process.env.DBUSERNAME + ':' + process.env.DBPASSWORD + '@' + process.env.DBHOST + ':' + process.env.DBPORT + '/' + process.env.DBNAME + "?ssl=true&retrywrites=false&maxIdleTimeMS=120000&appName=@012skate-db@"
    console.log('dbserver: ' + url);

    mongoose.Promise = global.Promise;
    mongoose.connect(url, { useNewUrlParser: true , useUnifiedTopology: true });
    var db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));
    db.once('open', function() {
        console.log("db connected")
    });
};