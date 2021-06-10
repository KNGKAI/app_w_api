const { OrderModel } = require('../models/order');

module.exports = {
    
    getOrders: (req, res, next) => {
        OrderModel.find({}, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    getOrder: (req, res, next) => {
        OrderModel.findOne({ _id: req.qeury.id }, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    addOrder: (req, res, next) => {
        OrderModel.create(req.body, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },
    
    removeOrder: (req, res, next) => {
        OrderModel.deleteOne({ _id: req.body.id }, function(err) {
            if (err) {
                res.send(err);
            } else {
                res.send("success");
            }
        })
    },
    
    updateOrder: (req, res, next) => {
        OrderModel.updateOne({ _id: req.body.id }, req.body, function(err, doc) {
            if (err) {
                res.send(err);
            } else {
                res.send(doc);
            }
        })
    },

};