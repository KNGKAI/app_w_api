import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:provider/provider.dart';

myAppBar(BuildContext context, String currentRoute) {
  ProfileService service = Provider.of<ProfileService>(context);
  return AppBar(
    toolbarHeight: 48,
    title: Text("012"),
    leading: Column(
      children: [
        Navigator.canPop(context)
            ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context))
            : Container(),
      ],
    ),
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
