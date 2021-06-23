import 'package:flutter/material.dart';
import 'package:app/Models/Order.dart';
import './OrderTile.dart';

class OrderList extends StatelessWidget {
  final List<Order> orders;
  const OrderList({Key key, @required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num width = MediaQuery.of(context).size.width;
    return ListView(
      children: orders
          .map((e) => SizedBox(
              width: width,
              child: OrderTile(
                order: e,
              )))
          .toList(),
    );
  }
}
