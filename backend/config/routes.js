var indexRouter = require('../routes/index');
var authRouter = require('../routes/auth');
var userRouter = require('../routes/user');

module.exports = (app) => {
    app.use('/', indexRouter);
    app.use('/auth',authRouter);
    app.use('/user',userRouter);
    // !-- Do not remove this line --! //
};