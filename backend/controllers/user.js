var bcrypt = require('bcrypt')

var { UserModel } = require('../models/user')
var { PasswordModel } = require('../models/password')

exports.getUsers = (req, res, next) => {
    UserModel.find({}, function(err, docs) {
        if (err) {
            res.send(err);
        } else {
            res.send(docs);
        }
    })
}

exports.getUser = (req, res, next) => {
    UserModel.find({ _id: req.query.id }, function(err, doc) {
        if (err) {
            res.send(err);
        } else {
            res.send(doc);
        }
    })
}

exports.registerUser = (req, res, next) => {
    UserModel.findOne({ email: req.body.email }, function(err, doc) {
        if (err) {
            return res.status(404).send({ status: 'error', message: err });
        } else if (doc) {
            return res.status(404).send({ status: 'error', message: 'email_already_exists' });
        } else {
            var user = {
                username: req.body.username,
                email: req.body.email,
                role: 'user'
            }
            UserModel.create(user, function(err, doc) {
                if (err) {
                    return res.status(404).send({ status: 'error', message: err });
                } else if (doc) {
                    bcrypt.genSalt(13, function(err, salt) {
                        bcrypt.hash(req.body.password, salt, async function(err, hash) {
                            var item = {
                                user: doc._id,
                                hash: hash,
                            };
                            PasswordModel.create(item, function(err, doc, created) {
                                if (err) {
                                    return res.status(404).send({ status: 'error', message: err });
                                } else if (doc) {
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
}

exports.updateUser = (req, res, next) => {
    var id = req.body.id
    delete req.body.id
    UserModel.updateOne({ _id: id }, { $set: req.body }, function(err, doc) {
        if (err) {
            res.send(err);
        } else {
            res.send(doc);
        }
    })
}
