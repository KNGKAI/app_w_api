const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt,
    GraphQLBoolean
} = require('graphql');

const UserType = new GraphQLObjectType({
    name: "User",
    fields: () => ({
        id: { type: GraphQLString },
        first: { type: GraphQLString },
        last: { type: GraphQLString },
        username: { type: GraphQLString },
        email: { type: GraphQLString },
        phone: { type: GraphQLString },
        role: { type: GraphQLString },
        confirmed: { type: GraphQLBoolean },
        chat: { type: new GraphQLList(GraphQLString) },
    })
})

module.exports.UserType = UserType