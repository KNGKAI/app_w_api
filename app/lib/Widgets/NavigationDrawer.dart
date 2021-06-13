import 'package:flutter/material.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:provider/provider.dart';

ListTile ListItem(title, route, context, icon) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pushNamed(context, route);
    },
  );
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    ProfileService service = Provider.of<ProfileService>(context);

    return Drawer(
        child: ListView(
      children: [
        ListItem("Home", "/home", context, Icons.house),
        ListItem("Settings", "/settings", context, Icons.settings),
        service.authorized
            ? ListItem("Profile", "/profile", context, Icons.portrait)
            : ListItem("Login", "/login", context, Icons.logout)
      ],
    ));
  }
}
