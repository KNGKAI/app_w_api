var mongoose = require('mongoose');

var Task = new mongoose.Schema({
  created: Date,
  updated: Date,
  site: String,
  label: String,
  description: String,
  status: Number,
  priority: Number,
  assigned: String,
  trade: String,
  site: String,
  start: Date,
  end: Date,
});

Task.pre('save', function(callback) {
  var model = this;

  if (model.created === null){
    model.created = new Date();
  }

  model.updated = new Date();

  callback();
});

module.exports.TaskModel = mongoose.model('task', Task, 'tasks');
