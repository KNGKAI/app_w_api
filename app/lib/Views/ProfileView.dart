import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skate/Base/BaseViewModel.dart';
import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/Widgets/MyAppBar.dart';
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
      return Text("Unauthorized");
    }
    User user = User.fromJson(profileService.user.toJson());
    TextEditingController firstController =
        TextEditingController(text: user.first);
    TextEditingController lastController =
        TextEditingController(text: user.last);
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController phoneController =
        TextEditingController(text: user.phone);
    return BaseViewWidget(
      model: BaseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: myAppBar(context, '/stock'),
        body: model.busy
            ? Center(child: CircularProgressIndicator())
            : ListView(
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
                    controller: firstController,
                    onChanged: (value) => user.first = value,
                    decoration: InputDecoration(labelText: "First Name"),
                  ),
                  TextField(
                    controller: lastController,
                    onChanged: (value) => user.last = value,
                    decoration: InputDecoration(labelText: "Last Name"),
                  ),
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
                    controller: phoneController,
                    onChanged: (value) => user.phone = value,
                    decoration: InputDecoration(labelText: "Phone"),
                  ),
                  TextButton(
                    child: Text("Update"),
                    onPressed: () async {
                      model.setBusy(true);
                      APIResponse response =
                          await profileService.updateUser(user);
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  Text(response.success ? "Success" : "Failed"),
                              content: Text(response.success
                                  ? "User Updated"
                                  : response.message),
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
                      model.setBusy(true);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
