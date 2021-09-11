var { graphqlHTTP } = require('express-graphql');

var schema = require('../schema/schema')

module.exports = (app) => {
    app.use('/gql', graphqlHTTP({
        schema,
        graphiql: true
    }))
};