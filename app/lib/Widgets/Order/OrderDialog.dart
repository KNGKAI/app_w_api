import 'package:flutter/material.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Widgets/Cart/CartList.dart';

class OrderDialog extends StatelessWidget {
  final Order order;
  const OrderDialog({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Order: ${order.reference}'),
          IconButton(
              onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
        ],
      ),
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Recipient "),
                  Expanded(child: Divider()),
                  Text(order.user.username)
                ],
              ),
              Row(
                children: [
                  Text("Address "),
                  Expanded(child: Divider()),
                  Text(order.user.address)
                ],
              ),
              Row(
                children: [
                  Text("Refrence "),
                  Expanded(child: Divider()),
                  Text(order.reference)
                ],
              ),
              Row(
                children: [
                  Text("Status "),
                  Expanded(child: Divider()),
                  Text(order.status)
                ],
              )
            ],
          ),
        ),
        Divider(),
        SizedBox(
          width: 400,
          height: 400,
          child: CartList(cart: order.products),
        )
      ],
    );
  }
}
