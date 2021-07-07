import 'package:flutter/material.dart';

import 'package:skate/Providers/CartProvider.dart';
import 'package:provider/provider.dart';

class CartViewButton extends StatelessWidget {
  const CartViewButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);
    return Material(
        clipBehavior: Clip.none,
        child: IconButton(
          color: theme.accentColor,
          icon: Icon(
            Icons.shopping_cart_outlined,
          ),
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ));
  }
}
