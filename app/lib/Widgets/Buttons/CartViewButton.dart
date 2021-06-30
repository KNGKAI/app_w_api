import 'package:flutter/material.dart';

import 'package:app/Providers/CartProvider.dart';
import 'package:provider/provider.dart';

class CartViewButton extends StatelessWidget {
  const CartViewButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);
    return Material(
        clipBehavior: Clip.none,
        child: Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () => print("View shopping cart"),
            ),
            cart.getAll().length > 0
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: Text(cart.getAll().length.toString()),
                      )),
                      color: theme.hintColor,
                    ))
                : Container()
          ],
        ));
  }
}
