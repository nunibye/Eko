import 'package:flutter/widgets.dart';
import 'package:untitled_app/models/users.dart';
import '../models/current_user.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;

class OtherProfileController extends ChangeNotifier {
  final BuildContext context;
  final AppUser? user;
  AppUser? loadedUser;
  late bool isFollowing;

  OtherProfileController(
      {required this.context, required this.user, this.loadedUser}) {
    _init();
  }
  void _init() {
    if (user != null) {
      loadedUser = user!;
    }
    isFollowing = locator<CurrentUser>().checkIsFollowing(loadedUser!.uid);

    notifyListeners();
  }

  onFollowPressed() async {
    if (isFollowing) {
      if (await locator<CurrentUser>().removeFollower(loadedUser!.uid)) {
        isFollowing = false;
        loadedUser!.followers.remove(locator<CurrentUser>().uid);
      }
    } else {
      if (await locator<CurrentUser>().addFollower(loadedUser!.uid)) {
        isFollowing = true;
        loadedUser!.followers.add(locator<CurrentUser>().uid);
      }
    }
    notifyListeners();
  }

  dynamic getTimeFromPost(dynamic post) {
    return locator<PostsHandling>().getTimeFromPost(post);
  }

  Future<PaginationGetterReturn> getPosts(dynamic time) {
    return locator<PostsHandling>().getSubProfilePosts(time, loadedUser!);
  }

  onPageRefresh() {
    //TODO Add code to pull user data from database
  }
}
