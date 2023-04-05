const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const passport = require('passport')

const { UserModel } = require('../models/user')
const { RoleModel } = require('../models/role');
const { CompanyyModel } = require('../models/company');

const options = {
    algorithm: process.env.JWT_ALGORITHM,
    expiresIn: process.env.JWT_EXPIRES
};

module.exports = {

    register: (req, res, next) => {
        UserModel.findOne({ email: req.body.email }, function(err, doc) {
            if (err) {
                return res.status(404).send({ status: 'error', message: err });
            } else if (doc) {
                return res.status(404).send({ status: 'error', message: 'email_already_exists' });
            } else {                
                UserModel.create({
                    username: req.body.fullname,
                    email: req.body.email,
                    confirmed: false,
                    active: true,
                }, function(err, user) {
                    if (err) {
                        res.status(404).send({ status: 'error', message: err });
                    } else if (user) {
                        bcrypt.genSalt(13, function(err, salt) {
                            if (err) {
                                res.status(404).send({ status: 'error', message: err });
                            } else {
                                bcrypt.hash(req.body.password, salt, async function(err, hash) {
                                    if (err) {
                                        res.status(404).send({ status: 'error', message: err });
                                    } else if (hash) {
                                        user.hash = hash;
                                        user.save(function(err, doc) {
                                            if (err) {
                                                res.status(404).send({ status: 'error', message: err });
                                            } else if (doc) {
                                                res.status(200).send({ status: 'success', message: 'user_created' });
                                            } else {
                                                res.status(404).send({ status: 'error', message: 'hash_error' });
                                            }
                                        });
                                    } else {
                                        res.status(404).send({ status: 'error', message: 'hash_error' });
                                    }
                                });
                            }
                        });
                    } else {
                        res.status(404).send({ status: 'error', message: 'user_not_created' });
                    }
                });
            }
        });
    },

    confirm: (req, res, next) => {
        console.log(req.body)
        var token = req.body.token
        var decoded = jwt.decode(token, options);
        if (decoded) {
            UserModel.findOne({ _id: decoded.user }, async function(err, user) {
                if (err) {
                    res.status(404).send({ message: err });
                } else if (user) {
                    // use role to see if user is starting a company or joining one
                    if (user.role == null) {
                        const role = await RoleModel.create({
                            name: 'admin',
                            description: 'admin',
                            features: 1,
                        });
                        if (role) {
                            user.role = role._id;
                            user.confirmed = true;
                            user.save(async function(err, doc) {
                                if (err) {
                                    res.status(404).send({ message: err });
                                } else if (doc) {
                                    const general = await RoleModel.create({
                                        name: 'general',
                                        description: 'general',
                                        features: 0,
                                    });
                                    if (general) {
                                        const company = await CompanyyModel.create({
                                            name: "untitled",
                                            description: "enter_description",
                                            users: [user._id],
                                            roles: [role._id, general._id],
                                        });
                                        company.save(function(err, doc) {
                                            if (err) {
                                                res.status(404).send({ status: 'error', message: err });
                                            } else {
                                                res.status(200).send({ status: 'success', message: 'user_confirmed' });
                                            }
                                        });
                                    } else {
                                        res.status(404).send({ message: "general_role_not_created" });
                                    }
                                } else {
                                    res.status(404).send({ message: "user_not_found" });
                                }
                            });
                        } else {
                            res.status(404).send({ message: "role_not_created" });
                        }
                    } else {
                        // user is joining a company
                        res.status(200).send({ status: 'success', message: 'user_confirmed' });
                    }
                } else {
                    res.status(404).send({ message: "user_not_found" });
                }
            })
        } else {
            res.status(404).send({ message: "invalid_token" });
        }
    },

    auth: async function(req, res, next) {
        passport.authenticate('local', async function(err, user) {
            if (err) {
                res.status(404).send({ message: err });
            } else if (user) {
                var token = jwt.sign({ user: user.id }, process.env.JWT_SECRET, options);
                res.status(200).send({
                    message: "success",
                    token: token,
                })
            } else {
                res.status(404).send({ message: "user_not_found" });
            }
        })(req, res, next);
    },

    refresh: async function(req, res, next) {
        var decoded = jwt.decode(req.body.token, options);
        if (decoded) {
            UserModel.findOne({ _id: decoded.user, confirmed: true, active: true }, function(err, user) {
                if (err) {
                    res.status(404).send({ message: err });
                } else if (user) {
                    RoleModel.findOne({ _id: user.role }, function(err, role) {
                        if (err) {
                            res.status(404).send({ message: err });
                        } else if (role) {
                            var token = jwt.sign({ user: user.id }, process.env.JWT_SECRET, options);
                            res.status(200).send({
                                message: "success",
                                user: user,
                                token: token,
                                admin: role.features > 0 ? true : false,
                            })
                        } else {
                            res.status(404).send({ message: "role_not_found" });
                        }
                    });
                } else {
                    res.status(404).send({ message: "user_not_found" });
                }
            })
        } else {
            res.status(404).send({ message: "invalid_token" });
        }
    },

    update: (req, res, next) => {
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

};
