import 'package:app/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {

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
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    return Scaffold(
      appBar: myAppBar(context, '/profile'),
      body: ListView(children: [
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
      ]),
    );
  }
}
