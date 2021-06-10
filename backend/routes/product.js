var express = require('express');
var router = express.Router();
var productController = require('../controllers/product.js');

router.get('/', productController.getProducts);
router.get('/get', productController.getProduct);
router.post('/add', productController.addProduct);
router.post('/remove', productController.removeProduct);
router.post('/update', productController.updateProduct);

module.exports = router;
