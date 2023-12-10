import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/custom_widgets/post_card.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/custom_widgets/comment_card.dart';
import '../custom_widgets/searched_user_card.dart';
import '../models/post_handler.dart' show Post;
import '../controllers/view_post_page_controller.dart';
import '../custom_widgets/pagination.dart';

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

                      // Expanded(
                      //     child: PaginationPage(
                      //         getter: Provider.of<PostPageController>(context,
                      //                 listen: false)
                      //             .getCommentsFromPost,
                      //         card: commentCardBuilder,
                      //         header: const _Header(),
                      //         startAfterQuery: Provider.of<PostPageController>(
                      //                 context,
                      //                 listen: false)
                      //             .getTimeFromPost)
                      //     // FeedBuilder(
                      //     //   rootPostId: Provider.of<PostPageController>(context,
                      //     //           listen: false)
                      //     //       .post!
                      //     //       .postId,
                      //     //   isComment: true,
                      //     //   firestoreQuery: FirebaseFirestore.instance
                      //     //       .collection('posts')
                      //     //       .doc(Provider.of<PostPageController>(context,
                      //     //               listen: false)
                      //     //           .post!
                      //     //           .postId)
                      //     //       .collection("comments")
                      //     //       .orderBy('time', descending: true),
                      //     //   header: const _Header(),
                      //     // ),
                      //     ),

                      // SizedBox(
                      //   height: height * 0.08,
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       SizedBox(
                      //         width: MediaQuery.sizeOf(context).width * 0.95,
                      //         child: TextField(
                      //           textCapitalization: TextCapitalization.sentences,
                      //           cursorColor:
                      //               Theme.of(context).colorScheme.onBackground,
                      //           focusNode: Provider.of<PostPageController>(
                      //                   context,
                      //                   listen: false)
                      //               .commentFeildFocus,
                      //           onChanged: (s) =>
                      //               Provider.of<PostPageController>(context,
                      //                       listen: false)
                      //                   .updateCount(s),
                      //           maxLines: null,
                      //           controller: Provider.of<PostPageController>(
                      //                   context,
                      //                   listen: false)
                      //               .commentFeild,
                      //           keyboardType: TextInputType.emailAddress,
                      //           decoration: InputDecoration(
                      //             contentPadding: EdgeInsets.all(height * 0.01),
                      //             hintText:
                      //                 AppLocalizations.of(context)!.addComment,
                      //             fillColor:
                      //                 Theme.of(context).colorScheme.surface,
                      //             filled: true,
                      //             focusColor:
                      //                 Theme.of(context).colorScheme.surface,
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //               borderSide: BorderSide.none,
                      //             ),
                      //             suffixIcon: IconButton(
                      //               onPressed: () {
                      //                 Provider.of<PostPageController>(context,
                      //                         listen: false)
                      //                     .postCommentPressed();
                      //               },
                      //               icon: const Icon(Icons.send),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )

                      Expanded(
                        child: Stack(
                          children: [
                            Offstage(
                              offstage: Provider.of<PostPageController>(context,
                                      listen: false)
                                  .isAtSymbolTyped,
                              child: PaginationPage(
                                  getter: Provider.of<PostPageController>(
                                          context,
                                          listen: false)
                                      .getCommentsFromPost,
                                  card: commentCardBuilder,
                                  header: const _Header(),
                                  startAfterQuery:
                                      Provider.of<PostPageController>(context,
                                              listen: false)
                                          .getTimeFromPost),
                            ),
                            Offstage(
                              offstage: !Provider.of<PostPageController>(
                                          context,
                                          listen: false)
                                      .isAtSymbolTyped ||
                                  Provider.of<PostPageController>(context,
                                          listen: false)
                                      .isUsernameFinished,
                              child: Expanded(
                                child: Provider.of<PostPageController>(context,
                                            listen: true)
                                        .isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Provider.of<PostPageController>(context,
                                                listen: true)
                                            .hits
                                            .isEmpty
                                        ? Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .noResultsFound,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount:
                                                Provider.of<PostPageController>(
                                                        context,
                                                        listen: true)
                                                    .hits
                                                    .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return UserCard(
                                                  tagSearch: true,
                                                  onCardTap: (username) {
                                                    Provider.of<PostPageController>(
                                                            context,
                                                            listen: false)
                                                        .updateTextField(
                                                            username);
                                                  },
                                                  user: Provider.of<
                                                              PostPageController>(
                                                          context,
                                                          listen: true)
                                                      .hits[index]);
                                            },
                                          ),
                              ),
                            ),
                          ],
                        ),
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                cursorColor:
                                    Theme.of(context).colorScheme.onBackground,
                                focusNode: Provider.of<PostPageController>(
                                        context,
                                        listen: false)
                                    .commentFeildFocus,
                                onChanged: (s) {
                                  Provider.of<PostPageController>(context,
                                          listen: false)
                                      .updateCount(s);
                                  Provider.of<PostPageController>(context,
                                          listen: false)
                                      .checkAtSymbol(s);
                                },
                                maxLines: null,
                                controller: Provider.of<PostPageController>(
                                        context,
                                        listen: false)
                                    .commentFeild,
                                keyboardType: TextInputType.emailAddress,
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
                      ),
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
          isBuiltFromId: Provider.of<PostPageController>(context, listen: false)
              .builtFromID,
        ),
        Divider(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
        ),
      ],
    );
  }
}
