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

const RoleType = new GraphQLObjectType({
    name: "Role",
    fields: () => ({
        id: { type: GraphQLString },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
        features: { type: GraphQLInt },
        company: {
            type: require('./CompanyType').CompanyType,
            resolve(parent, args) {
                return CompanyModel.findOne({ _id: parent.company });
            }
        }
    })
})

module.exports.RoleType = RoleType