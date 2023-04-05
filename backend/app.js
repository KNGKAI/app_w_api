require('dotenv').config();

var express = require('express');
var mongoose = require('mongoose');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;

var { graphqlHTTP } = require('express-graphql');

var logger = require('morgan');
var createError = require('http-errors');
var path = require('path');
var cookieParser = require('cookie-parser');
var cors = require("cors");
var bcrypt = require('bcrypt')

var { UserModel } = require('./models/user')

var schema = require('./schema/schema')
var routes = require('./routes/routes');
var userRouter = require('./routes/user');

console.log("starting server")

var app = express();

// database
mongoose.Promise = global.Promise;
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true , useUnifiedTopology: true });

var db = mongoose.connection;

db.on('error', function(err) {
    console.log("database error: ", err);
});

db.once('open', function() {
    console.log("database connected!");
});

// auth
passport.serializeUser(function(user, done) {
    done(null, user.id);
});

passport.deserializeUser(function(id, done) {
    UserModel.findOne({ _id: id }, function(err, user) {
        done(err, user);
    });
});

passport.use(new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
}, async (username, password, done) => {
    await UserModel.findOne({ email: username }, async function(err, user) {
        if (err) {
            return done(err, false);
        } else if (user) {
            bcrypt.compare(password, user.hash, function(err, match) {
                if (err) {
                    return done(err, false);
                } else if (match) {
                    return done(null, user);
                } else {
                    return done("unknown", false);
                }
            });
        } else {
            return done("user_not_found", false);
        }
    })
}));

app.use(passport.initialize());

// view engine setup
app.set('views', path.join(__dirname, '.', 'views'));
app.set('view engine', 'ejs');

// util
app.use(cors());
app.use(logger('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb' }))
app.use(cookieParser());
app.use(express.static(path.join(__dirname,'..','public')));

// routes
// app.use('/', (req, res) => { res.send('*') });
app.use('/api', routes);

// graphql
app.use('/gql', graphqlHTTP({
    schema,
    graphiql: true,
}))

// log requests
app.use(function(req,res,next){
    console.log(req.method, req.url);
    next();
});

// error handler
app.use(function (req, res, next) {
    next(createError(404));
});

app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    res.status(err.status || 500);
    res.render('error');
});

module.exports = app;
