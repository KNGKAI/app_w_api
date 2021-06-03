import 'package:app/Widgets/Logo.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Widgets/Logo.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  gridTile(String label, IconData icon, Function onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50.0, color: Colors.white),
                Text(label,
                    style: TextStyle(fontSize: 25.0, color: Colors.white)),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '/home'),
      body: ListView(
        children: [
          Divider(),
          Logo(),
          Divider(),
        ],
      ),
    );
  }
}
