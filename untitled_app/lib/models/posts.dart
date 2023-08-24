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
