import 'dart:convert';

import 'package:app/Models/Category.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/ViewModels/AppViewModel.dart';
import 'package:app/Views/CartView.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/CategoryTile.dart';
import 'package:app/Widgets/MyAppBar.dart';

import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  final String product;

  const ProductView({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductView> {
  Product _product;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return Text("Unauthorized");
    }
    ProductService productService = Provider.of<ProductService>(context);
    String id = widget.product ?? AppViewModel.id;
    return Scaffold(
      appBar: myAppBar(context, '/product'),
      body: BaseQueryWidget(
        query: """{
          product(id: "$id") {
            id
            price
            name
            category
            description
            image
            size
            inStock
          }
          categories {
            id
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          _product = Product.fromJson(result.data['product']);
          bool inStock = _product.inStock > 0;
          return ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              Image.memory(
                Base64Decoder().convert(_product.image),
                width: MediaQuery.of(context).size.width,
                scale: 0.1,
              ),
              SizedBox(height: 10.0),
              Text(_product.name,
                  style: TextStyle(
                    fontSize: 30.0,
                  )),
              Text(_product.size,
                  style: TextStyle(
                    fontSize: 24.0,
                  )),
              Text(_product.description),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                      color: inStock ? Colors.green : Colors.grey,
                      onPressed: () async {
                        if (inStock) {
                          if (await productService.addToCart(_product)) {
                            await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Added to cart"),
                                      actions: [
                                        TextButton(
                                            child: Text("Okay"),
                                            onPressed: () =>
                                                Navigator.of(context).pop())
                                      ],
                                    ));
                            Navigator.of(context).pop();
                          }
                        }
                        setState(() {
                          // ???????
                        });
                      },
                      child: Text(inStock ? "Add to cart" : "Out of Stock",
                          style: TextStyle(color: Colors.white))),
                ],
              )
            ],
          );
        },
      ),
      bottomSheet: Row(
        children: [
          TextButton(
            child: Text("Update"),
            onPressed: () async {
              if (await productService.updateProduct(_product)) {
                Navigator.pop(context);
              } else {
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Failed Update"),
                          actions: [
                            TextButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
              }
            },
          ),
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
