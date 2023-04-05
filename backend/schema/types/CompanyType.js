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

const CompanyType = new GraphQLObjectType({
    name: "Company",
    fields: () => ({
        id: { type: GraphQLString },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
        users: {
            type: new GraphQLList(require('./UserType').UserType),
            resolve(parent, args) {
                return UserModel.find({
                    _id: {
                        $in: parent.users
                    }
                });
            }
        },
        roles: {
            type: new GraphQLList(require('./RoleType').RoleType),
            resolve(parent, args) {
                return RoleModel.find({
                    _id: {
                        $in: parent.roles
                    }
                });
            }
        }
    })
})

module.exports.CompanyType = CompanyType