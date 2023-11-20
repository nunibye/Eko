import 'package:flutter/widgets.dart';
import '../models/post_handler.dart' show RecentActivityCard;

class ActivityCardWidget extends StatelessWidget {
  final RecentActivityCard card;
  const ActivityCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(card.type),Text(card.content), Text(card.time)]);
  }
}
