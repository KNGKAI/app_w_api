import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/CartProvider.dart';

import 'package:app/Widgets/Cart/CartList.dart';
import 'package:app/Widgets/Dialogs/ConfirmDialog.dart';

class CartView extends StatefulWidget {
  const CartView({Key key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (cnt) => ConfirmDialog(
                                message: "Clear cart?",
                                onAccept: () {
                                  setState(() {
                                    cart.clearCart();
                                  });
                                },
                              ));
                    },
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Clear cart",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      // To-Do
                    },
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
            Expanded(
              child: cart.getAll().isEmpty
                  ? Center(child: Text("Cart is empty"))
                  : CartList(cart: cart.getAll()),
            )
          ],
        ));
  }
}
