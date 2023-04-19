var mongoose = require('mongoose');

var Site = new mongoose.Schema({
  created: Date,
  updated: Date,
  company: String,
  name: String,
  description: String,
  address: String,
});

Site.pre('save', function(callback) {
  var model = this;
  
  if (model.created === null){
    model.created = new Date();
  }

  model.updated = new Date();

  callback();
});

module.exports.SiteModel = mongoose.model('site', Site, 'sites');
