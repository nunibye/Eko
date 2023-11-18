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

  void rebuildFunction() {
    notifyListeners();
  }

  _onScroll() async {
    if (!end) {
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
        gifSource: raw.gifSource,
        gifURL: raw.gifUrl,
        postId: raw.postID,
        author: user,
        time: raw.time,
        title: raw.title,
        body: raw.body,
        likes: raw.likes,
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
    notifyListeners();
  }
}
