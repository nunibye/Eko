import 'package:flutter/cupertino.dart';
import '../models/posts.dart';
import '../models/users.dart';
import '../utilities/locator.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import '../utilities/constants.dart' as c;

class SearchPageController extends ChangeNotifier {
  List<Post> posts = [];
  final scroll = ScrollController();
  bool loading = false;
  bool end = false;

  SearchPageController() {
    init();
  }
  init() async {
    scroll.addListener(() => _onScroll());
    await parseRawPosts(await locator<PostsHandling>().getPosts(null));
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
          await parseRawPosts(
              await locator<PostsHandling>().getPosts(posts.last.time));
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
      User user = User();
      await user.getUserFromUID(raw.author);
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
    await parseRawPosts(await locator<PostsHandling>().getPosts(null));
    notifyListeners();
  }
}
