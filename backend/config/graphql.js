var { graphqlHTTP } = require('express-graphql');

var schema = require('../schema/schema')

module.exports = (app) => {
    app.use('/graphql', graphqlHTTP({
        schema,
        graphiql: true
    }))
};