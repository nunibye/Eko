import 'package:flutter/material.dart';


showSnackBar({String text = "", int time = 1500, required BuildContext context}) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      content: Text(
        text,
        style: TextStyle(
            fontSize: 18, color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      duration: Duration(milliseconds: time),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height * 0.1,
          left: MediaQuery.sizeOf(context).width * 0.3,
          right: MediaQuery.sizeOf(context).width * 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
