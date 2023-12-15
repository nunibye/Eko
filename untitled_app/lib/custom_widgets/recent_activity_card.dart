import 'package:flutter/Material.dart';
import 'package:untitled_app/custom_widgets/time_stamp.dart';
import '../models/post_handler.dart' show RecentActivityCard;
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_picture_loading.dart';

Widget recentActivityCardBuilder(dynamic data) {
  return ActivityCardWidget(card: data);
}

class ActivityCardWidget extends StatelessWidget {
  final RecentActivityCard card;
  const ActivityCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final bool hasUser = card.sourceUser != null;
    return InkWell(
      onTap: () => context.push("/feed/post/${card.path}"),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.01),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.015),
              child: hasUser
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.115,
                      child: ClipOval(
                          child: CachedNetworkImage(
                        imageUrl: card.sourceUser!.profilePicture,
                        placeholder: (context, url) =>
                            const LoadingProfileImage(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                    )
                  : Container(
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
            Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "${hasUser ? "@${card.sourceUser!.username}" : AppLocalizations.of(context)!.someone} ${AppLocalizations.of(context)!.commentText} ${card.content}",
                  "${AppLocalizations.of(context)!.commentActivity} ${card.content}",
                  softWrap: true,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.centerLeft,
                child: TimeStamp(
                  time: card.time,
                  fontSize: 12,
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
