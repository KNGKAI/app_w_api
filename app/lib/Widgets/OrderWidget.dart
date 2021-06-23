import 'dart:convert';

import 'package:app/Models/Order.dart';
import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({
    @required this.order,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Order: ${widget.order.reference}"),
        Text("User: ${widget.order.user.username}"),
        Text("Email: ${widget.order.user.email}"),
        Text("Address: ${widget.order.user.address}"),
        Divider(),
        Text("Products:"),
        ListView(),
      ],
    );
  }
}
