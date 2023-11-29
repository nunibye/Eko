import 'package:flutter/Material.dart';
import '../models/post_handler.dart' show RecentActivityCard;
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

Widget recentActivityCardBuilder(dynamic data) {
  return ActivityCardWidget(card: data);
}

class ActivityCardWidget extends StatelessWidget {
  final RecentActivityCard card;
  const ActivityCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go("/feed/post/${card.path}"),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.01),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.015),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.14,
                width: MediaQuery.of(context).size.width * 0.14,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface),
                child: Icon(
                  Icons.comment,
                  size: MediaQuery.of(context).size.width * 0.08,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${AppLocalizations.of(context)!.commentText} ${card.content}",
                //overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
