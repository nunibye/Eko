import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_profile.dart';
import 'widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'constants.dart' as c;
import 'comments_page.dart';

// TODO: the code here is very messy and long and can def be fixed, i was just playing around with the database at night to get it to load posts
// TODO: check the README for picture example. Add the database info to your doc to check it out on your user. or text me.

class Post {
  final Timestamp date;
  final List<dynamic> likes;
  final List<dynamic>
      comments; // TODO: fix this i have commments and postReference. Why? idk, i must fix when im not tired
  final String username;
  final String text;
  final String uid;
  final List<DocumentReference<Object?>> postReference;

  Post({
    required this.date,
    required this.username,
    required this.likes,
    required this.comments,
    required this.text,
    required this.uid,
    required this.postReference,
  });
}

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
    _loadUserData();
  }

  // Function to navigate to the comments page when a post is clicked
  void _onPostClicked(List<DocumentReference> postReference) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsPage(postReferences: postReference),
      ),
    );
  }
  //TODO: these functions should probably be put in a separate dart file to access in other places
  Future<String> _getUsernameFromDocument(DocumentReference usernameRef) async {
    final snapshot = await usernameRef.get();
    final data =
        snapshot.data() as Map<String, dynamic>?; // Explicitly cast to Map
    return data?['username'] ?? ''; // Safely access the 'username' property
  }

  Future<String> _getUIDFromDocument(DocumentReference usernameRef) async {
    final snapshot = await usernameRef.get();
    final data =
        snapshot.data() as Map<String, dynamic>?; // Explicitly cast to Map
    return data?['uid'] ?? ''; // Safely access the 'username' property
  }

  Future<String?> _getProfileImage(String uid) async {
    try {
      var urlRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/$uid/profile.jpg");
      var imageUrl = await urlRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('users')
          .where("uid", isEqualTo: user?.uid)
          .get(); // Get the user's document based on their UID
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final likes =
            userData['profileData']['followers']; // exmaple map querey
        final followers =
            userData['profileData']['following']; // exmaple map querey
        final following = userData['profileData']['likes'];
        final username = userData['username'];
        if (likes != null) {
          setState(() {
            _likes = likes;
            _followers = followers;
            _following = following;
            _username = username;
          });
        } else {
          setState(() {
            _likes = 0;
            _followers = 0;
            _following = 0;
            _username = "Username not found...";
          });
        }
      }
    }
  }

  Future<List<Post>> _loadPosts() async {
    List<Post> postsList = [];

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('posts')
          .doc(user?.uid)
          .collection('posts')
          .orderBy('date', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        postsList = await Future.wait(
          querySnapshot.docs.map(
            (doc) async {
              var data = doc.data();
              DocumentReference authorRef = data['author'];
              String username = await _getUsernameFromDocument(
                  authorRef); // TODO: too many read calls, can fix later with less functions...
              String uid = await _getUIDFromDocument(authorRef);
              return Post(
                date: data['date'] ?? '',
                likes: List.from(data['likes'] ?? []),
                comments: List.from(data['comments'] ?? []),
                text: data['text'] ?? '',
                username: username,
                uid: uid,
                postReference:
                    List<DocumentReference<Object?>>.from(data['comments']),
              );
            },
          ),
        );
      }
    }
    return postsList;
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
                  future: _getProfileImage(user!.uid),
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
            future: _loadPosts(),
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
                      profileImageURL: _getProfileImage(post.uid),
                      // uid: post.uid,
                      postReference: post.postReference,
                      onPostClick: () => _onPostClicked(post.postReference),
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

class TweetCard extends StatelessWidget {
  final String username;
  final String content;
  final DateTime date;
  final int likes;
  final int comments;
  final Future<String?> profileImageURL;
  final VoidCallback onPostClick;
  final List<DocumentReference<Object?>> postReference;

  const TweetCard({
    super.key,
    required this.username,
    required this.content,
    required this.date,
    required this.likes,
    required this.comments,
    required this.profileImageURL,
    required this.onPostClick,
    required this.postReference,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: onPostClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Divider(
                  color: Colors.grey[30],
                  height: 1,
                ),
              ),
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
                    FutureBuilder<String?>(
                      future: profileImageURL,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show a loading indicator while the image URL is being fetched
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          // Handle the error if fetching the image URL fails
                          return CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.05,
                            backgroundColor: Colors.grey,
                          );
                        } else {
                          // Display the CircleAvatar with the fetched profile image URL
                          return CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.05,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: c.postPaddingHoriz,
                  vertical: c.postPaddingVert,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.comment),
                        const SizedBox(width: 5),
                        Text('$comments'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border),
                        const SizedBox(width: 5),
                        Text('$likes'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
