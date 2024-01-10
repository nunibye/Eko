//rename later with more defined scope?
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../utilities/constants.dart' as c;
import 'package:collection/collection.dart';
import 'users.dart';
import '../custom_widgets/controllers/pagination_controller.dart';

class Post {
  String postId;
  bool hasCache;

  final AppUser author;
  final String? gifURL;
  final String? gifSource;
  String time;
  final List<String>? title;
  final List<String>? body;
  final List<String> tags;
  int likes;
  int commentCount;

  //for comments
  final String? rootPostId;

  Post(
      {this.gifSource,
      required this.tags,
      this.gifURL,
      this.postId = '',
      this.time = '',
      this.title,
      required this.author,
      this.body,
      required this.likes,
      this.commentCount = 0,
      this.hasCache = false,
      this.rootPostId});
  static Post fromRaw(RawPostObject rawPost, AppUser user, int commentCount,
      {String? rootPostId, bool hasCache = false}) {
    return Post(
        tags: rawPost.tags,
        hasCache: hasCache,
        gifSource: rawPost.gifSource,
        gifURL: rawPost.gifUrl,
        postId: rawPost.postID,
        author: user,
        title: parseText(rawPost.title),
        body: parseText(rawPost.body),
        time: rawPost.time,
        likes: rawPost.likes,
        commentCount: commentCount,
        rootPostId: rootPostId);
  }

  static List<String> parseText(String? text) {
    if (text == null) return [];

    // const String userNameReqs = c.userNameReqs;
    // RegExp regExp = RegExp('(@$userNameReqs\\b)', caseSensitive: false);
    RegExp regExp = RegExp(r"@[a-z0-9_]{3,24}", caseSensitive: false);

    List<String> chunks = [];
    int lastEnd = 0;

    regExp.allMatches(text).forEach((match) {
      // Add the chunk of text before the match to the list
      String precedingText = text.substring(lastEnd, match.start);
      if (precedingText.isNotEmpty) {
        chunks.add(precedingText);
      } else if (chunks.isNotEmpty && chunks.last.startsWith('@')) {
        // If the last chunk was a username, add an empty string
        chunks.add('');
      }

      // Add the match itself
      chunks.add(match.group(0)!);
      lastEnd = match.end;
    });

    // If there's any text left after the last match, add this remaining text to the list
    if (lastEnd < text.length) {
      chunks.add(text.substring(lastEnd));
    }

    return chunks;
  }
}

class RawPostObject {
  final List<String> tags;
  final String postID;
  final String author;
  final String? title;
  final String? body;
  final String time;
  final String? gifUrl;
  final String? gifSource;
  final int likes;

  RawPostObject({
    required this.tags,
    required this.gifSource,
    required this.gifUrl,
    required this.postID,
    required this.author,
    required this.title,
    required this.body,
    required this.time,
    required this.likes,
  });
  static RawPostObject fromJson(Map<String, dynamic> json, String id) {
    return RawPostObject(
        tags: (json["tags"] ?? ["public"]).cast<String>(),
        gifSource: json["gifSourcef"],
        gifUrl: json["gifUrl"],
        postID: id,
        author: json["author"] ?? "",
        title: json["title"],
        body: json["body"],
        time: json["time"] ?? "",
        likes: json["likes"] ?? 0);
  }
}

class FeedChunk {
  final List<dynamic> uids;
  RawPostObject oldestPost;
  FeedChunk({required this.uids, required this.oldestPost});
}

class RecentActivityCard {
  final String time;
  final String type;
  final String content;
  final String path;
  final String sourceUid;
  AppUser? sourceUser;

  RecentActivityCard(
      {required this.time,
      required this.type,
      required this.content,
      required this.path,
      required this.sourceUid,
      this.sourceUser});
  Map<String, String> toMap() {
    Map<String, String> map = {};
    map["time"] = time;
    map["type"] = type;
    map["content"] = content;
    map["path"] = path;
    map["sourceUid"] = sourceUid;

    return map;
  }

  static RecentActivityCard fromJson(Map<String, dynamic> json, AppUser user) {
    return RecentActivityCard(
        sourceUser: user,
        time: json["time"] ?? "",
        type: json["type"] ?? "",
        content: json["content"] ?? "",
        path: json["path"] ?? "",
        sourceUid: json["sourceUid"] ?? "");
  }
}

class PostsHandling {
  List<FeedChunk> feedChunks = [];

  Future<String> createPost(Map<String, dynamic> post) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    final String time = DateTime.now().toUtc().toIso8601String();
    post["author"] = user.uid;
    post["time"] = time;
    post["likes"] = 0; //change this

    String postID = await firestore
        .collection('posts')
        .add(post)
        .then((documentSnapshot) => documentSnapshot.id);

