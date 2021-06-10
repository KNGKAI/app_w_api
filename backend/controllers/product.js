const { ProductModel } = require('../models/product');

module.exports = {
    
    getProducts: (req, res, next) => {
        ProductModel.find({}, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    getProduct: (req, res, next) => {
        ProductModel.findOne({ _id: req.qeury.id }, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    addProduct: (req, res, next) => {
        ProductModel.create(req.body, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    removeProduct: (req, res, next) => {
        ProductModel.deleteOne({ _id: req.body.id }, function(err) {
            if (err) {
                res.send(err);
            } else {
                res.send("success");
            }
        })
    },
    
    updateProduct: (req, res, next) => {
        ProductModel.updateOne({ _id: req.body.id }, req.body, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },

};