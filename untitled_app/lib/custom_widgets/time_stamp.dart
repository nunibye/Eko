import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeStamp extends StatelessWidget {
  final String time;
  final double fontSize;
  const TimeStamp({super.key, required this.time, this.fontSize = 16});

  String formatTime(String time) {
    DateTime now = DateTime.now();
    DateTime postTime = DateTime.parse(time).toLocal();
    Duration difference = now.difference(postTime);

    if (difference.inDays < 1) {
      return DateFormat('h:mm a').format(postTime);
    } else if (difference.inDays == 1) {
      return '${difference.inDays}d';
    } else if (difference.inDays >= 2 && difference.inDays <= 3) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('M/d').format(postTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(time),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
