
const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
} = require('graphql');

const { CompanyyModel } = require('../models/company');

const { CompanyType } = require('./types/CompanyType');
const { UserType } = require('./types/UserType');
const { UserModel } = require('../models/user');

const RootQuery = new GraphQLObjectType({
    name: "RootQueryType",
    fields: {
        company: {
            type: CompanyType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return CompanyyModel.findOne({ _id: args.id });
            }
        },
        user: {
            type: UserType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return UserModel.findOne({ _id: args.id });
            }
        },
    }
})

module.exports = new GraphQLSchema({
    query: RootQuery
})