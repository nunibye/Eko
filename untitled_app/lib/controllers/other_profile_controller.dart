import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/users.dart';
import '../models/current_user.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'

    show PaginationGetterReturn;

class OtherProfileController extends ChangeNotifier {
  final BuildContext context;
  final AppUser? passedUser;
  final String id;

  AppUser? loadedUser;
  late bool isFollowing;

  OtherProfileController({
    required this.context,
    required this.passedUser,
    this.loadedUser,
    required this.id,
  }) {
    _init();
  }
  void _init() async {
    if (passedUser != null) {
      loadedUser = passedUser!;
    } else {
      AppUser user = AppUser();
      await user.readUserData(id);
      loadedUser = user;
    }
    if (loadedUser!.uid == locator<CurrentUser>().getUID()) {
      context.go("/profile");
    }
    isFollowing = locator<CurrentUser>().checkIsFollowing(loadedUser!.uid);
    notifyListeners();
  }

  onFollowPressed() async {
    if (loadedUser!.username != "") {
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
