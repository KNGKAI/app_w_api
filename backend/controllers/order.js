const { OrderModel } = require('../models/order');
const { ProductModel } = require('../models/product');
const { UserModel } = require('../models/user');

module.exports = {
    
    getOrders: (req, res, next) => {
        OrderModel.find({}, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },
    
    getOrder: (req, res, next) => {
        OrderModel.findOne({ _id: req.qeury.id }, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },
    
    addOrder: (req, res, next) => {
        ProductModel.find({ _id : { $in: req.body.products.map(product => product.product) } }, async function(err, docs) {
            if (err) {
                res.status(404).send(err);
            } else if (docs) {
                var outOfStock = false;
                docs.forEach(product => {
                    var order = req.body.products.find(a => product.id == a.product)
                    var stock = product.stock.find(stock => stock.size == order.size)
                    if (stock.value < order.value) {
                        outOfStock = true
                    }
                })
                if (outOfStock) {
                    res.status(404).send({ message: "out_of_stock" });
                } else {
                    UserModel.findOne({ _id: req.body.user }, async function(err, user) {
                        if (err) {
                            res.status(404).send(err);
                        } else if (user) {
                            var total = 0;
                            for (let index = 0; index < docs.length; index++) {
                                var product = docs[index];
                                var order = req.body.products.find(a => product.id == a.product)
                                product.stock.find(stock => stock.size == order.size).value -= order.value;
                                product.save();
                                total += product.price * order.value;
                            }
                            if (user.budget >= total) {
                                var order = {
                                    user: req.body.user,
                                    products: req.body.products,
                                    status: 'placed',
                                    reference: Date.now(),
                                    total: total
                                }
                                await UserModel.updateOne({ _id : req.body.user }, { budget: user.budget - total })
                                var result = await OrderModel.create(order)
                                res.status(200).send(result)
                            } else {
                                res.status(404).send({ message: "out_of_budget" });
                            }
                        } else {
                            res.status(404).send({ message: "user_not_found" });
                        }
                    })
                }
            } else {
                res.status(404).send({ message: "products_not_found" });
            }
        })
    },
    
    removeOrder: (req, res, next) => {
        OrderModel.deleteOne({ _id: req.body.id }, function(err) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send({ message: "success" });
            }
        })
    },
    
    updateOrder: (req, res, next) => {
        OrderModel.updateOne({ _id: req.body.id }, req.body, function(err, doc) {
            if (err) {
                res.status(404).send(err);
            } else {
                res.status(200).send(doc);
            }
        })
    },

};