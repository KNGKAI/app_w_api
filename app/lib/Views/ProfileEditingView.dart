import 'package:app/Models/Category.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/Views/CartView.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/CategoryTile.dart';

import 'package:app/Widgets/OrderTile.dart';
import 'package:app/Widgets/ProductEditing.dart';
import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProfileEditingView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ProfileEditingView> {
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
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController addressController =
        TextEditingController(text: user.address);
    return ListView(
      //Settings
      padding: EdgeInsets.all(20.0),
      children: [
        Text("Profile:", textScaleFactor: 1.4),
        TextField(
          controller: usernameController,
          onChanged: (value) => user.username = value,
          decoration: InputDecoration(labelText: "Username"),
        ),
        TextField(
          controller: emailController,
          onChanged: (value) => user.email = value,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: addressController,
          onChanged: (value) => user.address = value,
          decoration: InputDecoration(labelText: "Address"),
        ),
      ],
    );
  }
}
