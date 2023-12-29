import 'package:flutter/material.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/models/users.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/utilities/locator.dart';

class SearchedUserController extends ChangeNotifier {
  final AppUser user;
  final BuildContext context;
  AppUser? loadedUser;
  late bool isFollowing;
  final bool groupSearch;
  final bool? initialBool;
  late bool added;
  TextEditingController commentFeild = TextEditingController();
  final void Function(AppUser, bool)? adder;
  SearchedUserController(
      {required this.context,
      required this.user,
      this.loadedUser,
      required this.groupSearch,
      this.adder,
      this.initialBool}) {
    _init();
  }
  void _init() {
    loadedUser = user;
    if (groupSearch) {
      added = initialBool!;
    } else {
      isFollowing = locator<CurrentUser>().checkIsFollowing(loadedUser!.uid);
    }

    notifyListeners();
  }

  void onCardPressed() {
    context.push("/sub_profile/${user.uid}", extra: user);
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

  void onAddPressed() {
    if (added) {
      adder!(user, false);
      //added = false;
    } else {
      adder!(user, true);
      //added = true;
    }
    //notifyListeners();
  }
}
