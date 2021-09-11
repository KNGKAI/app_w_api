import 'package:skate/Base/BaseViewModel.dart';
import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Base/BaseQueryWidget.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/OrderWidget.dart';
import 'package:flutter/material.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class OrderView extends StatefulWidget {
  const OrderView({
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderView> {
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
    String user =
        profileService.user.role == 'admin' ? null : profileService.user.id;
    return BaseViewWidget(
      model: BaseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: myAppBar(context, '/order'),
        body: model.busy
            ? Center(child: CircularProgressIndicator())
            : BaseQueryWidget(
                query: """{
                  ${user == null ? 'orders() {' : 'orders(user: "$user") {'}
                    id
                    status
                    reference
                    address
                    total
                    user {
                      id
                      username
                      email
                      phone
                    }
                    products{
                      product {
                        id
                        name
                        price
                        category {
                          id
                          name
                        }
                      }
                      size
                      value
                    }
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
                          : Container(),
                      ...orders.map((order) {
                        return OrderTile(
                          order: order,
                          onTap: () async {
                            // AppViewModel.setId(order.id);
                            // Navigator.of(context).pushNamed('/order');
                            await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Order"),
                                      content: OrderWidget(order: order),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                          },
                        );
                      }).toList()
                    ],
                  );
                },
              ),
      ),
    );
  }
}
