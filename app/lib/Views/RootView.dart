import 'dart:async';

import 'package:app/Widgets/Logo.dart';
import 'package:app/Widgets/SkateAppBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Widgets/NavigationDrawer.dart';

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
        appBar: SkateAppBar(modal != null
            ? IconButton(
                onPressed: () {
                  showModalBottomSheet(context: context, builder: modal);
                },
                icon: modalIcon)
            : Container()),
        body: body,
        drawer: NavigationDrawer());
  }
}
