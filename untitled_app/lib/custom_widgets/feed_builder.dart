import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/feed_builder_controller.dart';
import '../custom_widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Query;

class FeedBuilder extends StatelessWidget {
  final Widget header;
  final Query<Map<String, dynamic>> firestoreQuery;
  final Function? refreshFunction;
  const FeedBuilder(
      {required this.firestoreQuery,
      required this.header,
      this.refreshFunction,
      super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedBuilderController(
          firestoreQuery: firestoreQuery, refreshFunction: refreshFunction),
      builder: (context, child) {
        return Scaffold(
          body: RefreshIndicator(
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
                    return feedController.end
                        ? const Center(child: Text("No More Posts"))
                        : const Center(
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator()));
                  }
                },
              ),
              child: header,
            ),
            onRefresh: () =>
                Provider.of<FeedBuilderController>(context, listen: false)
                    .onRefresh(),
          ),
        );
      },
    );
  }
}
