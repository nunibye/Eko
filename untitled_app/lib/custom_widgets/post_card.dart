import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/custom_widgets/time_stamp.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'controllers/post_card_controller.dart';
import '../utilities/constants.dart' as c;
import '../models/post_handler.dart' show Post;
import 'package:provider/provider.dart';
import 'profile_picture_loading.dart';
import '../custom_widgets/profile_avatar.dart';
import 'dart:io' show Platform;
import 'package:like_button/like_button.dart';
import 'package:flutter/foundation.dart';

Widget postCardBuilder(dynamic post) {
  return PostCard(
    post: post,
  );
}

Widget otherProfilePostCardBuilder(dynamic post) {
  return PostCard(
    post: post,
    isOnProfile: true,
  );
}

Widget profilePostCardBuilder(dynamic post) {
  return PostCard(
    post: post,
    isOnProfile: true,
    showGroup: true,
  );
}

class PostCard extends StatelessWidget {
  final Post post;
  final bool isPreview;
  final bool isPostPage;
  final bool isBuiltFromId;
  final bool isOnProfile;
  final bool showGroup;

  const PostCard(
      {super.key,
      required this.post,
      this.isPreview = false,
      this.isPostPage = false,
      this.isBuiltFromId = false,
      this.isOnProfile = false,
      this.showGroup = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PostCardController(
          post: post, context: context, isBuiltFromId: isBuiltFromId),
      builder: (context, child) {
        return Consumer<PostCardController>(
          builder: (context, notifier, child) {
            // print(post.body);
            final width = c.widthGetter(context);
            final likeCommentTextStyle = TextStyle(
                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                color: Theme.of(context).colorScheme.onSurfaceVariant);
            return Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 0, right: 0),
              child: InkWell(
                onTap: () => (!isPreview &&
                        !isPostPage &&
                        Provider.of<PostCardController>(context, listen: false)
                            .isLoggedIn())
                    ? Provider.of<PostCardController>(context, listen: false)
                        .postPressed()
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showGroup && post.group != null)
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.115 + 20),
                        child: InkWell(
                          onTap: () => Provider.of<PostCardController>(context,
                                  listen: false)
                              .groupBannerPressed(),
                          child: Container(
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.group,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  post.group!.name,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: c.postPaddingHoriz,
                        //vertical: c.postPaddingVert,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the profile picture as a CircleAvatar
                          IconButton(
                            onPressed: () {
                              if (Provider.of<PostCardController>(context,
                                      listen: false)
                                  .isLoggedIn()) {
                                (!isPreview && !isOnProfile)
                                    ? Provider.of<PostCardController>(context,
                                            listen: false)
                                        .avatarPressed()
                                    : null;
                              }
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            icon: ProfileAvatar(
                              size: width * 0.115,
                              url: post.author.profilePicture,
                            ),
                          ),

                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          if (Provider.of<PostCardController>(
                                                  context,
                                                  listen: false)
                                              .isLoggedIn()) {
                                            (!isPreview && !isOnProfile)
                                                ? Provider.of<
                                                            PostCardController>(
                                                        context,
                                                        listen: false)
                                                    .avatarPressed()
                                                : null;
                                          }
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "@${post.author.username}", //post.author.name,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                            ),

                                            //const SizedBox(width: 8.0),
                                            // Text(
                                            //     "@${post.author.username}",
                                            //     style: TextStyle(
                                            //       fontSize: 12,
                                            //       fontWeight: FontWeight.w300,
                                            //       color: Theme.of(context)
                                            //           .colorScheme
                                            //           .onBackground,
                                            //     ),
                                            //   ),
                                          ],
                                        )),
                                    const Spacer(),
                                     if (!isPreview) TimeStamp(time: post.time),
                                    // if (!isPreview)
                                    //   InkWell(
                                    //       onTap: () {},
                                    //       child: Icon(Icons.more_vert))
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                if (post.title?.isNotEmpty ?? false)
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                        fontFamily: DefaultTextStyle.of(context)
                                            .style
                                            .fontFamily,
                                      ),
                                      children: post.title!.map((chunk) {
                                        if (chunk.startsWith('@')) {
                                          // This is a username, create a hyperlink
                                          return TextSpan(
                                            text: chunk,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                if (!isPreview) {
                                                  Provider.of<
                                                      PostCardController>(
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          );
                                        }
                                      }).toList(),
                                    ),
                                  ),
                                const SizedBox(height: 6.0),
                                if (post.gifURL != null)
                                  InkWell(
                                    onDoubleTap: () {
                                      if (!isPreview) {
                                        if (!Provider.of<PostCardController>(
                                                context,
                                                listen: false)
                                            .liked) {
                                          Provider.of<PostCardController>(
                                                  context,
                                                  listen: false)
                                              .likePressed();
                                        }
                                      }
                                    },
                                    child: Stack(
                                      fit: StackFit.loose,
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            post.gifURL!,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Text(AppLocalizations.of(
                                                            context)!
                                                        .gifLoadingError),
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
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
                                      ],
                                    ),
                                  ),
                                if (post.gifURL != null)
                                  const SizedBox(height: 6.0),
                                if (post.body?.isNotEmpty ??
                                    false) //&& post.body != []
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: DefaultTextStyle.of(context)
                                            .style
                                            .fontFamily,
                                      ),
                                      children: post.body!.map((chunk) {
                                        if (chunk.startsWith('@')) {
                                          // This is a username, create a hyperlink
                                          return TextSpan(
                                            text: chunk,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceTint),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                if (!isPreview) {
                                                  Provider.of<
                                                      PostCardController>(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: width * 0.115 + 8),
                          LikeButton(
                            isLiked: Provider.of<PostCardController>(context,
                                    listen: true)
                                .liked,
                            likeBuilder: (isLiked) {
                              return Icon(
                                size: c.postIconSize,
                                isLiked
                                    ? CupertinoIcons.heart_solid
                                    : CupertinoIcons.heart,
                                color: isLiked
                                    ? const Color(0xFFff3040)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                              );
                            },
                            onTap: (isLiked) async {
                              if (Provider.of<PostCardController>(context,
                                      listen: false)
                                  .isLoggedIn()) {
                                if (!isPreview &&
                                    !Provider.of<PostCardController>(context,
                                            listen: false)
                                        .isSelf) {
                                  Provider.of<PostCardController>(context,
                                          listen: false)
                                      .likePressed();
                                  return !isLiked;
                                }
                                return isLiked;
                              }
                              return false;
                            },
                            likeCount: null,
                            likeCountAnimationType: LikeCountAnimationType.none,
                            circleSize: 0,
                            animationDuration:
                                const Duration(milliseconds: 600),
                            bubblesSize: 25,
                            bubblesColor: const BubblesColor(
                                dotPrimaryColor:
                                    Color.fromARGB(255, 52, 105, 165),
                                dotSecondaryColor:
                                    Color.fromARGB(255, 65, 43, 161),
                                dotThirdColor:
                                    Color.fromARGB(255, 196, 68, 211),
                                dotLastColor: Color(0xFFff3040)),
                          ),
                          InkWell(
                            onTap: () {
                              if (Provider.of<PostCardController>(context,
                                      listen: false)
                                  .isLoggedIn()) {
                                if (!isPreview && !isPostPage) {
                                  Provider.of<PostCardController>(context,
                                          listen: false)
                                      .commentPressed();
                                }
                              }
                            },
                            child: Icon(
                              CupertinoIcons.chat_bubble,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: c.postIconSize,
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            //iconSize: c.postIconSize,
                            onTap: () {
                              if (Provider.of<PostCardController>(context,
                                      listen: false)
                                  .isLoggedIn()) {
                                isPreview
                                    ? null
                                    : Provider.of<PostCardController>(context,
                                            listen: false)
                                        .sharePressed();
                              }
                            },
                            child: Icon(
                              kIsWeb
                                  ? CupertinoIcons.arrowshape_turn_up_right
                                  : Platform.isIOS
                                      ? CupertinoIcons.share
                                      : CupertinoIcons.arrowshape_turn_up_right,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: c.postPaddingHoriz + width * 0.115 + 14,
                          bottom: 9),
                      child: RichText(
                        text: TextSpan(
                          style: likeCommentTextStyle,
                          children: [
                            //TextSpan(text:"${formatTime(post.time)} • "),
                            //,
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (Provider.of<PostCardController>(context,
                                            listen: false)
                                        .isLoggedIn()) {
                                      context.push(
                                          "/feed/post/${post.postId}/likes",
                                          extra: post.postId);
                                    }
                                  },
                                text:
                                    "${Provider.of<PostCardController>(context, listen: true).likes} ${Provider.of<PostCardController>(context, listen: true).likes == 1 ? AppLocalizations.of(context)!.like : AppLocalizations.of(context)!.likes} • "),
                            TextSpan(
                                text:
                                    "${Provider.of<PostCardController>(context, listen: true).comments} ${Provider.of<PostCardController>(context, listen: true).comments == 1 ? AppLocalizations.of(context)!.comment : AppLocalizations.of(context)!.comments}")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width,child:Divider(
                        color: Theme.of(context).colorScheme.outline,
                        height: c.dividerWidth,

                      ),)
                    
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
