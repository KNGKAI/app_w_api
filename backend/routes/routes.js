var express = require('express');
var router = express.Router();

var companyRouter = require('./company');
var userRouter = require('./user');

router.get('/', (req, res) => { res.send('api') });
router.use('/company', companyRouter);
router.use('/user', userRouter);

module.exports = router;