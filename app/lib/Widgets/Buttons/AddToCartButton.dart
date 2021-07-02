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
  String _selectedSize = "Select Size";
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);
    int count = cart.getProductCount(widget.product);
    bool inStock = widget.product.stock.isEmpty;
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
                DropdownButton(
                    onChanged: (v) => setState(() {
                          _selectedSize = v;
                        }),
                    value: _selectedSize,
                    items: [
                      DropdownMenuItem(
                          child: Text("Select Size"), value: "None"),
                      ...widget.product.stock
                          .map((e) => DropdownMenuItem(
                              value: e.size, child: Text(e.size)))
                          .toList()
                    ]),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_shopping_cart),
                  tooltip: "Add to cart",
                )
              ],
            ),
    );
  }
}
