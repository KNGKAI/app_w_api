var mongoose = require('mongoose');

var Password = new mongoose.Schema({
  createdDateTim: Date,
  user: String,
  hash: String,
});

Password.pre('save', function(callback) {
  var model = this;
  if (model.createdDateTime === null){
    model.createdDateTime = new Date();
  }
  callback();
});

module.exports.PasswordModel = mongoose.model('password', Password);
