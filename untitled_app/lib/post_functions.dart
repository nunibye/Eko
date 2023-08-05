import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'comments_page.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as c;

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

Future<List<Post>> loadAllUserPosts(User? user) async {
    List<Post> postsList = [];

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('posts')
          .doc(user.uid)
          .collection('posts')
          .orderBy('date', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        postsList = await Future.wait(
          querySnapshot.docs.map(
            (doc) async {
              var data = doc.data();
              DocumentReference authorRef = data['author'];
              String username = await getUsernameFromDocument(
                  authorRef); // TODO: too many read calls, can fix later with less functions...
              String uid = await getUIDFromDocument(authorRef);
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

class UserDataLoader {
  final void Function(int likes, int followers, int following, String username)
      onDataLoaded;

  UserDataLoader(this.onDataLoaded);

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

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
          onDataLoaded(likes, followers, following, username);
        } else {
          onDataLoaded(0, 0, 0, "Username not found...");
        }
      }
    }
  }
}

Future<String?> getProfileImage(String uid) async {
  final user = FirebaseAuth.instance.currentUser;

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

// Function to navigate to the comments page when a post is clicked
void onPostClicked(
    List<DocumentReference> postReference, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CommentsPage(postReferences: postReference),
    ),
  );
}

Future<String> getUsernameFromDocument(DocumentReference usernameRef) async {
  final snapshot = await usernameRef.get();
  final data =
      snapshot.data() as Map<String, dynamic>?; // Explicitly cast to Map
  return data?['username'] ?? ''; // Safely access the 'username' property
}

Future<String> getUIDFromDocument(DocumentReference usernameRef) async {
  final snapshot = await usernameRef.get();
  final data =
      snapshot.data() as Map<String, dynamic>?; // Explicitly cast to Map
  return data?['uid'] ?? ''; // Safely access the 'username' property
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
