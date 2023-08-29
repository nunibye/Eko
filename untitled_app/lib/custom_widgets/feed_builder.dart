import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/models/users.dart' show AppUser;
import 'controllers/feed_builder_controller.dart';
import '../custom_widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Query;

class FeedBuilder extends StatelessWidget {
  final Widget header;
  final Query<Map<String, dynamic>>? firestoreQuery;
  final Function? refreshFunction;
  final AppUser? user;
  const FeedBuilder(
      {required this.firestoreQuery,
      required this.header,
      this.refreshFunction,
      super.key,
      this.user});
  @override
  Widget build(BuildContext context) {
    //TODO idk why this works. profile used to not reload then I changed it to .value now it does maybe more providers should be .value?
    return ChangeNotifierProvider.value(
      value: FeedBuilderController(
          firestoreQuery: firestoreQuery,
          refreshFunction: refreshFunction,
          context: context,
          passedUser: user),
      builder: (context, child) {
        return RefreshIndicator(
          child: Consumer<FeedBuilderController>(
            builder: (context, feedController, child) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller:
                  Provider.of<FeedBuilderController>(context, listen: false)
                      .scroll,
              itemCount: feedController.posts.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return child;
                } else if (feedController.posts.isNotEmpty &&
                    index < feedController.posts.length + 1) {
                  return PostCard(post: feedController.posts[index - 1]);
                } else {
                  if (feedController.posts.isEmpty) {
                    return const Center(child:Column(children: [Text("add loading animation"), CircularProgressIndicator()],));
                  } else {
                    return feedController.end
                        ? const Center(
                            child: Text("No More Posts"),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(),
                            ),
                          );
                  }
                }
              },
            ),
            child: header,
          ),
          onRefresh: () =>
              Provider.of<FeedBuilderController>(context, listen: false)
                  .onRefresh(),
        );
      },
    );
  }
}
