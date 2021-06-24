import 'package:flutter/material.dart';

class InstanceAppBar extends StatelessWidget {
  final String title;
  const InstanceAppBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back),
      ),
    );
  }
}
