var mongoose = require('mongoose');

var Trade = new mongoose.Schema({
  created: Date,
  updated: Date,
  company: String,
  name: String,
  description: String,
});

Trade.pre('save', function(callback) {
  var model = this;

  if (model.created === null){
    model.created = new Date();
  }

  model.updated = new Date();

  callback();
});

module.exports.TradeModel = mongoose.model('trade', Trade, 'trade');
