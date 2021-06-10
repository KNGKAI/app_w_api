var mongoose = require('mongoose');

var Product = new mongoose.Schema({
  createdDateTim: Date,
  updatedDateTime: Date,
  name: String,
  description: String,
  category: String,
  size: String,
  image: String,
  price: Number,
  inStock: Number,
});

Product.pre('save', function(callback) {
  var model = this;
  if (model.createdDateTime === null){
    model.createdDateTime = new Date();
  }
  model.updatedDateTime = new Date();
  callback();
});

module.exports.ProductModel = mongoose.model('product', Product);
