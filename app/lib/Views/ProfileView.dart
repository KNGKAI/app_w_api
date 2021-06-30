import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Views/CartView.dart';
import 'package:skate/Views/OrderListView.dart';
import 'package:skate/Views/ProfileEditingView.dart';
import 'package:skate/Views/StockView.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skate/Widgets/UserCard.dart';

class ProfileView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ProfileView> {
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
    User user = profileService.user;
    bool admin = user.role.compareTo('admin') == 0;
    return Scaffold(
      appBar: myAppBar(context, '/profile'),
      body: DefaultTabController(
          length: admin ? 4 : 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen,
              automaticallyImplyLeading: false,
              title: Text("Dashboard"),
              bottom: TabBar(
                tabs: admin
                    ? [
                  Tab(
                    icon: Icon(Icons.shopping_cart),
                    text: "Cart",
                  ),
                  Tab(
                      icon: Icon(Icons.format_align_left),
                      text: "Stock"),
                  Tab(
                      icon: Icon(Icons.description),
                      text: "Orders"),
                  Tab(icon: Icon(Icons.settings), text: "Profile"),
                ]
                    : [
                  Tab(
                    icon: Icon(Icons.shopping_cart),
                    text: "Cart",
                  ),
                  Tab(
                      icon: Icon(Icons.description),
                      text: "Orders"),
                  Tab(icon: Icon(Icons.settings), text: "Profile"),
                ],
              ),
            ),
            body: TabBarView(
                children: admin
                    ? [
                  CartView(),
                  StockView(),
                  OrderListView(),
                  ProfileEditingView(),
                ]
                    : [
                  CartView(),
                  OrderListView(user: user.id),
                  ProfileEditingView(),
                ]),
          )),
    );
  }
}
