import 'dart:convert';

import 'package:app/Models/Category.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:app/Widgets/ProductGridTile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  String _selectedCategories;

  @override
  Widget build(BuildContext context) {
    ProductService productService = Provider.of<ProductService>(context);
    return Scaffold(
      appBar: myAppBar(context, '/home'),
      body: BaseQueryWidget(
        query: """{
          products {
            id
            name
            description
            category
            size
            inStock
            image
            price
          }
          categories {
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          List<String> cart = productService.getCart();
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          List<Product> products = result.data['products']
              .map<Product>((json) => Product.fromJson(json))
              .map<Product>((Product product) {
                product.inStock -= cart.where((id) => product.id.compareTo(id) == 0).length;
                return product;
              })
              .toList();
          if (_selectedCategories != null) {
            products = products.where(
                    (product) => product.category.compareTo(_selectedCategories) == 0)
                .toList();
          }
          int horizontalCount = 2;
          double width = MediaQuery.of(context).size.width / horizontalCount;
          return ListView(
            children: [
              categories.isEmpty
                  ? Center(child: Text("No Categories Found!"))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: categories.map((category) {
                        bool selected = _selectedCategories == category.name;
                        return MaterialButton(
                          color: selected ? Colors.blue : Colors.grey,
                          onPressed: () {
                            setState(() {
                              if (selected) {
                                _selectedCategories = null;
                              } else {
                                _selectedCategories = category.name;
                              }
                            });
                          },
                          child: Text(category.name.toUpperCase(),
                              style: TextStyle(
                                  color:
                                      selected ? Colors.white : Colors.black)),
                        );
                      }).toList(),
                    ),
              products.isEmpty
                  ? Center(child: Text("No Products Found!"))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: (width + 40) * (products.length / horizontalCount).ceil(),
                      child: GridView.count(
                        primary: false,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: horizontalCount,
                        children: products
                            .map<Widget>((product) => ProductGridTile(
                                  product: product,
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          bool inStock = product.inStock > 0;
                                          return SimpleDialog(
                                            title: Text(
                                                "${product.name} - R${product.price.toString()}"),
                                            children: <Widget>[
                                              SizedBox(height: 10.0),
                                              Image.memory(
                                                Base64Decoder()
                                                    .convert(product.image),
                                                width: width,
                                                scale: 0.1,
                                              ),
                                              SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  MaterialButton(
                                                      color: Colors.red,
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text("Cancel",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))),
                                                  MaterialButton(
                                                      color: inStock ? Colors.green : Colors.grey,
                                                      onPressed: () async {
                                                        if (inStock) {
                                                          if (await productService
                                                              .addToCart(
                                                              product)) {
                                                            Navigator.of(context)
                                                                .pop();
                                                          }
                                                        }
                                                        setState(() {

                                                        });
                                                      },
                                                      child: Text(inStock ? "Add to cart" : "Out of Stock",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))),
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                  },
                                ))
                            .toList(),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }
}
