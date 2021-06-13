var express = require('express');
var router = express.Router();
var orderController = require('../controllers/order.js');

router.get('/', orderController.getOrders);
router.get('/get', orderController.getOrder);
router.post('/add', orderController.addOrder);
router.post('/remove', orderController.removeOrder);
router.post('/update', orderController.updateOrder);

module.exports = router;
