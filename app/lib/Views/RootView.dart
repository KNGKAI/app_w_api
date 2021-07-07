import 'dart:async';

import 'package:skate/Widgets/Logo.dart';
import 'package:skate/Widgets/SkateAppBar.dart';
import 'package:flutter/material.dart';
import 'package:skate/Widgets/NavigationDrawer.dart';

import 'package:skate/Widgets/Buttons.dart';

class RootView extends StatelessWidget {
  final Widget body;
  final Function(BuildContext) modal;
  final Icon modalIcon;
  final bool enableDrawer;
  const RootView(
      {Key key,
      Widget this.body,
      Function(BuildContext) this.modal,
      Icon this.modalIcon,
      bool this.enableDrawer = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkateAppBar(
          moreActions: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: Icon(Icons.shopping_cart_outlined))
          ],
          backbtn: !enableDrawer
              ? IconButton(
                  onPressed: () => {Navigator.pop(context)},
                  icon: Icon(Icons.arrow_back))
              : null),
      body: body,
      drawer: enableDrawer ? NavigationDrawer() : null,
    );
  }
}
