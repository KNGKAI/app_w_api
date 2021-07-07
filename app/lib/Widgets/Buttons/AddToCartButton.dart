import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:skate/Models/Order.dart';
// import 'package:skate/Services/ProductService.dart';
import 'package:skate/Providers/CartProvider.dart';
import 'package:skate/Models/Product.dart';

class AddToCartButton extends StatefulWidget {
  final Product product;
  final Function(OrderProduct) addToCart;
  const AddToCartButton(
      {Key key, @required this.product, Function(OrderProduct) this.addToCart})
      : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  int _selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // ProductService productService = Provider.of<ProductService>(context);
    Cart cart = Provider.of<Cart>(context);
    int c = 0;
    List<ProductStock> availableStock =
        widget.product.stock.where((element) => element.value > 0).toList();
    return Material(
      borderOnForeground: true,
      elevation: 1,
      child: availableStock.isEmpty
          ? Center(
              child: Text("Out of stock"),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Select Size: ",
                      style: theme.textTheme.headline6,
                    ),
                    DropdownButton(
                        onChanged: (v) => setState(() {
                              _selectedSize = v;
                            }),
                        value: _selectedSize,
                        items: availableStock
                            .map((e) => DropdownMenuItem(
                                value: c++, child: Text(e.size)))
                            .toList()),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    if (widget.addToCart != null)
                      widget.addToCart(new OrderProduct(
                          product: widget.product,
                          size: availableStock[_selectedSize].size,
                          value: 1));
                  },
                  icon: Icon(Icons.add_shopping_cart),
                  tooltip: "Add to cart",
                )
              ],
            ),
    );
  }
}
