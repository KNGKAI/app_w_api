var indexRouter = require('../routes/index');
var authRouter = require('../routes/auth');
var categoryRouter = require('../routes/category');
var orderRoute = require('../routes/order');
var productRoute = require('../routes/product');
var userRouter = require('../routes/user');

module.exports = (app) => {
    app.use('/', indexRouter);
    app.use('/auth', authRouter);
    app.use('/category', categoryRouter);
    app.use('/order', orderRoute);
    app.use('/product', productRoute);
    app.use('/user', userRouter);
};