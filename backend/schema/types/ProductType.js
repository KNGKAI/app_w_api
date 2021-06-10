const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLList,
    GraphQLFloat,
    GraphQLScalarType,
    GraphQLInt
} = require('graphql');

const ProductType = new GraphQLObjectType({
    name: "Product",
    fields: () => ({
        id: { type: GraphQLString },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
        category: { type: GraphQLString },
        size: { type: GraphQLString },
        image: { type: GraphQLString },
        price: { type: GraphQLInt },
        inStock: { type: GraphQLInt },
    })
})

module.exports.ProductType = ProductType