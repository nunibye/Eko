import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/search_page_controller.dart';
import '../custom_widgets/feed_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPageController(),
      builder: (context, child) {
        return Scaffold(
            body: FeedBuilder(
              //TODO maybe optimize to check current user?
              user: null,
          header: const _Header(),
          firestoreQuery: FirebaseFirestore.instance
              .collection("posts")
              .orderBy('time', descending: true),
        ));
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Text("header");
  }
}
