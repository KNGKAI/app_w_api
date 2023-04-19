const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt
} = require('graphql');

const { CompanyModel } = require('../../models/company');

const TradeType = new GraphQLObjectType({
    name: "Trade",
    fields: () => ({
        id: { type: GraphQLString },
        company: {
            type: require('./CompanyType').CompanyType,
            resolve(parent, args) {
                return CompanyModel.findOne({ _id: parent.company });
            }
        },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
    })
})

module.exports.TradeType = TradeType