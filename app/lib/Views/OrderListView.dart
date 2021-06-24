import 'package:app/Models/Category.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/Views/CartView.dart';
import 'package:app/Views/ProfileEditingView.dart';
import 'package:app/Views/StockView.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/CategoryTile.dart';
import 'package:app/Widgets/MyAppBar.dart';

import 'package:app/Widgets/OrderWidget.dart';
import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class OrderListView extends StatefulWidget {
  final String user;

  const OrderListView({
    this.user,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    ProductService productService = Provider.of<ProductService>(context);
    return BaseQueryWidget(
      query: """{
          orders(user: "${widget.user}") {
            id
            user {
              id
              username
              email
              address
            }
            product{
              id
              name
              price
            }
            status
            reference
          }
        }""",
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        List<Order> orders = result.data['orders']
            .map<Order>((json) => Order.fromJson(json))
            .toList();

        return OrderWidget.list(orders);
        //   return ListView(
        //     padding: EdgeInsets.all(20.0),
        //     children: [
        //       Text("Orders:"),
        //       orders.isEmpty
        //           ? Center(child: Text("No Orders"))
        //           : Column(
        //         children:

        //         orders.map((order) {
        //           return OrderWidget.tile(order
        //             order: order,
        //             onTap: () async {
        //               await showDialog(
        //                   context: context,
        //                   builder: (context) => AlertDialog(
        //                 title: Text("Order"),
        //                 content: OrderWidget.tile(order),
        //                 actions: profileService.user.role == "admin" ? [
        //                   TextButton(
        //                     child: Text("Ship"),
        //                     onPressed: () async {
        //                       if (order.status == "shipped") return;
        //                       order.status = "shipped";
        //                       if (await productService.updateOrder(order)) {
        //                         Navigator.pop(context);
        //                         refetch();
        //                       }
        //                     },
        //                   ),
        //                   TextButton(
        //                     child: Text("Remove"),
        //                     onPressed: () async {
        //                       if (await productService.removeOrder(order)) {
        //                         Navigator.pop(context);
        //                         refetch();
        //                       }
        //                     },
        //                   ),
        //                   TextButton(
        //                     child: Text("Cancel"),
        //                     onPressed: () => Navigator.pop(context),
        //                   )
        //                 ] : [],
        //               )
        //               );
        //             },
        //           );
        //         }).toList(),
        //       ),
        //     ],
        //   );
      },
    );
  }
}