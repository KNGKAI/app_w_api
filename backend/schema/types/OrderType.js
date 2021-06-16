const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt
} = require('graphql');

const { ProductModel } = require('../../models/product');
const { UserModel } = require('../../models/user');

const { ProductType } = require('./ProductType');
const { UserType } = require('./UserType')

const OrderType = new GraphQLObjectType({
    name: "Order",
    fields: () => ({
        id: { type: GraphQLString },
        user: {
            type: UserType,
            async resolve(parent, args) {
                return UserModel.findOne({ _id: parent.user });
            }
        },
        product: {
            type: new GraphQLList(ProductType),
            async resolve(parent, args) {
                return ProductModel.find({ _id: { $in: parent.products } });
            }
        },
        status: { type: GraphQLString },
        reference: { type: GraphQLString },
    })
})

module.exports.OrderType = OrderType