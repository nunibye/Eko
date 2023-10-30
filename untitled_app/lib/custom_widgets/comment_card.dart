import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'controllers/comment_card_controller.dart';
import '../utilities/constants.dart' as c;
import '../models/post_handler.dart' show Post;
import 'package:provider/provider.dart';
import 'profile_picture_loading.dart';

class CommentCard extends StatelessWidget {
  final Post post;
  final String rootPostId;
  const CommentCard({super.key, required this.post, required this.rootPostId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CommentCardController(post: post, context: context, rootPostId: rootPostId),
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
                        width: MediaQuery.of(context).size.width * 0.115,
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
                              Text(
                                post.author.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "@${post.author.username}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          if (post.body != null)
                            Text(
                              post.body!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
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
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: c.postIconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${Provider.of<CommentCardController>(context, listen: true).likes}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Divider(
                  color: Color.fromARGB(255, 112, 112, 112),
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
