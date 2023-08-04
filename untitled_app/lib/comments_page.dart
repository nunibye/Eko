import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled_app/profile_page.dart';

class CommentsPage extends StatelessWidget {
  final List<DocumentReference> postReferences;

  CommentsPage({required this.postReferences});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: postReferences.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot>(
            future: postReferences[index].get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error loading post: ${snapshot.error}");
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text("Post not found.");
              } else {
                final post = snapshot.data!;
                return TweetCard(
                  username:
                      post['username'], // Access fields using [String] key
                  content: post['text'], // Access fields using [String] key
                  date: post['date']
                      .toDate(), // Convert to DateTime using .toDate()
                  likes:
                      (post['likes'] as List).length, // Cast the likes to List
                  comments: (post['comments'] as List)
                      .length, // Cast the comments to List
                  // Assuming you already have the profile image URL
                  // otherwise, fetch it similar to the ProfilePage
                  profileImageURL: Future.value(null),
                  // postID: snapshot.data!.id,
                  postReference: List<DocumentReference<Object?>>.from(
                      post['comments']), // Access fields using [String] key
                  // Access fields using [String] key
                  onPostClick: () {
                    // Handle the post click if needed
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
