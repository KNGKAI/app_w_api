import 'dart:convert';

import 'package:app/Models/Category.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:app/Widgets/ProductGridTile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  List<String> _selectedCategories;

  @override
  Widget build(BuildContext context) {
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
            image
            price
          }
          categories {
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          if (_selectedCategories == null) {
            _selectedCategories = categories.map((category) => category.name).toList();
          }
          List<Product> products = result.data['products']
              .map<Product>((json) => Product.fromJson(json))
              .where((product) => _selectedCategories.contains(product.category))
              .toList();
          int horizontalCount = 2;
          double width = MediaQuery.of(context).size.width / horizontalCount;
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories
                    .map((category) {
                      bool selected = _selectedCategories.contains(category.name);
                      return MaterialButton(
                        color: selected ? Colors.blue : Colors.grey,
                        onPressed: () {
                          setState(() {
                            if (selected) {
                              _selectedCategories.remove(category.name);
                            } else {
                              _selectedCategories.add(category.name);
                            }
                          });
                        },
                        child: Text(category.name.toUpperCase(), style: TextStyle(color: selected ? Colors.white : Colors.black)),
                      );
                    }).toList(),
              ),
              products.isEmpty
                  ? Center(child: Text("No Products Found!"))
                  : Container(
                width: MediaQuery.of(context).size.width,
                height: (width + 40) * products.length / horizontalCount,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: horizontalCount,
                  children: products
                      .map<Widget>((product) => ProductGridTile(
                            product: product,
                            onTap: () async {
                              var result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text(
                                          "${product.name} - R${product.price.toString()}.00"),
                                      children: <Widget>[
                                        SizedBox(height: 10.0),
                                        Image.memory(
                                          Base64Decoder()
                                              .convert(product.image),
                                          width: width,
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            MaterialButton(
                                              color: Colors.red,
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text("Cancel", style: TextStyle(color: Colors.white))
                                            ),
                                            MaterialButton(
                                                color: Colors.green,
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: Text("Add to cart", style: TextStyle(color: Colors.white))
                                            ),
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
