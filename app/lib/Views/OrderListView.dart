import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Views/CartView.dart';
import 'package:skate/Views/ProfileEditingView.dart';
import 'package:skate/Views/StockView.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/OrderWidget.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
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
      ${widget.user == null ? 'orders() {' : 'orders(user: "${widget.user}") {'}
            id
            user {
              id
              username
              email
              address
            }
            products{
              product {
                name
                price
              }
              size
              value
            }
            status
            reference
            total
          }
        }""",
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        List<Order> orders = result.data['orders']
            .map<Order>((json) => Order.fromJson(json))
            .toList();
        return ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Text("Orders:"),
            orders.isEmpty
                ? Center(child: Text("No Orders"))
                : Column(
                    children: orders.map((order) {
                      return OrderTile(
                        order: order,
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Order"),
                                    content: OrderWidget(order: order),
                                    actions: profileService.user.role == "admin"
                                        ? [
                                            TextButton(
                                              child: Text("Ship"),
                                              onPressed: () async {
                                                if (order.status == "shipped")
                                                  return;
                                                order.status = "shipped";
                                                if (await productService
                                                    .updateOrder(order)) {
                                                  Navigator.pop(context);
                                                  refetch();
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Remove"),
                                              onPressed: () async {
                                                if (await productService
                                                    .removeOrder(order)) {
                                                  Navigator.pop(context);
                                                  refetch();
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            )
                                          ]
                                        : [
                                            TextButton(
                                              child: Text("Okay"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            )
                                          ],
                                  ));
                        },
                      );
                    }).toList(),
                  ),
          ],
        );
      },
    );
  }
}
