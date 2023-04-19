var express = require('express');
var router = express.Router();
var controller = require('../controllers/user.js');

router.post('/register', controller.register);
router.post('/confirm', controller.confirm);
router.post('/auth', controller.auth);
router.post('/refresh', controller.refresh);
router.post('/update', controller.update);

module.exports = router;
