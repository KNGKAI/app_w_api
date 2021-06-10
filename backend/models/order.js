var mongoose = require('mongoose');

var Order = new mongoose.Schema({
  createdDateTim: Date,
  updatedDateTime: Date,
  user: String,
  product: String,
  status: String,
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
