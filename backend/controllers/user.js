var jwt = require('jsonwebtoken')
var bcrypt = require('bcrypt')

var { UserModel } = require('../models/user')
var { PasswordModel } = require('../models/password');
const { sendMail } = require('../utils/CommsUtil');


module.exports = {

    registerUser: (req, res, next) => {
        UserModel.findOne({ email: req.body.email }, function(err, doc) {
            if (err) {
                return res.status(404).send({ status: 'error', message: err });
            } else if (doc) {
                return res.status(404).send({ status: 'error', message: 'email_already_exists' });
            } else {
                var user = {
                    username: req.body.username,
                    email: req.body.email,
                    address: req.body.address,
                    role: 'user',
                    budget: 5000
                }
                UserModel.create(user, function(err, doc) {
                    if (err) {
                        return res.status(404).send({ status: 'error', message: err });
                    } else if (doc) {
                        //
                        // confirmation email
                        //
                        // var payload = {
                        //     user: doc.id,
                        //     role: doc.role
                        // };
                        // var options = {
                        //     algorithm: process.env.JWT_ALGORITHM,
                        //     expiresIn: process.env.JWT_EXPIRES
                        // };
                        // var token = jwt.sign(payload, process.env.JWT_SECRET, options);
                        // sendMail(user.email, "Confirm email address", "Please confirm your email address by clicking this link: https://012sktate-server.azurewebsites.net/api/user/confirm/?token=" + token)
                        //

                        bcrypt.genSalt(13, function(err, salt) {
                            bcrypt.hash(req.body.password, salt, async function(err, hash) {
                                var item = {
                                    user: doc._id,
                                    hash: hash,
                                };
                                PasswordModel.create(item, function(err, created) {
                                    if (err) {
                                        return res.status(404).send({ status: 'error', message: err });
                                    } else if (created) {
                                        ChatModel.create({ user: doc.id, messages: [ "Welcome to 012skate!" ] })
                                        return res.status(200).send({ status: 'success', message: 'success' });
                                    } else {
                                        return res.status(404).send({ status: 'error', message: 'unknown_password_create_error' });
                                    }
                                });
                            });
                        });
                    } else {
                        return res.status(404).send({ status: 'error', message: 'unknown_user_create_error' });
                    }
                })
            }
        });
    },

    confirmUser: (req, res, next) => {
        var token = req.body.token
        var decoded = jwt.decode(token, options);
        if (decoded) {
            UserModel.findOne({ _id: decoded.user }, function(err, user) {
                if (err) {
                    res.status(404).send({ message: err });
                } else if (user) {
                    UserModel.updateOne({ _id: decoded.user }, { confirmed: true }, function(err, updated) {
                        if (err) {
                            res.status(404).send({ message: err });
                        } else if (updated) {
                            res.status(200).send({ message: "user_confirmed" })
                        } else {
                            res.status(404).send({ message: "update_error" });
                        }
                    })
                } else {
                    res.status(404).send({ message: "user_not_found" });
                }
            })
        } else {
            res.status(404).send({ message: "invalid_token" });
        }
    },

    updateUser: (req, res, next) => {
        var id = req.body.id
        delete req.body.id
        UserModel.updateOne({ _id: id }, req.body, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },

    postMessage: (req, res, next) => {
        UserModel.findOne({ _id: req.body.user }, req.body, function(err, doc) {
            if (err) {
                res.status(404).send({ message: "error", error: err });
            } else if (doc) {
                var chat = user.chat
                chat.push(doc.username + ' - ' + new Date() + ': ' + req.body.message)
                UserModel.updateOne({ _id: req.body.user }, { "chat": chat}, function(err, updated) {
                    if (err) {
                        res.status(404).send({ message: "error", error: err });
                    } else if (updated) {
                        res.status(200).send({ message: "success" });
                    } else {
                        res.status(404).send({ message: "unknown" });
                    }
                })
            } else {
                res.status(404).send({ message: "user_not_found" });
            }
        })
    }

};
