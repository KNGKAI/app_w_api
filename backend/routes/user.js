var express = require('express');
var router = express.Router();
var userController = require('../controllers/user.js');

router.get('/', userController.getUsers);
router.get('/get', userController.getUser);
router.post('/register', userController.registerUser);
router.post('/update', userController.updateUser);

module.exports = router;
