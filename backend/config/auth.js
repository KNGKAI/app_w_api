var bcrypt = require('bcrypt')
var passport = require('passport');

var LocalStrategy = require('passport-local').Strategy;
var FacebookStrategy = require('passport-facebook').Strategy;

var { UserModel } = require('../models/user')
var { PasswordModel } = require('../models/password')

async function verifyHandler(username, password, done) {
    await UserModel.findOne({ username: username }, async function(err, user) {
        if (!user) return done("user_not_found", false);
        PasswordModel.findOne({ user: user._id }, async function(err, doc) {
            if (err) return done(err, false);
            if (doc) {
                await bcrypt.compare(password, doc.hash, function(e, match) {
                    if (e) return done(e, false);
                    if (match) return done(null, user);
                    return done('unknown', false)
                });
            } else {
                return done("failed", false);
            }
        });
    })
}

function verifyFacebookHandler(req, token, tokenSecret, profile, done) {
    process.nextTick(function() {
        var options = { method: 'GET', url: url.replace('%s', token), json: true };
        request(options, function(err, response) {
            if (err) {
                return done(null, null);
            }

            var data = {
                id: response.body.id,
                first_name: response.body.first_name,
                last_name: response.body.last_name,
                email: response.body.email
            };

            return done(null, data);
        });
    });
}

module.exports = (app) => {
    passport.serializeUser(function(user, done) {
        done(null, user.id);
    });
    
    passport.deserializeUser(function(id, done) {
        UserModel.findOne({ _id: id }, function(err, user) {
            done(err, user);
        });
    });
    
    passport.use(new LocalStrategy({
        usernameField: 'username',
        passwordField: 'password'
    }, verifyHandler));
    
    passport.use(new FacebookStrategy({
        clientID: process.env.FACEBOOK_CLIENT_ID,
        clientSecret: process.env.FACEBOOK_CLIENT_SECRET,
        callbackURL: '/api/auth/facebook/callback',
        passReqToCallback: true
    }, verifyFacebookHandler));
    
    app.use(passport.initialize());
    app.use(passport.session());
}