import 'package:flutter/material.dart';

import 'package:app/Providers/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:app/Models/Product.dart';

class AddToCartButton extends StatefulWidget {
  final Product product;
  const AddToCartButton({Key key, @required this.product}) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);
    int count = cart.getProductCount(widget.product);
    bool inStock = widget.product.inStock == 0;
    return Material(
      borderOnForeground: true,
      elevation: 2,
      child: inStock
          ? Container(
              color: Colors.grey,
              child: Text(
                "Out of stock",
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.all(10))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  child: IconButton(
                      onPressed: () =>
                          setState(() => cart.addProductToCart(widget.product)),
                      icon: Icon(Icons.add_shopping_cart_outlined)),
                ),
                count > 0
                    ? Container(
                        padding: EdgeInsets.all(8),
                        child: Text(count.toString()),
                      )
                    : Container(
                        padding: EdgeInsets.all(8),
                        child: Text("Add to cart"),
                      ),
                count > 0
                    ? Material(
                        child: IconButton(
                            onPressed: () => setState(
                                () => cart.removeFromCart(widget.product)),
                            icon: Icon(Icons.remove_shopping_cart_outlined)))
                    : Container()
              ],
            ),
    );
  }
}
