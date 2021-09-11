import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Views/CartView.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/AppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
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
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: ProductEditing(
                product: _product,
                categories: categories.map((e) => e.name).toList()),
          );
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
          child: Text("Remove"),
          onPressed: () async {
            if (await productService.removeProduct(_product)) {
              Navigator.pop(context);
            } else {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Failed Remove"),
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
