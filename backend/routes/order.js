var express = require('express');
var router = express.Router();
var orderController = require('../controllers/order.js');

router.get('/', orderController.getOrders);
router.get('/get', orderController.getOrder);
// router.post('/add', orderController.addProduct);
// router.post('/remove', orderController.removeProduct);
// router.post('/update', orderController.updateProduct);

module.exports = router;
