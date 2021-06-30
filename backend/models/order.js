var mongoose = require('mongoose');

var Order = new mongoose.Schema({
  createdDateTime: Date,
  updatedDateTime: Date,
  user: String,
  products: [Object],
  status: String,
  reference: String,
});

Order.pre('save', function(callback) {
  var model = this;
  if (model.createdDateTime === null){
    model.createdDateTime = new Date();
  }
  model.updatedDateTime = new Date();
  callback();
});

module.exports.OrderModel = mongoose.model('order', Order);
