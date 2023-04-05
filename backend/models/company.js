var mongoose = require('mongoose');

var Company = new mongoose.Schema({
  name: String,
  description: String,
  users: [String],
  roles: [String],
});

module.exports.CompanyyModel = mongoose.model('company', Company, 'companies');