    List<String> parsedTitle = Post.parseText(post["title"]);
    List<String> parsedBody = Post.parseText(post["body"]);
    Set<String> taggedUsers = {};

    Future<void> addToTaggedUsers(String chunk) async {
      if (chunk.startsWith('@')) {
        String? taggedUid =
            await locator<CurrentUser>().getUidFromUsername(chunk.substring(1));
        if (taggedUid != null && user.uid != taggedUid) {
          taggedUsers.add(taggedUid);
        }
      }
    }

    for (String chunk in parsedTitle) {
      await addToTaggedUsers(chunk);
    }
    for (String chunk in parsedBody) {
      await addToTaggedUsers(chunk);
    }

    String content;
    if (post["title"] != null) {
      content = post["title"];
    } else if (post["body"] != null) {
      content = post["body"];
    } else {
      content = "${post['author']} tagged you in a post";
    }
    for (String uid in taggedUsers) {
      await addActivty(
          time: time, type: "tag", content: content, path: postID, user: uid);
    }

    return postID;
  }

  Future<int> countComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .count()
        .get()
        .then((value) => value.count, onError: (e) => 0);
  }

  createComment(Map<String, dynamic> comment, String postID, String rootAuthor,
      String path) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;
    final String time = DateTime.now().toUtc().toIso8601String();
    comment["author"] = user.uid;
    comment["time"] = time;
    comment["likes"] = 0; //change this

    await firestore
        .collection('posts')
        .doc(postID)
        .collection('comments')
        .add(comment);
    if (user.uid != rootAuthor) {
      await addActivty(
          time: time,
          type: "comment",
          content: comment["body"] ?? 'Click to see gif',
          path: path,
          user: rootAuthor);
    }
    List<String> parsedText = Post.parseText(comment["body"]);
    for (String chunk in parsedText) {
      if (chunk.startsWith('@')) {
        String? taggedUid =
            await locator<CurrentUser>().getUidFromUsername(chunk.substring(1));

        if (taggedUid != null && user.uid != taggedUid) {
          await addActivty(
              time: time,
              type: "tag",
              content: comment["body"],
              path: path,
              user: taggedUid);
        }
      }
    }

    //.then((documentSnapshot)=> print("Added Data with ID: ${documentSnapshot.id}"));
    return "success";
  }

  addActivty(
      {String? time,
      required String type,
      required String content,
      required String path,
      required String user}) async {
    final sourceUser = FirebaseAuth.instance.currentUser!.uid;
    time ??= DateTime.now().toUtc().toIso8601String();
    final firestore = FirebaseFirestore.instance;
    final RecentActivityCard card = RecentActivityCard(
        time: time,
        type: type,
        content: content,
        path: path,
        sourceUid: sourceUser);
    await firestore
        .collection('users')
        .doc(user)
        .collection('newActivity')
        .add(card.toMap());
    await locator<CurrentUser>().setNewActivity(true, uid: user);
  }

  Future<Post?> getPostFromId(String id) async {
    final data =
        await FirebaseFirestore.instance.collection("posts").doc(id).get();
    final postData = data.data();
    if (postData != null) {
      final rawPostData = RawPostObject.fromJson(postData, data.id);
      AppUser user = AppUser();
      await user.readUserData(rawPostData.author);
      await countComments(rawPostData.postID);
      return Post.fromRaw(
          rawPostData, user, await countComments(rawPostData.postID));
    }
    return null;
  }

  Future<List<RecentActivityCard>> getNewActivity(String? time) async {
    late QuerySnapshot<Map<String, dynamic>>? snapshot;
    final user = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;
    final firestoreRef = firestore
        .collection("users")
        .doc(user)
        .collection("newActivity")
        .where("type",
            whereIn: const ["comment", "follow", "tag"]) //update for new types
        .orderBy('time', descending: true);
    if (time == null) {
      snapshot = await firestoreRef.limit(c.activitiesPerRequest).get();
    } else {
      snapshot = await firestoreRef
          .startAfter([time])
          .limit(c.activitiesPerRequest)
          .get();
    }

    final list = snapshot.docs.map<Future<RecentActivityCard>>((doc) async {
      var data = doc.data();
      AppUser user = AppUser();
      await user.readUserData(data["sourceUid"]);
      // FIXME: not sure why this gave an error, i had to add these conditionals
      return RecentActivityCard.fromJson(data, user);

      // return RecentActivityCard(
      //     time: data["time"] ?? "",
      //     type: data["type"] ?? "",
      //     content: data["content"] ?? "",
      //     path: data["path"] ?? "",
      //     sourceUid: data["sourceUid"] ?? "");
    }).toList();
    return Future.wait(list);
  }

  dynamic getTimeFromPost(dynamic post) {
    return (post as Post).time;
  }

  //people who like a post
  Future<PaginationGetterReturn> getPostLikes(
      dynamic uid, String postId) async {
    late QuerySnapshot<Map<String, dynamic>> snapshot;
    if(uid == null)print(postId);

    if (uid == null) {
      //initial data
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("profileData.likedPosts", arrayContains: postId)
          .limit(c.usersOnSearch)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("profileData.likedPosts", arrayContains: postId)
          .orderBy('uid', descending: true)
          .startAfter([uid])
          .limit(c.usersOnSearch)
          .get();
    }
    final userList = snapshot.docs.map<AppUser>((doc) {
      var data = doc.data();
      return AppUser.fromJson(data);
    }).toList();

    return PaginationGetterReturn(
        end: (userList.length < c.usersOnSearch), payload: userList);
  }

