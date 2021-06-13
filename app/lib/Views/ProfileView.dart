import 'package:app/Models/Category.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/Views/CartView.dart';
import 'package:app/Views/OrderView.dart';
import 'package:app/Views/ProfileEditingView.dart';
import 'package:app/Views/StockView.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/CategoryTile.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:app/Widgets/OrderTile.dart';
import 'package:app/Widgets/ProductEditing.dart';
import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

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
    bool admin = user.role == 'admin';
    return Scaffold(
      appBar: myAppBar(context, '/profile'),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CircleAvatar(
              // backgroundImage: FileImage(_image),
              radius: 30,
              child: Text(user.username.toUpperCase()[0]),
            ),
          ),
        ),
        Center(child: Text(user.username, style: TextStyle(fontSize: 20))),
        Center(child: Text(user.email, style: TextStyle(fontSize: 20))),
        TextButton(
          child: Text("Sign Out"),
          onPressed: () {
            profileService.signOutUser();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
        Expanded(
            child: DefaultTabController(
                length: admin ? 4 : 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.lightBlue,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.shopping_cart), text: "Cart",),
                        Tab(icon: Icon(Icons.format_align_left), text: "Stock"),
                        Tab(icon: Icon(Icons.description), text: "Orders"),
                        Tab(icon: Icon(Icons.settings), text: "Profile"),
                      ],
                    ),
                  ),
                  body: TabBarView(
                      children: admin ? [
                        CartView(),
                        StockView(),
                        OrderView(),
                        ProfileEditingView(),
                      ] : [
                        CartView(),
                        ProfileEditingView(),
                      ]
                  ),
                )
            )
        )
      ]),
    );
  }
}
