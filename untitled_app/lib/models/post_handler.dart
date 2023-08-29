//rename later with more defined scope?
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../utilities/constants.dart' as c;
import 'package:collection/collection.dart';

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
  final List<dynamic> followers;
  final List<dynamic> following;
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

class feedChunk {
  final List<dynamic> uids;
  final RawPostObject oldestPost;
  feedChunk({required this.uids, required this.oldestPost});
}

class PostsHandling {
  List<feedChunk> feedChunks = [];
  createPost(Map<String, dynamic> post) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    post["author"] = user.uid;
    post["time"] = DateTime.now().toUtc().toIso8601String();
    post["likes"] = [user.uid]; //change this
    await firestore.collection('posts').add(post);
    //.then((documentSnapshot)=> print("Added Data with ID: ${documentSnapshot.id}"));
    return "success";
  }

  Future<List<RawPostObject>> getPosts(
      String? time, Query<Map<String, dynamic>>? query) async {
    late QuerySnapshot<Map<String, dynamic>> snapshot;
    if (query != null) {
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

      //Following
    } else {
      final firestore = FirebaseFirestore.instance;
      List<RawPostObject> postsToPassBack = [];
      if (feedChunks.isEmpty) {
        
        // must handle if the user is following no one or app crashes
        if (locator<CurrentUser>().following.isEmpty) {
          return postsToPassBack;
        }

        final following = locator<CurrentUser>().following.slices(30);
        for (List<dynamic> slice in following) {
          snapshot = await firestore
              .collection('posts')
              .where(locator<CurrentUser>().getUID(), whereIn: slice)
              .orderBy('time', descending: true)
              .limit(1)
              .get();
          final data = snapshot.docs.first;
          feedChunks.add(feedChunk(
              uids: slice,
              oldestPost: RawPostObject(
                  author: data["author"] ?? "",
                  title: data["title"] ?? "",
                  body: data["body"] ?? "",
                  time: data["time"] ?? "",
                  likes: data["likes"] ?? [])));
        }

        feedChunks
            .sort((a, b) => a.oldestPost.time.compareTo(a.oldestPost.time));
      }

      while (postsToPassBack.length < 5) {}

      return postsToPassBack;
    }
  }
}