//user profile
  Future<PaginationGetterReturn> getProfilePosts(dynamic time) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final postList = (await newGetPosts(
            time,
            FirebaseFirestore.instance
                .collection('posts')
                .where("author", isEqualTo: user)
                .orderBy('time', descending: true)))
        .map<Future<Post>>((raw) async {
      return Post.fromRaw(raw, AppUser.fromCurrent(locator<CurrentUser>()),
          await countComments(raw.postID));
    }).toList();
    return PaginationGetterReturn(
        end: (postList.length < c.postsOnRefresh),
        payload: await Future.wait(postList));
  }

  //groups
  Future<PaginationGetterReturn> getGroupPosts(dynamic time, String id) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final postList = (await newGetPosts(
            time,
            FirebaseFirestore.instance
                .collection('posts')
                //.where("author", isEqualTo: user)
                .where("tags", arrayContains: id)
                .orderBy('time', descending: true)))
        .map<Future<Post>>((raw) async {
      AppUser user = AppUser();
      await user.readUserData(raw.author);
      return Post.fromRaw(raw, user, await countComments(raw.postID));
    }).toList();
    return PaginationGetterReturn(
        end: (postList.length < c.postsOnRefresh),
        payload: await Future.wait(postList));
  }

//sub
  Future<PaginationGetterReturn> getSubProfilePosts(
      dynamic time, AppUser user) async {
    final postList = (await newGetPosts(
            time,
            FirebaseFirestore.instance
                .collection('posts')
                .where("author", isEqualTo: user.uid)
                .where("tags", arrayContains: "public")
                .orderBy('time', descending: true)))
        .map<Future<Post>>((raw) async {
      return Post.fromRaw(raw, user, await countComments(raw.postID));
    }).toList();

    return PaginationGetterReturn(
        end: (postList.length < c.postsOnRefresh),
        payload: await Future.wait(postList));
  }

//comments
  Future<PaginationGetterReturn> getCommentPosts(
      dynamic time, String rootUid) async {
    final postList = (await newGetPosts(
            time,
            FirebaseFirestore.instance
                .collection('posts')
                .doc(rootUid)
                .collection("comments")
                .orderBy('time', descending: true)))
        .map<Future<Post>>((raw) async {
      AppUser user = AppUser();
      await user.readUserData(raw.author);

      return Post.fromRaw(raw, user, await countComments(raw.postID),
          rootPostId: rootUid);
    }).toList();

    return PaginationGetterReturn(
        end: (postList.length < c.postsOnRefresh),
        payload: await Future.wait(postList));
  }

