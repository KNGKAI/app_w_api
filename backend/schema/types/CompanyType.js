const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt
} = require('graphql');

const { RoleModel } = require('../../models/role');
const { UserModel } = require('../../models/user');
const { SiteModel } = require('../../models/site');
const { TradeModel } = require('../../models/trade');

const CompanyType = new GraphQLObjectType({
    name: "Company",
    fields: () => ({
        id: { type: GraphQLString },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
        users: {
            type: new GraphQLList(require('./UserType').UserType),
            resolve(parent, args) {
                return UserModel.find({ company: parent.id });
            }
        },
        roles: {
            type: new GraphQLList(require('./RoleType').RoleType),
            resolve(parent, args) {
                return RoleModel.find({ company: parent.id });
            }
        },
        sites: {
            type: new GraphQLList(require('./SiteType').SiteType),
            resolve(parent, args) {
                return SiteModel.find({ company: parent.id });
            }
        },
        trades: {
            type: new GraphQLList(require('./TradeType').TradeType),
            resolve(parent, args) {
                return TradeModel.find({ company: parent.id });
            }
        },
    })
})

module.exports.CompanyType = CompanyType