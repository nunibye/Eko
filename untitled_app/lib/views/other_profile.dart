import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/custom_widgets/profile_page_header.dart';
import '../controllers/other_profile_controller.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/feed_builder.dart';
import '../models/post_handler.dart' show Post;
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherProfile extends StatelessWidget {
  final Post? post;
  const OtherProfile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OtherProfileController(context: context, post: post),
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () => context.pop()),
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                Provider.of<OtherProfileController>(context, listen: true)
                    .username,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz_outlined), //this could open a floating menu where you could block, or do something to adjust settings with this profile
                )
              ],
            ),
            body: FeedBuilder(
              //query. Ok to be here in MVVM becasue it doesn't interact with database. Just a template for a request
              firestoreQuery: FirebaseFirestore.instance
                  .collection('posts')
                  .where("author",
                      isEqualTo: Provider.of<OtherProfileController>(context,
                              listen: false)
                          .uid)
                  .orderBy('time', descending: true),
              //This widget will be first in the list. use Column for this not ListView
              header: const _Header(),
              //Optional funtion to call on refresh.
              refreshFunction:
                  Provider.of<OtherProfileController>(context, listen: false)
                      .onPageRefresh,
            ));
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
        Consumer<OtherProfileController>(
            builder: (context, otherProfileController, _) => ProfileHeader(
                  username: otherProfileController.username,
                  profilePic: otherProfileController.profileImage,
                  likes: otherProfileController.likes,
                  following: otherProfileController.following,
                  followers: otherProfileController.followers,
                  user_settings: false,
                ))
      ],
    );
  }
}
