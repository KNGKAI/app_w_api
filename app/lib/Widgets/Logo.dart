import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
    this.color = Colors.blue,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 512
        ? 256
        : MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: width,
          image: AssetImage('assets/images/icon.png'),
        ),
        // Text("SKATE",
        //     style: TextStyle(
        //         color: Colors.black,
        //         fontSize: width / 4,
        //         fontWeight: FontWeight.bold)),
      ],
    );
  }
}
