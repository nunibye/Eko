import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_profile.dart';
import 'widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TODO: the code here is very messy and long and can def be fixed, i was just playing around with the database at night to get it to load posts

class Post {
  final Timestamp date;
  final List<dynamic> likes;
  final List<dynamic> comments;
  final String username;
  final String text;
  final String uid;

  Post(
      {required this.date,
      required this.username,
      required this.likes,
      required this.comments,
      required this.text,
      required this.uid});
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
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
      var imageUrl = urlRef.getDownloadURL();
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
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        postsList = await Future.wait(querySnapshot.docs.map((doc) async {
          var data = doc.data();
          String username = await _getUsernameFromDocument(data[
              'author']); // TODO: too many read calls, can fix later with less functions...
          String uid = await _getUIDFromDocument(data['author']);
          return Post(
            date: data['date'] ?? '',
            likes: List.from(data['likes'] ?? []),
            comments: List.from(data['comments'] ?? []),
            text: data['text'] ?? '',
            username: username,
            uid: uid,
          );
        }));
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
                return CircularProgressIndicator.adaptive();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Text("Error loading posts.");
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
                      profileImageURL: _getProfileImage(post.uid),
                    );
                  },
                );
              }
            },
          ),
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
  final Future<String?> profileImageURL;

  TweetCard({
    required this.username,
    required this.content,
    required this.date,
    required this.likes,
    required this.profileImageURL,
  });

    @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the profile picture as a CircleAvatar
              FutureBuilder<String?>(
                future: profileImageURL,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while the image URL is being fetched
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    // Handle the error if fetching the image URL fails
                    return CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.06,
                      backgroundColor: Colors.grey,
                    );
                  } else {
                    // Display the CircleAvatar with the fetched profile image URL
                    return CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.06,
                      backgroundImage: NetworkImage(snapshot.data!),
                    );
                  }
                },
              ),

              const SizedBox(width: 10),
              Expanded( // Use Expanded to allow the content to wrap
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
                      style: TextStyle(
                        fontSize: 14, // Adjust the font size as needed
                        color: Colors.white, // or any other color you want
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.favorite_border),
              Text('$likes Likes'),
            ],
          ),
        ],
      ),
    );
  }
}

