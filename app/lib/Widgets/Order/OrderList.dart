import 'package:flutter/material.dart';
import 'package:app/Models/Order.dart';
import './OrderTile.dart';

class OrderList extends StatelessWidget {
  final List<Order> orders;
  const OrderList({Key key, @required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? Center(
            child: Text("No Orders yet"),
          )
        : ListView(
            children: orders
                .map((e) => OrderTile(
                      order: e,
                    ))
                .toList(),
          );
  }
}
