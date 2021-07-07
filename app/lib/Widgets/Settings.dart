import 'package:skate/Views/RootView.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
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
