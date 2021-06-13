var express = require('express');
var router = express.Router();
var categoryController = require('../controllers/category.js');

router.post('/add', categoryController.addCategory);
router.post('/remove', categoryController.removeCategory);
router.post('/update', categoryController.updateCategory);

module.exports = router;
