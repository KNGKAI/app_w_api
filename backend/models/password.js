var mongoose = require('mongoose');

var Password = new mongoose.Schema({
  user: String,
  hash: String,
});

module.exports.PasswordModel = mongoose.model('password', Password);
