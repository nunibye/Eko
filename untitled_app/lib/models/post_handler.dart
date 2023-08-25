//rename later with more defined scope?
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/constants.dart' as c;

class Post {
  final String username;
  final String firstName;
  final String lastName;
  final String uid;
  final String profilePic;
  final String time;
  final String title;
  final String body;
  final int likes;
  final int followers;
  final int following;
  final int userLikes;
  Post(
      {required this.username,
      required this.firstName,
      required this.lastName,
      required this.profilePic,
      required this.time,
      required this.title,
      required this.uid,
      required this.body,
      required this.likes,
      required this.followers,
      required this.following,
      required this.userLikes});
}

class RawPostObject {
  final String author;
  final String title;
  final String body;
  final String time;

  final List<dynamic> likes;
  RawPostObject({
    required this.author,
    required this.title,
    required this.body,
    required this.time,
    required this.likes,
  });
}

class PostsHandling {
  createPost(Map<String, dynamic> post) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    post["author"] = user.uid;
    post["time"] = DateTime.now().toUtc().toIso8601String();
    post["likes"] = [user.uid];
    await firestore.collection('posts').add(post);
    //.then((documentSnapshot)=> print("Added Data with ID: ${documentSnapshot.id}"));
    return "success";
  }

  Future<List<RawPostObject>> getPosts(
      String? time, Query<Map<String, dynamic>> query) async {
    late QuerySnapshot<Map<String, dynamic>> snapshot;
    if (time == null) {
      //initial data
      snapshot = await query.limit(c.postsOnRefresh).get();
    } else {
      snapshot = await query.startAfter([time]).limit(c.postsOnRefresh).get();
    }
    return snapshot.docs
        .map<RawPostObject>((data) => RawPostObject(
            author: data["author"] ?? "",
            title: data["title"] ?? "",
            body: data["body"] ?? "",
            time: data["time"] ?? "",
            likes: data["likes"] ?? []))
        .toList();
  }
}
