var express = require('express');
var router = express.Router();
var controller = require('../controllers/company');

router.post('/update', controller.update);
router.post('/createRole', controller.createRole);
router.post('/updateRole', controller.updateRole);
router.post('/removeRole', controller.removeRole);
router.post('/createTrade', controller.createTrade);
router.post('/updateTrade', controller.updateTrade);
router.post('/removeTrade', controller.removeTrade);

module.exports = router;
