var mongoose = require('mongoose');

var Role = new mongoose.Schema({
  name: String,
  description: String,
  features: Number,
});

module.exports.RoleModel = mongoose.model('role', Role, 'roles');
