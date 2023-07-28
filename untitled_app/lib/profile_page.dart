import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_profile.dart';
import 'widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Post {
  final Timestamp date;
  final List<dynamic> likes;
  final List<dynamic> comments;
  final String text;

  Post({
    required this.date,
    required this.likes,
    required this.comments,
    required this.text,
  });
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

  Future<String?> _getProfileImage() async {
    try {
      var urlRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${user!.uid}/profile.jpg");
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
        postsList = querySnapshot.docs.map((doc) {
          var data = doc.data();
          return Post(
            date: data['date'] ?? '',
            likes: List.from(data['likes'] ?? []),
            comments: List.from(data['comments'] ?? []),
            text: data['text'] ?? '',
          );
        }).toList();
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
                  future: _getProfileImage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        radius: MediaQuery.sizeOf(context).width * 0.13,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    } else {
                      return Container();
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
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Text("Error loading posts."); // Handle error case
              } else {
                // Display the posts in a ListView
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data![index];
                    return ListTile(
                      title: Text(post.text),
                      subtitle: Text(
                          DateTime.parse(post.date.toDate().toString())
                              .toString()),
                      trailing: Text('${post.likes.length} Likes'),
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
