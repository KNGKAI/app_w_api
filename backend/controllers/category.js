const { CategoryModel } = require('../models/category');


module.exports = {
    
    addCategory: (req, res, next) => {
        CategoryModel.create(req.body, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    updateCategory: (req, res, next) => {
        CategoryModel.updateOne({ _id: req.body.id }, req.body, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    removeCategory: (req, res, next) => {
        CategoryModel.deleteOne({ _id: req.body.id }, function(err) {
            if (err) {
                res.send(err);
            } else {
                res.send("success");
            }
        })
    },

};