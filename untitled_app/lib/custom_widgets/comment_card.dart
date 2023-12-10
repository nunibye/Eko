import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/time_stamp.dart';
import 'controllers/comment_card_controller.dart';
import '../utilities/constants.dart' as c;
import '../models/post_handler.dart' show Post;
import 'package:provider/provider.dart';
import 'profile_picture_loading.dart';

Widget commentCardBuilder(dynamic post) {
  return CommentCard(post: post);
}

class CommentCard extends StatelessWidget {
  final Post post;

  const CommentCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider.value(
      value: CommentCardController(post: post, context: context),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: c.postPaddingHoriz,
                  vertical: c.postPaddingVert,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the profile picture as a CircleAvatar
                    IconButton(
                      onPressed: () => Provider.of<CommentCardController>(
                              context,
                              listen: false)
                          .avatarPressed(),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      icon: SizedBox(
                        width: width * 0.115,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: post.author.profilePicture,
                            placeholder: (context, url) =>
                                const LoadingProfileImage(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Provider.of<CommentCardController>(context,
                                            listen: false)
                                        .avatarPressed(),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  post.author.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              TextButton(
                                onPressed: () =>
                                    Provider.of<CommentCardController>(context,
                                            listen: false)
                                        .avatarPressed(),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "@${post.author.username}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          if (post.body != null)
                            RichText(
                              text: TextSpan(
                                children: post.body!.map((chunk) {
                                  if (chunk.startsWith('@')) {
                                    // This is a username, create a hyperlink
                                    return TextSpan(
                                      text: chunk,
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            Provider.of<CommentCardController>(
                                                    context,
                                                    listen: false)
                                                .tagPressed(chunk.substring(1)),
                                    );
                                  } else {
                                    // This is a normal text, create a TextSpan
                                    return TextSpan(
                                      text: chunk,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    );
                                  }
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),

                    Column(children: [
                      TimeStamp(time: post.time),
                      IconButton(
                        onPressed: () => Provider.of<CommentCardController>(
                                context,
                                listen: false)
                            .likePressed(),
                        icon: Row(
                          children: [
                            Icon(
                              (Provider.of<CommentCardController>(context,
                                          listen: true)
                                      .liked)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: c.postIconSize,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${Provider.of<CommentCardController>(context, listen: true).likes}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                          ],
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Divider(
                  color: Theme.of(context).colorScheme.outline,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
