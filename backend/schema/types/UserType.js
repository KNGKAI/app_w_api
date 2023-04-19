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

const { CompanyModel } = require('../../models/company');
const { RoleModel } = require('../../models/role');
const { TradeModel } = require('../../models/trade');
const { TaskModel } = require('../../models/task');

const UserType = new GraphQLObjectType({
    name: "User",
    fields: () => ({
        id: { type: GraphQLString },
        created: { type: GraphQLString },
        updated: { type: GraphQLString },
        username: { type: GraphQLString },
        email: { type: GraphQLString },
        role: {
            type: require('./RoleType').RoleType,
            resolve(parent, args) {
                return RoleModel.findOne({ _id: parent.role });
            }
        },
        company: {
            type: require('./CompanyType').CompanyType,
            resolve(parent, args) {
                return CompanyModel.findOne({ _id: parent.company });
            }
        },
        trades: {
            type: require('./TradeType').TradeType,
            resolve(parent, args) {
                if (!parent.trades) {
                    return [];
                }
                return TradeModel.findOne({ _id: parent.trades });
            }
        },
        tasks: {
            type: new GraphQLList(require('./TaskType').TaskType),
            resolve(parent, args) {
                return TaskModel.find({ assigned: parent.id });
            }
        },
    })
})

module.exports.UserType = UserType