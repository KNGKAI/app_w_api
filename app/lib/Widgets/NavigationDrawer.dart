import 'package:flutter/material.dart';
import 'package:skate/Services/ProfileService.dart';
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

    final header = UserAccountsDrawerHeader(
      accountName: Text(service.user.username),
      accountEmail: Text(service.user.email),
      currentAccountPicture: CircleAvatar(child: FlutterLogo(size: 42)),
    );

    List<Widget> navigationItems = [];

    if (service.authorized)
      navigationItems.add(GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: header,
      ));
    else
      navigationItems
          .add(ListItem("Login", "/login", context, currentRoute, Icons.login));
    navigationItems.add(
        ListItem("Store", "/home", context, currentRoute, Icons.store_rounded));
    navigationItems.add(ListItem(
        "Orders", "/orders", context, currentRoute, Icons.local_shipping));
    navigationItems.add(ListItem(
        "Settings", "/settings", context, currentRoute, Icons.settings));

    return Drawer(child: ListView(children: navigationItems));
  }
}
