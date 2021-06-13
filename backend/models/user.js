var mongoose = require('mongoose');

var User = new mongoose.Schema({
  createdDateTime: Date,
  updatedDateTime: Date,
  username: String,
  email: String,
  address: String,
  role: String,
});

User.pre('save', function(callback) {
  var model = this;
  if (model.createdDateTime === null){
    model.createdDateTime = new Date();
  }
  model.updatedDateTime = new Date();
  callback();
});

module.exports.UserModel = mongoose.model('user', User);
