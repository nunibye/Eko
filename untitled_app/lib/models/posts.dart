//rename later with more defined scope?
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostsHandling {
  createPost(Map<String, dynamic> post) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    post["author"] = user.uid;
    post["time"] = DateTime.now().toUtc().toIso8601String();
    post["likes"] = [user.uid];
    await firestore.collection('posts').add(post).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
    return "success";
  }

  Future<List<RawPostObject>> getPosts(String? time) async {
    final collectionRef = FirebaseFirestore.instance.collection("posts");
    late QuerySnapshot<Map<String, dynamic>> snapshot;
    if (time == null) {
      //initial data
      snapshot = await collectionRef
          .orderBy('time', descending: true)
          .limit(c.postsOnRefresh)
          .get();
    } else {
      snapshot = await collectionRef
          .orderBy('time', descending: true)
          .startAfter([time])
          .limit(c.postsOnRefresh)
          .get();
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
