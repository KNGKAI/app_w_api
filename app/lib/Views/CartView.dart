import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    ProductService productService = Provider.of<ProductService>(context);
    return BaseQueryWidget(
      query: """{
          products {
            id
            price
            name
            category
            description
            size
          }
        }""",
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        List<Product> products = result.data['products']
            .map<Product>((json) => Product.fromJson(json))
            .toList();
        print(productService.getCart().toString());
        List<Product> cart = productService
            .getCart()
            .map<Product>((id) => products.firstWhere(
                (product) => product.id == id,
                orElse: () => Product(
                    id: id, name: id, price: 0, category: "-")))
            .toList();
        int totalCost = 0;
        cart.forEach((element) => totalCost += element.price);
        return cart.isEmpty
            ? Center(child: Text("Nothing in your cart"))
            : ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  Column(
                    children: cart
                        .map((product) => ListTile(
                              title: Text(product.name +
                                  " - R" +
                                  product.price.toString()),
                              // subtitle: Text(product.size),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Remove from cart?"),
                                            actions: [
                                              TextButton(
                                                child: Text("Yes",
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                                onPressed: () async {
                                                  if (await productService
                                                      .removeFromCart(
                                                          product)) {
                                                    setState(() {
                                                      profileService.user
                                                          .budget -= totalCost;
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                                onPressed: () =>
                                                    Navigator.pop(context),
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
                      if (await productService
                          .placeOrder(profileService.user)) {
                        setState(() {});
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Order Place"),
                                  actions: [
                                    TextButton(
                                      child: Text("Okay",
                                          style: TextStyle(color: Colors.blue)),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ));
                      }
                    },
                  )
                ],
              );
      },
    );
  }
}
