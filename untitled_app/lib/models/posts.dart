//rename later with more defined scope?
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Post {
  final String username;
  final String profilePic;
  final String time;
  final String title;
  final String body;
  final int likes;
  Post(
      {required this.username,
      required this.profilePic,
      required this.time,
      required this.title,
      required this.body,
      required this.likes});
}

class PostsHandling {
  createPost(Map<String, dynamic> post) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    post["author"] = user.uid;
    post["time"] = DateTime.now().toUtc().toIso8601String();
    post["likes"] = [user.uid];
    await firestore
        .collection('posts')
        .doc(user.uid)
        .collection('posts')
        .add(post)
        .then((documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
    return "success";
  }
}
