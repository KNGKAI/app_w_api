var mongoose = require('mongoose');

var Category = new mongoose.Schema({
  createdDateTim: Date,
  updatedDateTime: Date,
  name: String,
  description: String,
});

Category.pre('save', function(callback) {
  var model = this;
  if (model.createdDateTime === null){
    model.createdDateTime = new Date();
  }
  model.updatedDateTime = new Date();
  callback();
});

module.exports.CategoryModel = mongoose.model('category', Category, 'categories');
