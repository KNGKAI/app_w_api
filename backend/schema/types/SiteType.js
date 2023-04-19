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
const { TaskModel } = require('../../models/task');

const SiteType = new GraphQLObjectType({
    name: "Site",
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
        address: { type: GraphQLString },
        tasks: {
            type: new GraphQLList(require('./TaskType').TaskType),
            resolve(parent, args) {
                return TaskModel.find({ site: parent.id });
            }
        },
    })
})

module.exports.SiteType = SiteType