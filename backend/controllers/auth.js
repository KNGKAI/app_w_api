var jwt = require('jsonwebtoken')
var passport = require('passport')

var { UserModel } = require('../models/user')

var options = {
    algorithm: process.env.JWT_ALGORITHM,
    expiresIn: process.env.JWT_EXPIRES
};

module.exports = {

    facebookAuth: function(req, res, next) {
        passport.authenticate('facebook', { scope: ['email'] })(req, res, next);
    },

    facebookCallback: async function(req, res, next) {
        await passport.authenticate('facebook', async function(err, user) {
            var userData = {
                username: user.first_name + " " + user.last_name,
                email: user.email,
            }
            await UserModel.findOrCreate({ email: user.email }, userData, function(err, doc, created) {
                if (err) {
                    return res.status(404).send({ message: err });
                } else {
                    return res.status(200).send({ user: doc });
                }
            });
        })(req, res, next);
    },

    facebookToken: async function(req, res, next) {
        var url = 'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=' + req.body.facebook_token;
        var options = { method: 'GET', url: url, json: true };
        request(options, async function(err, response) {
            if (err) {
                res.status(404).send({ message: err });
            } else {
                var item = {
                    username: response.body.name,
                    email: response.body.email,
                }
                await UserModel.findOrCreate({ email: response.body.email }, item, async function(err, user, created) {
                    if (err) {
                        res.status(404).send({ message: err });
                    } else if (user || created) {
                        var payload = {
                            user: user.id,
                            role: user.role
                        };
                        
                        var token = jwt.sign(payload, process.env.JWT_SECRET, options);
                        
                        res.status(200).send({ user: user, token: token });
                    } else {
                        res.status(404).send({ message: "user_not_found" });
                    }
                });
            }
        });
    },

    localAuth: async function(req, res, next) {
        passport.authenticate('local', async function(err, user) {
            if (err) {
                res.status(404).send({ message: err });
            } else if (user) {
                var payload = {
                    user: user.id,
                    role: user.role
                };

                var token = jwt.sign(payload, process.env.JWT_SECRET, options);

                res.status(200).send({
                    message: "success",
                    user: user,
                    token: token,
                })
            } else {
                res.status(404).send({ message: "user_not_found" });
            }
        })(req, res, next);
    },

    tokenAuth: async function(req, res, next) {
        var decoded = jwt.decode(req.body.token, options);
        if (decoded) {
            UserModel.findOne({ _id: decoded.user }, function(err, user) {
                if (err) {
                    res.status(404).send({ message: err });
                } else if (user) {
                    var payload = {
                        user: user.id,
                        role: user.role
                    };
                    var token = jwt.sign(payload, "swsh23hjddnns", options);
                    res.status(200).send({
                        message: "success",
                        user: user,
                        token: token,
                    })
                } else {
                    res.status(404).send({ message: "user_not_found" });
                }
            })
        } else {
            res.status(404).send({ message: "invalid_token" });
        }
    },

};
