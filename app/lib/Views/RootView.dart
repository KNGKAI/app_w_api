import 'dart:async';

import 'package:skate/Widgets/Logo.dart';
import 'package:flutter/material.dart';
import 'package:skate/Widgets/NavigationDrawer.dart';

import 'package:skate/Widgets/AppBar.dart';

class RootView extends StatelessWidget {
  final Widget body;
  final Function(BuildContext) modal;
  final Icon modalIcon;
  const RootView(
      {Key key,
      Widget this.body,
      Function(BuildContext) this.modal,
      Icon this.modalIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkateAppBar(),
      body: body,
      drawer: NavigationDrawer(),
    );
  }
}
