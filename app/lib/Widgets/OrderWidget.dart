// import 'dart:convert';

// import 'package:app/Models/Order.dart';
// import 'package:app/Models/Product.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class OrderWidget extends StatefulWidget {
//   final Order order;

//   const OrderWidget({
//     @required this.order,
//     Key key,
//   }) : super(key: key);

//   @override
//   _State createState() => _State();
// }

// class _State extends State<OrderWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("Order: ${widget.order.reference}"),
//         Text("User: ${widget.order.user.username}"),
//         Text("Email: ${widget.order.user.email}"),
//         Text("Address: ${widget.order.user.address}"),
//         Divider(),
//         Text("Products:"),
//         ListView(),
//       ],
//     );
//   }
// }

import './Order/OrderTile.dart';
import './Order/OrderList.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class OrderWidget {
  static OrderTile tile(Order e) => OrderTile(order: e);
  static OrderList list(List<Order> e) => OrderList(orders: e);
  static Widget view() {
    return BaseQueryWidget(
        query: """
    {
      orders {
        id
            product {
              id
              price
              name
              category
              description
              size
              inStock  
            }
            user {
              id
              username
              address
              role
            }
            reference
            status
      }
    }
    """,
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          List<Order> orders = result.data['orders']
              .map<Order>((json) => Order.fromJson(json))
              .toList();

          return OrderList(orders: orders);
        });
  }
}
