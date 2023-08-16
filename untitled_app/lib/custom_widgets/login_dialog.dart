import 'package:flutter/material.dart';

Future<void> showMyDialog(String title, String message, List<String> buttons,
    List<Function> actions, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: <Widget>[
          for (int i = 0; i < buttons.length; i++)
            TextButton(
              child: Text(buttons[i]),
              onPressed: () => actions[i],
            ),
        ],
      );
    },
  );
}
