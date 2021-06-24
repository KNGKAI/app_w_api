import 'package:flutter/material.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:provider/provider.dart';

ListTile ListItem(title, route, context, current, icon) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    tileColor: current == route ? Theme.of(context).primaryColor : Colors.white,
    enabled: current != route,
    onTap: () {
      Navigator.pushNamed(context, route);
    },
  );
}

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    ProfileService service = Provider.of<ProfileService>(context);

    var route = ModalRoute.of(context);
    var currentRoute = route != null ? route.settings.name : '/';

    return Drawer(
        child: ListView(
      children: [
        ListItem("Store", "/home", context, currentRoute, Icons.store_rounded),
        ListItem(
            "Orders", "/orders", context, currentRoute, Icons.local_shipping),
        service.authorized
            ? (ListItem(
                "Profile", "/profile", context, currentRoute, Icons.portrait))
            : ListItem("Login", "/login", context, currentRoute, Icons.logout)
      ],
    ));
  }
}
