import 'dart:async';

import 'package:app/Widgets/Logo.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Widgets/NavigationDrawer.dart';

ListTile ListItem(title, route, current, context) {
  return ListTile(
    title: Text(title),
    tileColor: current == route ? Colors.grey[400] : Colors.white,
    onTap: () {
      Navigator.pushNamed(context, route);
    },
  );
}

class RootView extends StatelessWidget {
  final Widget body;
  final String currentRoute;
  const RootView({Key key, Widget this.body, String this.currentRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(context, currentRoute),
        body: body,
        drawer: NavigationDrawer());
  }
}
