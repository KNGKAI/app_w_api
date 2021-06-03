var express = require('express');
var router = express.Router();
var authController = require('../controllers/auth.js');

router.post('/local', authController.localAuth);
router.post('/token', authController.tokenAuth);
router.get('/facebook', authController.facebookAuth);
router.post('/facebook/token', authController.facebookToken);
router.get('/facebook/callback', authController.facebookCallback);

module.exports = router;