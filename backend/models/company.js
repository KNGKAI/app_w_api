var mongoose = require('mongoose');

var Company = new mongoose.Schema({
  created: Date,
  updated: Date,
  name: String,
  description: String,
});

Company.pre('save', function(callback) {
  var model = this;
  
  if (model.created === null){
    model.created = new Date();
  }

  model.updated = new Date();

  callback();
});

module.exports.CompanyModel = mongoose.model('company', Company, 'companies');
