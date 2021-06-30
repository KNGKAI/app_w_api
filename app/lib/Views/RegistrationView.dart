import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/Widgets/Logo.dart';
import 'package:provider/provider.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    return Scaffold(
      body: ListView(
        children: [
          Logo(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'username', icon: Icon(Icons.account_circle)),
              controller: usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration:
                  InputDecoration(labelText: 'email', icon: Icon(Icons.email)),
              controller: emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'password', icon: Icon(Icons.vpn_key)),
              controller: passwordController,
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'confirm password', icon: Icon(Icons.vpn_key)),
              controller: confirmPasswordController,
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.blue,
              child: MaterialButton(
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (usernameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    print('text empty error');
                    return;
                  }
                  if (passwordController.text
                          .compareTo(confirmPasswordController.text) ==
                      0) {
                    User user = User(
                        username: usernameController.text,
                        email: emailController.text,
                        address: "");
                    if (await profileService.registerUser(
                        user, passwordController.text)) {
                      print("user registered");
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  } else {
                    print("password don't match");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
