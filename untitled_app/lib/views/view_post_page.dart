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
    double height = MediaQuery.of(context).size.height;

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
                      SizedBox(
                        height: height * 0.08,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.95,
                              child: TextField(
                                textCapitalization: TextCapitalization.sentences,
                                cursorColor:
                                    Theme.of(context).colorScheme.onBackground,
                                focusNode: Provider.of<PostPageController>(
                                        context,
                                        listen: false)
                                    .commentFeildFocus,
                                onChanged: (s) =>
                                    Provider.of<PostPageController>(context,
                                            listen: false)
                                        .updateCount(s),
                                maxLines: null,
                                controller: Provider.of<PostPageController>(
                                        context,
                                        listen: false)
                                    .commentFeild,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(height * 0.01),
                                  hintText:
                                      AppLocalizations.of(context)!.addComment,
                                  fillColor:
                                      Theme.of(context).colorScheme.surface,
                                  filled: true,
                                  focusColor:
                                      Theme.of(context).colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      Provider.of<PostPageController>(context,
                                              listen: false)
                                          .postCommentPressed();
                                    },
                                    icon: const Icon(Icons.send),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
          isPostPage: true,
          post: Provider.of<PostPageController>(context, listen: false).post!,
          isBuiltFromId: Provider.of<PostPageController>(context, listen: false).builtFromID,
        ),
        Divider(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
        ),
      ],
    );
  }
}
