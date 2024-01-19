import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


  String formatTime(String time) {
    DateTime now = DateTime.now();
    DateTime postTime = DateTime.parse(time).toLocal();
    Duration difference = now.difference(postTime);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        if (difference.inMinutes < 1) {
          return '1m';
        } else {
          return '${difference.inMinutes}m';
        }
      } else {
        return '${difference.inHours}h';
      }
    } else if (difference.inDays > 3) {
      return DateFormat('M/d').format(postTime);
    } else {
      return '${difference.inDays}d';
    }
  }
  
class TimeStamp extends StatelessWidget {
  final String time;
  final double fontSize;
  const TimeStamp({super.key, required this.time, this.fontSize = 15});



  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(time),
      style: TextStyle(
        fontSize: fontSize,
        //fontWeight: FontWeight.w300,
        color: Theme.of(context).colorScheme.onSurfaceVariant
        //color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
