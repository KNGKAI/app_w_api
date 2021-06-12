const { ProductModel } = require('../models/product');

module.exports = {
    
    getProducts: (req, res, next) => {
        ProductModel.find({}, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },
    
    getProduct: (req, res, next) => {
        ProductModel.findOne({ _id: req.qeury.id }, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).status(404).send(doc);
            }
        })
    },
    
    addProduct: (req, res, next) => {
        ProductModel.create(req.body, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },
    
    removeProduct: (req, res, next) => {
        ProductModel.deleteOne({ _id: req.body.id }, function(err) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send("success");
            }
        })
    },
    
    updateProduct: (req, res, next) => {
        ProductModel.updateOne({ _id: req.body.id }, req.body, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },

};