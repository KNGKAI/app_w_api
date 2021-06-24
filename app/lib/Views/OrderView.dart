import 'package:flutter/material.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/Models/Order.dart';

import 'package:app/Widgets/Order/OrderList.dart';
import './RootView.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return RootView(
      body: BaseQueryWidget(
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
          }),
    );
  }
}
