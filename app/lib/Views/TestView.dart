import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skate/Widgets/MyAppBar.dart';

class TestView extends StatefulWidget {
  @override
  _TestView createState() => _TestView();
}

class _TestView extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, '/test'),
      // body: WateringWidget()
    );
  }
}
