import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final Function onAccept, onReject;
  const ConfirmDialog(
      {Key key,
      @required String this.message,
      @required Function this.onAccept,
      Function this.onReject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(message),
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextButton(
                  onPressed: () {
                    onAccept();
                    Navigator.pop(context);
                  },
                  child: Text("Ok")),
            ),
            Padding(
                padding: EdgeInsets.all(8),
                child: TextButton(
                    onPressed: () {
                      if (onReject != null) onReject();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")))
          ],
        )
      ],
    );
  }
}
