import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Views/CartView.dart';
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
      return Text("Unauthorized");
    }
    User user = User.fromJson(profileService.user.toJson());
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
        UserCard(user: user),
        TextButton(
          child: Text("Sign Out",
              style: TextStyle(fontSize: 20, color: Colors.red)),
          onPressed: () {
            profileService.signOutUser();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
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
        TextButton(
          child: Text("Update"),
          onPressed: () async {
            bool updated = await profileService.updateUser(user);
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Updated Profile"),
                    content: Text(updated ? "Success" : "Failed"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    ],
                  );
                });
          },
        ),
      ],
    );
  }
}
