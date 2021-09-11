const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt
} = require('graphql');

const { CategoryModel } = require('../../models/category');

const { CategoryType } = require('./CategoryType');

const ProductStockType = new GraphQLObjectType({
    name: "ProductStock",
    fields: () => ({
        size: { type: GraphQLString },
        value: { type: GraphQLInt },
    })
})

const ProductType = new GraphQLObjectType({
    name: "Product",
    fields: () => ({
        id: { type: GraphQLString },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
        category: {
            type: CategoryType,
            resolve(parent, args) {
                return CategoryModel.findOne({ _id: parent.category });
            }
        },
        size: { type: GraphQLString },
        image: { type: GraphQLString },
        price: { type: GraphQLInt },
        stock: { type: new GraphQLList(ProductStockType) },
    })
})

module.exports.ProductType = ProductType