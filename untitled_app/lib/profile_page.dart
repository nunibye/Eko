import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'views/edit_profile.dart';
import './custom_widgets/profile_page_top.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'utilities/constants.dart' as c;
import 'comments_page.dart';
import 'post_functions.dart';

// TODO: check the README for picture example. Add the database info to your doc to check it out on your user. or text me.

class ProfilePage extends StatefulWidget {
  final List<DocumentReference> postReferences;
  const ProfilePage({super.key, required this.postReferences});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _likes = 0;
  int _followers = 0;
  int _following = 0;
  String _username = "...";
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // Create an instance of UserDataLoader and call the loadUserData method
    UserDataLoader(userDataLoadedCallback).loadUserData();
  }

  // Callback function to update the state when user data is loaded
  void userDataLoadedCallback(
      int likes, int followers, int following, String username) {
    setState(() {
      _likes = likes;
      _followers = followers;
      _following = following;
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: getProfileImage(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        radius: MediaQuery.sizeOf(context).width * 0.13,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    } else {
                      return CircleAvatar(
                        radius: MediaQuery.sizeOf(context).width * 0.13,
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  _username,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePageTopNumberDisplay(
                  number: _likes, label: AppLocalizations.of(context)!.likes),
              ProfilePageTopNumberDisplay(
                  number: _followers,
                  label: AppLocalizations.of(context)!.followers),
              ProfilePageTopNumberDisplay(
                  number: _following,
                  label: AppLocalizations.of(context)!.following),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfile()),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.editProfile,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            child: Text(
              "Your Posts",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder<List<Post>>(
            future: loadAllUserPosts(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              } else if (snapshot.hasError) {
                return Text("Error loading posts: ${snapshot.error}");
              } else if (!snapshot.hasData) {
                return const Text("No posts available.");
              } else {
                // Display the posts in a ListView
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data![index];
                    return TweetCard(
                      username: post.username,
                      content: post.text,
                      date: post.date.toDate(),
                      likes: post.likes.length,
                      comments: post.comments.length,
                      profileImageURL: getProfileImage(post.uid),
                      postReference: post.postReference,
                      onPostClick: () =>
                          onPostClicked(post.postReference, context),
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
