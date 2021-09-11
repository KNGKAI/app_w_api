import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:provider/provider.dart';

myAppBar(BuildContext context, String currentRoute) {
  ProfileService service = Provider.of<ProfileService>(context);
  bool loggedIn = service.authorized;
  bool admin = false;
  if (loggedIn) {
    admin = service.user.role == 'admin';
  }
  return AppBar(
    title: TextButton(
        // style: ButtonStyle(col),
        child: Text("012SKATE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.pushReplacementNamed(context, '/')),
    actions: loggedIn
        ? [
            IconButton(
                icon: Icon(Icons.chat),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/chat')),
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/cart')),
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/order')),
            admin
                ? IconButton(
                    icon: Icon(Icons.bar_chart),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/stock'))
                : Container(),
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/profile')),
          ]
        : [
            IconButton(
                icon: Icon(Icons.login),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'))
          ],
  );
}