//feed
  Future<PaginationGetterReturn> getFeedPosts(
      dynamic time, Query<Map<String, dynamic>>? query, int index) async {
    final postList =
        (await newGetPosts(time, query)).map<Future<Post>>((raw) async {
      AppUser user = AppUser();
      await user.readUserData(raw.author);

      return Post.fromRaw(raw, user, await countComments(raw.postID),
          hasCache: true);
    }).toList();
    // if (postList.length < c.postsOnRefresh) {
    //   locator<FeedPostCache>().postsList[index].end = true;
    // }
    final listReturn = await Future.wait(postList);
    //locator<FeedPostCache>().postsList[index].items.addAll(listReturn);
    return PaginationGetterReturn(
        end: (postList.length < c.postsOnRefresh), payload: listReturn);
  }

  Future<List<RawPostObject>> newGetPosts(
      dynamic time, Query<Map<String, dynamic>>? query) async {
    late QuerySnapshot<Map<String, dynamic>> snapshot;
    if (query != null) {
      if (time == null) {
        //initial data
        snapshot = await query.limit(c.postsOnRefresh).get();
      } else {
        snapshot = await query.startAfter([time]).limit(c.postsOnRefresh).get();
      }
      return snapshot.docs.map<RawPostObject>((doc) {
        var data = doc.data();

        return RawPostObject.fromJson(data, doc.id);
      }).toList();
    } else {
      final firestore = FirebaseFirestore.instance;
      List<RawPostObject> postsToPassBack = [];
      if (locator<CurrentUser>().following.isEmpty) {
        return postsToPassBack;
      }

      if (feedChunks.isEmpty) {
        // must handle if the user is following no one or app crashes
        if (locator<CurrentUser>().following.isEmpty) {
          return postsToPassBack;
        }

        final following = locator<CurrentUser>().following.slices(30);
        for (List<dynamic> slice in following) {
          snapshot = await firestore
              .collection('posts')
              .where('author', whereIn: slice)
              .where("tags", arrayContains: "public")
              .orderBy('time', descending: true)
              .limit(1)
              .get();
          if (snapshot.docs.isEmpty) {
            return postsToPassBack;
          }
          final data = snapshot.docs.first.data();
          feedChunks.add(
            FeedChunk(
                uids: slice,
                oldestPost:
                    RawPostObject.fromJson(data, snapshot.docs.first.id)),
          );
        }

        feedChunks
            .sort((a, b) => a.oldestPost.time.compareTo(a.oldestPost.time));
        postsToPassBack.add(feedChunks.first.oldestPost);
      }

      while (postsToPassBack.length < c.postsOnRefresh) {
        snapshot = await firestore
            .collection('posts')
            .where("author", whereIn: feedChunks.first.uids)
            .where("tags", arrayContains: "public")
            .orderBy('time', descending: true)
            .startAfter([feedChunks.first.oldestPost.time])
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          feedChunks.first.oldestPost =
              RawPostObject.fromJson(data, snapshot.docs.first.id);
          postsToPassBack.add(feedChunks.first.oldestPost);
          feedChunks.sort(
            (a, b) => a.oldestPost.time.compareTo(a.oldestPost.time),
          );
        } else {
          feedChunks.removeAt(0);
          if (feedChunks.isEmpty) {
            return postsToPassBack;
          }
        }
      }

      return postsToPassBack;
    }
  }

  // Future<List<RawPostObject>> getPosts(
  //     String? time, Query<Map<String, dynamic>>? query) async {
  //   late QuerySnapshot<Map<String, dynamic>>? snapshot;
  //   if (query != null) {
  //     if (time == null) {
  //       //initial data
  //       snapshot = await query.limit(c.postsOnRefresh).get();
  //     } else {
  //       snapshot = await query.startAfter([time]).limit(c.postsOnRefresh).get();
  //     }
  //     return snapshot.docs.map<RawPostObject>((doc) {
  //       var data = doc.data();

  //       return RawPostObject.fromJson(data, doc.id);
  //     }).toList();

  //     //Following
  //   } else {
  //     final firestore = FirebaseFirestore.instance;
  //     List<RawPostObject> postsToPassBack = [];
  //     if (locator<CurrentUser>().following.isEmpty) {
  //       return postsToPassBack;
  //     }
  //     if (feedChunks.isEmpty) {
  //       // must handle if the user is following no one or app crashes
  //       if (locator<CurrentUser>().following.isEmpty) {
  //         return postsToPassBack;
  //       }

  //       final following = locator<CurrentUser>().following.slices(30);
  //       for (List<dynamic> slice in following) {
  //         snapshot = await firestore
  //             .collection('posts')
  //             .where('author', whereIn: slice)
  //             .where("tags", arrayContains: "public")
  //             .orderBy('time', descending: true)
  //             .limit(1)
  //             .get();
  //         if (snapshot.docs.isEmpty) {
  //           return postsToPassBack;
  //         }
  //         final data = snapshot.docs.first.data();
  //         feedChunks.add(
  //           FeedChunk(
  //             uids: slice,
  //             oldestPost: RawPostObject.fromJson(
  //               data,
  //               snapshot.docs.first.id,
  //             ),
  //           ),
  //         );
  //       }

  //       feedChunks
  //           .sort((a, b) => a.oldestPost.time.compareTo(a.oldestPost.time));
  //       postsToPassBack.add(feedChunks.first.oldestPost);
  //     }

  //     while (postsToPassBack.length < c.postsOnRefresh) {
  //       snapshot = await firestore
  //           .collection('posts')
  //           .where("author", whereIn: feedChunks.first.uids)
  //           .where("tags", arrayContains: "public")
  //           .orderBy('time', descending: true)
  //           .startAfter([feedChunks.first.oldestPost.time])
  //           .limit(1)
  //           .get();
  //       if (snapshot.docs.isNotEmpty) {
  //         final data = snapshot.docs.first.data();
  //         feedChunks.first.oldestPost =
  //             RawPostObject.fromJson(data, snapshot.docs.first.id);

  //         feedChunks.sort(
  //           (a, b) => a.oldestPost.time.compareTo(a.oldestPost.time),
  //         );
  //       } else {
  //         feedChunks.removeAt(0);
  //         if (feedChunks.isEmpty) {
  //           return postsToPassBack;
  //         }
  //       }
  //     }

  //     return postsToPassBack;
  //   }
  // }
}
