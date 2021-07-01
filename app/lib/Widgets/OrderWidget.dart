
import 'dart:convert';

import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
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
        Text("Status: ${widget.order.status}"),
        Divider(),
        Text("User: ${widget.order.user.username}"),
        Text("Email: ${widget.order.user.email}"),
        Text("Address: ${widget.order.user.address}"),
        Divider(),
        Text("Products:"),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.order.products
              .map((order) => Text(" - ${order.product.name} - ${order.size} : R${order.product.price.toString()} X ${order.value.toString()}"))
              .toList(),
        ),
        Divider(),
        Text("Total: R${widget.order.total}"),
      ],
    );
  }
}
