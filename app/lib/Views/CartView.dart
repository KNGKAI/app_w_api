import 'dart:convert';

import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Base/BaseQueryWidget.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductImage.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skate/Providers/CartProvider.dart';
import 'package:skate/Services/ProfileService.dart';

import 'package:skate/Widgets/Dialogs/ConfirmDialog.dart';
import 'package:skate/Widgets/Dialogs/InfoDialog.dart';

class CartView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CartView> {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    ProductService productService = Provider.of<ProductService>(context);
    return Scaffold(
        appBar: myAppBar(context, '/cart'),
        body: BaseViewWidget(
          model: AppViewModel(),
          builder: (context, model, child) => model.busy
              ? Center(child: CircularProgressIndicator())
              : BaseQueryWidget(
                  query: """{
                    products {
                      id
                      price
                      name
                      category {
                        id
                        name
                      }
                      description
                      size
                      image
                    }
                  }""",
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    List<Product> products = result.data['products']
                        .map<Product>((json) => Product.fromJson(json))
                        .toList();
                    products.forEach((element) {
                      print(element.toJson());
                    });
                    List<OrderProduct> cart =
                        ProductService.getCart().map<OrderProduct>((order) {
                      print("order:");
                      print(order);
                      Map<String, dynamic> decoded = json.decode(order);
                      decoded['product'] = products
                          .firstWhere(
                              (product) => product.id == decoded['product'])
                          .toJson();
                      decoded['product']['category'] = null;
                      print(decoded.toString());
                      return OrderProduct.fromJson(decoded);
                    }).toList();
                    int totalCost = 0;
                    cart.forEach((order) =>
                        totalCost += order.product.price * order.value);
                    return cart.isEmpty
                        ? Center(child: Text("Nothing in your cart"))
                        : ListView(
                            padding: EdgeInsets.all(20.0),
                            children: [
                              Column(
                                children: cart
                                    .map((product) => ListTile(
                                          leading: ProductImage(
                                              product: product.product),
                                          title: Text(
                                              "${product.product.name} - ${product.size} - R${product.product.price.toString()} X ${product.value.toString()}"),
                                          // subtitle: Text(product.size),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                            "Remove from cart?"),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("Yes",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                            onPressed:
                                                                () async {
                                                              if (await productService
                                                                  .removeFromCart(
                                                                      product)) {
                                                                setState(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                          )
                                                        ],
                                                      ));
                                            },
                                          ),
                                        ))
                                    .toList(),
                              ),
                              TextButton(
                                child: Text("Place Order: R$totalCost",
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () async {
                                  model.setBusy(true);
                                  APIResponse response =
                                      await productService.placeOrder(Order(
                                          user: profileService.user,
                                          products: cart));
                                  if (response.success) {
                                    setState(() {});
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Order Placed"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Okay",
                                                      style: TextStyle(
                                                          color: Colors.blue)),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            ));
                                    model.setBusy(false);
                                  } else {
                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Error"),
                                              content: Text(response.message),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                )
                                              ],
                                            ));
                                  }
                                },
                              )
                            ],
                          );
                  },
                ),
        ));
  }
}
