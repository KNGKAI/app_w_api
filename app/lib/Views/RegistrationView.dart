import 'package:flutter/material.dart';

import 'package:skate/Base/BaseViewModel.dart';
import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/Widgets/Logo.dart';
import 'package:provider/provider.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationView> {
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    return BaseViewWidget(
        model: BaseViewModel(),
        builder: (context, model, child) => Scaffold(
              body: model.busy
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        Text("Register:"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'First Name',
                                icon: Icon(Icons.location_pin)),
                            controller: firstController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                icon: Icon(Icons.location_pin)),
                            controller: lastController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Username',
                                icon: Icon(Icons.account_circle)),
                            controller: usernameController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Email', icon: Icon(Icons.email)),
                            controller: emailController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Phone',
                                icon: Icon(Icons.location_pin)),
                            controller: phoneController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Password',
                                icon: Icon(Icons.vpn_key)),
                            controller: passwordController,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                icon: Icon(Icons.vpn_key)),
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
                                model.setBusy(true);
                                if (firstController.text.isEmpty ||
                                    lastController.text.isEmpty ||
                                    usernameController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    phoneController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    confirmPasswordController.text.isEmpty) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Error"),
                                            content: Text("Empty field/s"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              )
                                            ],
                                          ));
                                  print('text empty error');
                                } else {
                                  if (passwordController.text.compareTo(
                                          confirmPasswordController.text) ==
                                      0) {
                                    User user = User(
                                        first: firstController.text,
                                        last: lastController.text,
                                        username: usernameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text);
                                    APIResponse response =
                                        await profileService.registerUser(
                                            user, passwordController.text);
                                    if (response.success) {
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text("Success"),
                                                content:
                                                    Text("User Registered"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  )
                                                ],
                                              ));
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text("Error"),
                                                content: Text(response.message),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  )
                                                ],
                                              ));
                                    }
                                  } else {
                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Error"),
                                              content:
                                                  Text("Passwords don't match"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                )
                                              ],
                                            ));
                                  }
                                }
                                model.setBusy(false);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ));
  }
}
