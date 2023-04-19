var express = require('express');
var router = express.Router();

var company = require('./company');
var user = require('./user');
var manager = require('./manager');

router.get('/', (req, res) => { res.send('api') });
router.use('/company', company);
router.use('/user', user);
router.use('/manager', manager);

module.exports = router;