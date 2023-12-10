import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/time_stamp.dart';
import 'controllers/post_card_controller.dart';
import '../utilities/constants.dart' as c;
import '../models/post_handler.dart' show Post;
import 'package:provider/provider.dart';
import 'profile_picture_loading.dart';

Widget postCardBuilder(dynamic post) {
  return PostCard(
    post: post,
  );
}

Widget profilePostCardBuilder(dynamic post) {
  return PostCard(
    post: post,
    isOnProfile: true,
  );
}

class PostCard extends StatelessWidget {
  final Post post;
  final bool isPreview;
  final bool isPostPage;
  final bool isBuiltFromId;
  final bool isOnProfile;

  const PostCard(
      {super.key,
      required this.post,
      this.isPreview = false,
      this.isPostPage = false,
      this.isBuiltFromId = false,
      this.isOnProfile = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PostCardController(
          post: post, context: context, isBuiltFromId: isBuiltFromId),
      builder: (context, child) {
        return Consumer<PostCardController>(
            builder: (context, notifier, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
              onTap: () => (!isPreview && !isPostPage)
                  ? Provider.of<PostCardController>(context, listen: false)
                      .postPressed()
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Divider(
                      color: Theme.of(context).colorScheme.outline,
                      height: c.dividerWidth,
                    ),
                  ),
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
                          onPressed: () => (!isPreview && !isOnProfile)
                              ? Provider.of<PostCardController>(context,
                                      listen: false)
                                  .avatarPressed()
                              : null,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        (!isPreview && !isOnProfile)
                                            ? Provider.of<PostCardController>(
                                                    context,
                                                    listen: false)
                                                .avatarPressed()
                                            : null,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                  if (!isPreview) TimeStamp(time: post.time)
                                ],
                              ),
                              const SizedBox(height: 8.0),

                              if (post.title != null)
                                RichText(
                                  text: TextSpan(
                                    children: post.title!.map((chunk) {
                                      if (chunk.startsWith('@')) {
                                        // This is a username, create a hyperlink
                                        return TextSpan(
                                          text: chunk,
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              if (!isPreview) {
                                                Provider.of<PostCardController>(
                                                  context,
                                                  listen: false,
                                                ).tagPressed(
                                                    chunk.substring(1));
                                              }
                                            },
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

                              if (post.gifURL != null)
                                InkWell(
                                  onDoubleTap: () {
                                    if (!isPreview) {
                                      if (!Provider.of<PostCardController>(
                                              context,
                                              listen: false)
                                          .liked) {
                                        Provider.of<PostCardController>(context,
                                                listen: false)
                                            .likePressed();
                                      }
                                    }
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            post.gifURL!,
                                            fit: BoxFit.fill,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return
                                                  // ClipRRect(
                                                  //   borderRadius: BorderRadius.circular(10),
                                                  //   child: Shimmer.fromColors(
                                                  //     baseColor: const Color.fromARGB(
                                                  //         100, 130, 131, 130),
                                                  //     highlightColor: Colors.white,
                                                  //     child: Container(
                                                  //       width: 200,
                                                  //       height: 150,
                                                  //       color: Colors.amber,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  Container(
                                                alignment: Alignment.center,
                                                width: 200,
                                                height: 150,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Opacity(
                                          opacity: notifier.opacity,
                                          child: Icon(
                                            Icons.favorite,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            size: 80.0,
                                          ),
                                        ),
                                      ]),
                                ),
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
                                            ..onTap = () {
                                              if (!isPreview) {
                                                Provider.of<PostCardController>(
                                                  context,
                                                  listen: false,
                                                ).tagPressed(
                                                    chunk.substring(1));
                                              }
                                            },
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
                              // Visibility(
                              //   visible: !isPostPage && !isPreview,
                              //   child: TextButton(
                              //     onPressed: () {
                              //       if (!isPreview && !isPostPage) {
                              //         Provider.of<PostCardController>(context,
                              //                 listen: false)
                              //             .postPressed();
                              //       }
                              //     },
                              //     style: TextButton.styleFrom(
                              //       padding: EdgeInsets.zero,
                              //       minimumSize: const Size(0, 0),
                              //       tapTargetSize:
                              //           MaterialTapTargetSize.shrinkWrap,
                              //     ),
                              //     child: Text(
                              //       "View post", //FIXME
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.normal,
                              //         color:
                              //             Theme.of(context).colorScheme.outline,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: c.postPaddingHoriz,
                      //vertical: c.postPaddingVert-8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (!isPreview && !isPostPage) {
                              Provider.of<PostCardController>(context,
                                      listen: false)
                                  .commentPressed();
                            }
                          },
                          icon: Row(
                            children: [
                              Icon(
                                Icons.comment,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: c.postIconSize,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${Provider.of<PostCardController>(context, listen: true).comments}',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => isPreview
                              ? null
                              : Provider.of<PostCardController>(context,
                                      listen: false)
                                  .likePressed(),
                          icon: Row(
                            children: [
                              Icon(
                                (Provider.of<PostCardController>(context,
                                            listen: true)
                                        .liked)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: c.postIconSize,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${Provider.of<PostCardController>(context, listen: true).likes}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => isPreview ? null : {},
                          icon: Row(
                            children: [
                              IconButton(
                                onPressed: () => isPreview
                                    ? null
                                    : Provider.of<PostCardController>(context,
                                            listen: false)
                                        .sharePressed(),
                                icon: Icon(
                                  Icons.share,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  size: c.postIconSize,
                                ),
                              ),

                              const SizedBox(width: 5),
                              // Text(
                              //   '0',
                              //   style: TextStyle(
                              //       color:
                              //           Theme.of(context).colorScheme.onBackground),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
