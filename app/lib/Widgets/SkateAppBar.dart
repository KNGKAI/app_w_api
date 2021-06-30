import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

AppBar SkateAppBar(
    {Widget openModal, List<Widget> moreActions, Widget backbtn = null}) {
  return AppBar(
    toolbarHeight: 48,
    title: Text("012SKATE"),
    actions: moreActions,
    leading: backbtn,
  );
}
