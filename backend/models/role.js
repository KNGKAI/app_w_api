var mongoose = require('mongoose');

var Role = new mongoose.Schema({
  created: Date,
  updated: Date,
  company: String,
  name: String,
  description: String,
  features: Number,
});

Role.pre('save', function(callback) {
  var model = this;
  
  if (model.created === null){
    model.created = new Date();
  }

  model.updated = new Date();

  callback();
});

module.exports.RoleModel = mongoose.model('role', Role, 'roles');
