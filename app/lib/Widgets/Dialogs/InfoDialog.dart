import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String message;
  final Function onAccept;
  const InfoDialog(
      {Key key, @required String this.message, Function this.onAccept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(message),
      children: [
        TextButton(
          child: Text("Accept"),
          onPressed: () {
            if (onAccept != null) onAccept();
          },
        )
      ],
    );
  }
}
