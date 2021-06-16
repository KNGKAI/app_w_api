import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:app/Views/RootView.dart';
import 'package:app/Providers/CartProvider.dart';
import 'package:app/Models/Product.dart';

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
    Cart cart = Provider.of<Cart>(context);
    List<Product> products = cart.getProductsInCart();

    return RootView(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              child: TextButton(
                child: Text("Checkout"),
                onPressed: () => print("Cart checkout "),
              ),
              padding: EdgeInsets.all(12),
            ),
            Padding(
              child: Text('Total: ${cart.getCost()}'),
              padding: EdgeInsets.all(12),
            )
          ],
        ),
        Divider(),
        Expanded(
          child: products.isEmpty
              ? Text("The cart is empty")
              : ListView(
                  children: products.map((p) {
                    return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p.name),
                            Text('R${p.price}.00'),
                          ],
                        ),
                        leading: Image.memory(
                          Base64Decoder().convert(p.image),
                          fit: BoxFit.cover,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                cart.removeFromCart(p);
                              });
                            },
                            icon: Icon(Icons.delete))
                        // Text('R${p.price}.00'),
                        );
                  }).toList(),
                ),
        )
      ],
    ));
  }
}
