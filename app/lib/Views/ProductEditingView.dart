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

import 'package:app/Widgets/ProductWidget.dart';
import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProductEditingView extends StatefulWidget {
  final String product;

  const ProductEditingView({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductEditingView> {
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
      appBar: AppBar(title: Text("Editing")),
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
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          return ProductWidget.editor(
              product: _product,
              categories: categories.map((e) => e.name).toList());
        },
      ),
      persistentFooterButtons: [
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
    );
  }
}
