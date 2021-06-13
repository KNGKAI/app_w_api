
const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt
} = require('graphql');

const { CategoryType } = require('./types/CategoryType')
const { ProductType } = require('./types/ProductType');
const { UserType } = require('./types/UserType')

const { CategoryModel } = require('../models/category');
const { UserModel } = require('../models/user');
const { ProductModel } = require('../models/product');
const { OrderModel } = require('../models/order');
const { OrderType } = require('./types/OrderType');

const RootQuery = new GraphQLObjectType({
    name: "RootQueryType",
    fields: {
        categories: {
            type: new GraphQLList(CategoryType),
            resolve(parent, args) {
                return CategoryModel.find({});
            }
        },
        category: {
            type: CategoryType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return CategoryModel.findOne({ _id: args.id });
            }
        },
        products: {
            type: new GraphQLList(ProductType),
            resolve(parent, args) {
                return ProductModel.find({});
            }
        },
        product: {
            type: ProductType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return ProductModel.findOne({ _id: args.id });
            }
        },
        orders: {
            type: new GraphQLList(OrderType),
            resolve(parent, args) {
                return OrderModel.find({});
            }
        },
        order: {
            type: OrderType,
            args: { id: { type: GraphQLString } },
            resolve(parent, args) {
                return OrderModel.findOne({ _id: args.id });
            }
        },
        users: {
            type: new GraphQLList(UserType),
            resolve(parent, args) {
                return UserModel.find({});
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