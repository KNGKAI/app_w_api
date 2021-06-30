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

import 'package:app/Widgets/Buttons.dart';

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
  final TextStyle headingStyle = TextStyle(
    fontSize: 30.0,
  );

  final TextStyle subheadingStyle = TextStyle(
    fontSize: 24.0,
  );

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

    var Args = ModalRoute.of(context)?.settings.arguments as Map ?? {};

    String id = Args['id'];
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
            stock
          }

        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          _product = Product.fromJson(result.data['product']);
          return Center(
              child: SizedBox(
                  width: 400,
                  child: ListView(
                    padding: EdgeInsets.all(20.0),
                    children: [
                      Image.memory(
                        Base64Decoder().convert(_product.image),
                        width: MediaQuery.of(context).size.width,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_product.name, style: headingStyle),
                          Buttons.addToCartButton(_product)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Size: ",
                            style: subheadingStyle,
                          ),
                          Text(_product.size, style: subheadingStyle),
                        ],
                      ),
                      Text(_product.description),
                      Chip(label: Text(_product.category)),
                      SizedBox(height: 10.0),
                    ],
                  )));
        },
      ),
    );
  }
}
