import 'dart:convert';

import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  final Function onTap;

  const OrderTile({
    @required this.order,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.order.user.username),
      subtitle: Text(widget.order.reference + '\n' + widget.order.address),
      trailing: Text(widget.order.status),
      onTap: widget.onTap,
    );
  }
}
