import 'dart:convert';

import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './OrderDialog.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(order.user.username),
      subtitle: Text(order.user.address + "\n" + order.reference),
      trailing: Text(order.status),
      onTap: () => showDialog(
          context: context, builder: (c) => OrderDialog(order: order)),
    );
  }
}
