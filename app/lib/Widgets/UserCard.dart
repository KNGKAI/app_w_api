import 'dart:convert';

import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';

class UserCard extends StatefulWidget {
  final User user;

  const UserCard({
    @required this.user,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  // backgroundImage: FileImage(_image),
                  radius: 30,
                  child: Text(widget.user.username.toUpperCase()[0]),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.username, style: TextStyle(fontSize: 24)),
                Text(widget.user.phone, style: TextStyle(fontSize: 20)),
                Text(widget.user.email, style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
