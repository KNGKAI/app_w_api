import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

AppBar SkateAppBar(Widget openModal) {
  return AppBar(
    toolbarHeight: 48,
    title: Text("012SKATE"),
    actions: [openModal],
  );
}
