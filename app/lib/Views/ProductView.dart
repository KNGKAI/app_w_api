import 'dart:convert';

import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Views/CartView.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductOrder.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  final String id;

  const ProductView({
    this.id,
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
    String id = widget.id ?? AppViewModel.id;
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
            stock {
              size
              value
            }
          }
          categories {
            id
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          _product = Product.fromJson(result.data['product']);
          bool inStock = _product.stock.any((stock) => stock.value > 0);
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
              Text(_product.stock.map((stock) => stock.size).toList().toString()),
              Text(_product.description),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                      color: inStock ? Colors.green : Colors.grey,
                      onPressed: () async {
                        if (inStock) {
                          OrderProduct order = OrderProduct(
                            product: _product,
                            size: _product.stock.firstWhere((stock) => stock.value > 0).size,
                            value: 1,
                          );
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Add to cart"),
                                content: ProductOrder(order: order),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text("Add"),
                                    onPressed: () async {
                                      if (await productService.addToCart(null)) {
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
                                    },
                                  )
                                ],
                              )
                          );
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
    );
  }
}
