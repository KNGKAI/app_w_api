import 'package:flutter/material.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Widgets/Cart/CartEntry.dart';

class CartList extends StatelessWidget {
  final Map<Product, int> cart;
  const CartList({Key key, @required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = 0;
    int numItems = 0;

    List<Widget> list = cart.entries.map((e) {
      total += e.key.price * e.value;
      numItems += e.value;
      return CartEntry(product: e.key, quantity: e.value);
    }).toList();

    return ListView(children: [
      ...list,
      ListTile(title: Divider()),
      ListTile(
          title: Text("Total:"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 100, child: Text(numItems.toString())),
              Container(
                width: 100,
                child: Text('R${total}'),
              )
            ],
          ))
    ]);
  }
}
