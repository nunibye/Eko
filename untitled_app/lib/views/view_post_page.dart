import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/custom_widgets/post_card.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/custom_widgets/comment_card.dart';
import '../models/post_handler.dart' show Post;
import '../controllers/view_post_page_controller.dart';
import '../custom_widgets/login_text_feild.dart';
import '../custom_widgets/pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPostPage extends StatelessWidget {
  final Post? post;
  final String id;
  const ViewPostPage({super.key, required this.post, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          PostPageController(passedPost: post, context: context, id: id),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<PostPageController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            body: Provider.of<PostPageController>(context, listen: true).post ==
                    null
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_rounded,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            onPressed: () => Provider.of<PostPageController>(
                                    context,
                                    listen: false)
                                .onExitPressed(),
                          ),
                        ],
                      ),
                      Expanded(
                          child: PaginationPage(
                              getter: Provider.of<PostPageController>(context,
                                      listen: false)
                                  .getCommentsFromPost,
                              card: commentCardBuilder,
                              header: _Header(),
                              startAfterQuery: Provider.of<PostPageController>(
                                      context,
                                      listen: false)
                                  .getTimeFromPost)
                          // FeedBuilder(
                          //   rootPostId: Provider.of<PostPageController>(context,
                          //           listen: false)
                          //       .post!
                          //       .postId,
                          //   isComment: true,
                          //   firestoreQuery: FirebaseFirestore.instance
                          //       .collection('posts')
                          //       .doc(Provider.of<PostPageController>(context,
                          //               listen: false)
                          //           .post!
                          //           .postId)
                          //       .collection("comments")
                          //       .orderBy('time', descending: true),
                          //   header: const _Header(),
                          // ),
                          ),
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
                              controller: Provider.of<PostPageController>(
                                      context,
                                      listen: false)
                                  .commentFeild),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ),
                          )
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
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostCard(
          post: Provider.of<PostPageController>(context, listen: false).post!,
          isPostPage: true,
        ),
        Divider(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
        ),
      ],
    );
  }
}
