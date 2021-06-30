import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:provider/provider.dart';

myAppBar(BuildContext context, String currentRoute) {
  ProfileService service = Provider.of<ProfileService>(context);
  return AppBar(
    toolbarHeight: 48,
    title: Center(child: Text("012")),
    automaticallyImplyLeading: true,
    actions: [
      currentRoute == "/login" || currentRoute == "/profile"
          ? Container()
          : service.authorized
          ? IconButton(
          icon: Icon(Icons.person),
          onPressed: () => Navigator.pushNamed(context, '/profile'))
          : IconButton(
          icon: Icon(Icons.login),
          onPressed: () => Navigator.pushNamed(context, '/login'))
    ],
  );
}
