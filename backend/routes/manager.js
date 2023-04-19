var express = require('express');
var router = express.Router();
var controller = require('../controllers/manager.js');

router.post('/createSite', controller.createSite);
router.post('/updateSite', controller.updateSite);
router.post('/removeSite', controller.removeSite);
router.post('/createTask', controller.createTask);
router.post('/updateTask', controller.updateTask);
router.post('/removeTask', controller.removeTask);

module.exports = router;
