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
const { SiteModel } = require('../../models/site');
const { UserModel } = require('../../models/user');
const { TradeModel } = require('../../models/trade');

const TaskType = new GraphQLObjectType({
    name: "Task",
    fields: () => ({
        id: { type: GraphQLString },
        company: {
            type: require('./CompanyType').CompanyType,
            resolve(parent, args) {
                return CompanyModel.findOne({ _id: parent.company });
            },
        },
        site: {
            type: require('./SiteType').SiteType,
            resolve(parent, args) {
                return SiteModel.findOne({ _id: parent.site });
            },
        },
        label: { type: GraphQLString },
        description: { type: GraphQLString },
        status: {
            type: GraphQLInt,
            resolve(parent, args) {
                if (parent.status === null) {
                    return 0;
                }
                return parent.status;
            },
        },
        priority: { type: GraphQLInt },
        trade: {
            type: require('./TradeType').TradeType,
            resolve(parent, args) {
                if (!parent.trade) {
                    return null;
                }
                return TradeModel.findOne({ _id: parent.trade });
            },
        },
        assigned: {
            type: require('./UserType').UserType,
            resolve(parent, args) {
                if (!parent.assigned) {
                    return null;
                }
                return UserModel.findOne({ _id: parent.assigned });
            },
        },
        site: {
            type: require('./SiteType').SiteType,
            resolve(parent, args) {
                if (!parent.site) {
                    return null;
                }
                return SiteModel.findOne({ _id: parent.site });
            },
        },
        start: {
            type: GraphQLInt,
            resolve(parent, args) {
                return parent.start.getTime();
            }
        },
        end: {
            type: GraphQLInt,
            resolve(parent, args) {
                return parent.end.getTime();
            }
        },
    })
})

module.exports.TaskType = TaskType