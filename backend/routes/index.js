var express = require('express');
var router = express.Router();

router.get('/', (req, res, next) => {
    res.render('index', { title: '012skate' });
});

module.exports = router;
