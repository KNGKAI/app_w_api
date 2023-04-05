var express = require('express');
var router = express.Router();
var controller = require('../controllers/company');

router.post('/update', controller.update);
router.post('/createRole', controller.createRole);
router.post('/updateRole', controller.updateRole);
router.post('/deleteRole', controller.deleteRole);
router.post('/createUser', controller.createUser);
router.post('/removeUser', controller.removeUser);

module.exports = router;
