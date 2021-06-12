const { CategoryModel } = require('../models/category');


module.exports = {
    
    addCategory: (req, res, next) => {
        CategoryModel.create(req.body, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },
    
    updateCategory: (req, res, next) => {
        CategoryModel.updateOne({ _id: req.body.id }, req.body, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },
    
    removeCategory: (req, res, next) => {
        CategoryModel.deleteOne({ _id: req.body.id }, function(err) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send("success");
            }
        })
    },

};