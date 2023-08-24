import 'package:flutter/cupertino.dart';
import '../../models/post_handler.dart';
import '../../models/users.dart';
import '../../utilities/locator.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import '../../utilities/constants.dart' as c;
import 'package:cloud_firestore/cloud_firestore.dart' show Query;

class FeedBuilderController extends ChangeNotifier {
  List<Post> posts = [];
  final scroll = ScrollController();
  bool loading = false;
  bool end = false;
  final Query<Map<String, dynamic>> firestoreQuery;
  final Function? refreshFunction;

  FeedBuilderController(
      {required this.firestoreQuery, required this.refreshFunction}) {
    init();
  }
  init() async {
    scroll.addListener(() => _onScroll());
    await parseRawPosts(
        await locator<PostsHandling>().getPosts(null, firestoreQuery));
    notifyListeners();
  }

  _onScroll() async {
    if (!end) {
      final BuildContext context =
          NavigationService.navigatorKey.currentContext!;
      if (scroll.position.maxScrollExtent - scroll.position.pixels <=
          MediaQuery.sizeOf(context).height * 0.2) {
        if (loading == false) {
          loading = true;
          await parseRawPosts(await locator<PostsHandling>()
              .getPosts(posts.last.time, firestoreQuery));
          notifyListeners();
          loading = false;
        }
      }
    }
  }

  parseRawPosts(List<RawPostObject> rawPosts) async {
    if (rawPosts.length < c.postsOnRefresh) {
      end = true;
    }
    for (RawPostObject raw in rawPosts) {
      AppUser user = AppUser();
      await user.readUserData(raw.author, checkCurrentUser: true);
      posts.add(Post(
          username: user.username,
          profilePic: user.profileImage,
          firstName: user.firstName,
          lastName: user.lastName,
          time: raw.time,
          title: raw.title,
          body: raw.body,
          likes: raw.likes.length));
    }
  }

  Future<void> onRefresh() async {
    end = false;
    posts = [];
    await parseRawPosts(
        await locator<PostsHandling>().getPosts(null, firestoreQuery));
    if (refreshFunction != null) {
      refreshFunction!();
    }
    notifyListeners();
  }
}
