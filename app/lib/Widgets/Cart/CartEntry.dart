import 'package:flutter/material.dart';
import 'package:app/Models/Product.dart';

class CartEntry extends StatelessWidget {
  final Product product;
  final int quantity;
  const CartEntry({Key key, @required this.product, @required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(product.name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 100,
                child: Padding(
                  child: Text('${quantity} x R${product.price}'),
                  padding: EdgeInsets.all(4),
                )),
            Container(
              width: 100,
              child: Padding(
                child: Text('R${quantity * product.price}'),
                padding: EdgeInsets.all(4),
              ),
            )
          ],
        ));
  }
}
