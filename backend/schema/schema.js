const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
} = require('graphql');

const { UserModel } = require('../models/user');
const { CompanyModel } = require('../models/company');
const { TradeModel } = require('../models/trade');
const { RoleModel } = require('../models/role');
const { SiteModel } = require('../models/site');
const { TaskModel } = require('../models/task');

const RootQuery = new GraphQLObjectType({
    name: "RootQueryType",
    fields: {
        user: {
            type: require('./types/UserType').UserType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return UserModel.findOne({ _id: args.id });
            }
        },
        company: {
            type: require('./types/CompanyType').CompanyType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return CompanyModel.findOne({ _id: args.id });
            }
        },
        role: {
            type: require('./types/RoleType').RoleType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return RoleModel.findOne({ _id: args.id });
            }
        },
        trade: {
            type: require('./types/TradeType').TradeType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return TradeModel.findOne({ _id: args.id });
            }
        },
        site: {
            type: require('./types/SiteType').SiteType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return SiteModel.findOne({ _id: args.id });
            }
        },
        task: {
            type: require('./types/TaskType').TaskType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return TaskModel.findOne({ _id: args.id });
            }
        },
    }
})

module.exports = new GraphQLSchema({
    query: RootQuery
})