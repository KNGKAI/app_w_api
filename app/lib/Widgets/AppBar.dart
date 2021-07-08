import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:provider/provider.dart';
import 'package:skate/Widgets/Buttons/CartViewButton.dart';

SkateAppBar() {
  return AppBar(
      toolbarHeight: 48,
      title: Center(child: Text("012")),
      automaticallyImplyLeading: true,
      actions: [CartViewButton()]);
}
