import 'package:flutter/cupertino.dart';
import 'package:untitled_app/models/feed_post_cache.dart';
import '../../models/post_handler.dart';
import '../../models/users.dart';
import '../../utilities/locator.dart';
import '../../utilities/constants.dart' as c;
import 'package:cloud_firestore/cloud_firestore.dart' show Query;
import '../../models/users.dart' show AppUser;

class FeedBuilderController extends ChangeNotifier {
  late List<Post> posts;

  AppUser? passedUser;
  final scroll = ScrollController();
  bool loading = false;
  late bool end;
  int? index;
  final Query<Map<String, dynamic>>? firestoreQuery;
  final Function? refreshFunction;

  final BuildContext context;

  FeedBuilderController(
      {required this.firestoreQuery,
      required this.refreshFunction,
      required this.context,
      this.passedUser,
      required this.index}) {
    // print(locator<FeedPostCache>().postsList[index ?? 0].length);

    init();
  }
  init() async {
    if (index == null) {
      posts = [];
      end = false;
    } else {
      posts = List.from(locator<FeedPostCache>().postsList[index!].posts);
      end = locator<FeedPostCache>().postsList[index!].end;
    }
    scroll.addListener(() => _onScroll());
    if (posts.isEmpty) {
      await parseRawPosts(
          await locator<PostsHandling>().getPosts(null, firestoreQuery));
    }
    notifyListeners();
  }

  _onScroll() async {
    if (!end) {
      print('here');
      if (scroll.position.maxScrollExtent - scroll.position.pixels <=
          MediaQuery.sizeOf(context).height * 0.2) {
        if (loading == false) {
          loading = true;
          if (posts.isNotEmpty) {
            await parseRawPosts(await locator<PostsHandling>()
                .getPosts(posts.last.time, firestoreQuery));
            notifyListeners();
          }

          loading = false;
        }
      }
    }
  }

  parseRawPosts(List<RawPostObject> rawPosts) async {
    if (rawPosts.length < c.postsOnRefresh) {
      end = true;
      if (index != null) {
        locator<FeedPostCache>().postsList[index!].end = true;
      }
    }
    for (RawPostObject raw in rawPosts) {
      AppUser user = AppUser();
      await user.readUserData(raw.author, user: passedUser);
      final post = Post(
        postId: raw.postID,
        followers: user.followers,
        following: user.following,
        userLikes: user.likes,
        username: user.username,
        profilePic: user.profileImage,
        firstName: user.firstName,
        lastName: user.lastName,
        uid: raw.author,
        time: raw.time,
        title: raw.title,
        body: raw.body,
        likes: raw.likes,
        profileBio: user.bio,
        bioName: user.bioName,
      );
      posts.add(post);
      if (index != null) {
        locator<FeedPostCache>().postsList[index!].posts.add(post);
      }
    }
  }

  Future<void> onRefresh() async {
    end = false;
    posts = [];
    if (index != null) {
      locator<FeedPostCache>().postsList[index!].posts.clear();
      locator<FeedPostCache>().postsList[index!].end = false;
    }
    locator<PostsHandling>().feedChunks = [];
    await parseRawPosts(
        await locator<PostsHandling>().getPosts(null, firestoreQuery));
    if (refreshFunction != null) {
      refreshFunction!();
    }
    // end = false;
    print('refresh');
    notifyListeners();
  }
}
