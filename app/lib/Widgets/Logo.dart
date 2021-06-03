import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
    this.color = Colors.blue,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: width,
          image: AssetImage('assets/images/logo.png'),
        ),
        Text("SKATE",
          style: TextStyle(
            color: Colors.black,
            fontSize: width / 4,
            fontWeight: FontWeight.bold
          )
        ),
      ],
    );
  }
}