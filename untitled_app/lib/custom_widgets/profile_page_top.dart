import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePageTopNumberDisplay extends StatelessWidget {
  final int number;
  final String label;
  const ProfilePageTopNumberDisplay(
      {required this.number, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width * 0.3,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: NumberFormat.compact().format(number),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          children: [
            TextSpan(
              text: "\n$label",
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
