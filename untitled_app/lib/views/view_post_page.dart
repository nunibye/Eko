import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../models/post_handler.dart' show Post;
import '../controllers/view_post_page_controller.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/profile_picture_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../custom_widgets/login_text_feild.dart';
import '../custom_widgets/feed_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPostPage extends StatelessWidget {
  final Post? post;
  const ViewPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostPageController(post: post, context: context),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<PostPageController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: () => context.pop(),
              ),
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              title: Text(
                Provider.of<PostPageController>(context, listen: false).title,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lato',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: FeedBuilder(
                      isComment: true,
                        firestoreQuery: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(Provider.of<PostPageController>(context,
                                    listen: false)
                                .postId)
                            .collection("comments")
                            .orderBy('time', descending: true),
                        header: const _Header())),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomInputFeild(
                        onChanged: (s) => Provider.of<PostPageController>(
                                context,
                                listen: false)
                            .updateCount(s),
                        //height: MediaQuery.sizeOf(context).width * 0.2,
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        focus: Provider.of<PostPageController>(context,
                                listen: false)
                            .commentFeildFocus,
                        label: AppLocalizations.of(context)!.addComment,
                        controller: Provider.of<PostPageController>(context,
                                listen: false)
                            .commentFeild),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Adjust the value for the desired roundness
                          ),
                        ),
                        onPressed: () {
                          Provider.of<PostPageController>(context,
                                  listen: false)
                              .postCommentPressed();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.sizeOf(context).width * 0.12,
                          width: MediaQuery.sizeOf(context).width * 0.23,
                          child: Text(
                            AppLocalizations.of(context)!.post,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 5),
              icon: SizedBox(
                width: MediaQuery.of(context).size.width * 0.115,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        Provider.of<PostPageController>(context, listen: false)
                            .profilePic, //FIXME
                    placeholder: (context, url) => const LoadingProfileImage(),
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
                        Provider.of<PostPageController>(context, listen: false).name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "@${Provider.of<PostPageController>(context, listen: false).username}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    Provider.of<PostPageController>(context, listen: false)
                        .body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
      )
    ]);
  }
}
