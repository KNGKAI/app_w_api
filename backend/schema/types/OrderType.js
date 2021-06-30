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

const OrderStockType = new GraphQLObjectType({
    name: "OrderStock",
    fields: () => ({
        product: {
            type: ProductType,
            resolve(parent, args) {
                return ProductModel.findOne({ _id: parent.product });
            }
        },
        size: { type: GraphQLString },
        value: { type: GraphQLInt },
    })
})

const OrderType = new GraphQLObjectType({
    name: "Order",
    fields: () => ({
        id: { type: GraphQLString },
        user: {
            type: UserType,
            resolve(parent, args) {
                return UserModel.findOne({ _id: parent.user });
            }
        },
        status: { type: GraphQLString },
        reference: { type: GraphQLString },
        products: { type: new GraphQLList(OrderStockType) },
    })
})

module.exports.OrderType = OrderType