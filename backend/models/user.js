var mongoose = require('mongoose');

var User = new mongoose.Schema({
  created: Date,
  updated: Date,
  username: String,
  email: String,
  hash: String,
  role: String,
  active: Boolean,
  confirmed: Boolean,
});

User.pre('save', function(callback) {
  var model = this;
  
  if (model.created === null){
    model.created = new Date();
  }

  model.updated = new Date();

  callback();
});

module.exports.UserModel = mongoose.model('user', User, 'users');
