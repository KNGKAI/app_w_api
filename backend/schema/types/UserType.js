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

const { RoleModel } = require('../../models/role');
const { CompanyyModel } = require('../../models/company');


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
                console.log(parent)
                return CompanyyModel.findOne({
                    users: {
                        $in: [parent.id]
                    }
                });
            }
        }
    })
})

module.exports.UserType = UserType