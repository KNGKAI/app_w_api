import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import './RootView.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/Models/Order.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      child: Column(
        children: [],
      ),
    );
  }
}

class OrderView extends StatefulWidget {
  const OrderView({Key key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    ProfileService ps = Provider.of(context);

    return BaseQueryWidget(
        query: """
                  {
                    orders(user : "${ps.user.id}"){
                      user{
                        id,
                        address
                      },
                      status,
                      reference,
                      products {
                        product {
                          name
                          price
                        },
                        size,
                        value
                      }
                    }
                  }
                  """,
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          List<Order> orders = result.data['orders']
              .map<Order>((json) => Order.fromJson(json))
              .toList();

          List<Order> activeOrders =
              orders.where((element) => element.status != 'deliverd').toList();
          List<Order> orderHistory =
              orders.where((element) => element.status == 'deliverd').toList();

          return RootView(
            body: DefaultTabController(
                length: 2,
                child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: 50,
                      bottom: TabBar(
                        tabs: [
                          Tab(
                            text: "In Progress",
                          ),
                          Tab(
                            text: "History",
                          )
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        ListView(
                            children: activeOrders
                                .map((e) => ListTile(
                                      title: Text(e.status),
                                    ))
                                .toList()),
                        ListView(
                            children: orderHistory
                                .map((e) => ListTile(
                                      title: Text(e.status),
                                    ))
                                .toList())
                      ],
                    ))),
          );
        });
  }
}
