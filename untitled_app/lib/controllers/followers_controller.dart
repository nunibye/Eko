import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/controllers/pagination_controller.dart';
import 'package:untitled_app/models/users.dart';
import '../utilities/constants.dart' as c;

class FollowersController extends ChangeNotifier {
  final BuildContext context;
  final AppUser rootUser;
  // List<AppUser> followersList = [];
  // bool _isInitUserRunning = false;

  FollowersController({
    required this.context,
    required this.rootUser,
  });

  Future<PaginationGetterReturn> userGetter(dynamic passedIndex) async {
    List<AppUser> returnList = [];
    int startIndex = passedIndex ?? 0;
    final bool end = (rootUser.followers.length < startIndex + c.usersOnSearch);

    for (int i = startIndex;
        i <
            (end
                ? (rootUser.followers.length)
                : (startIndex + c.usersOnSearch));
        i++) {
      AppUser user = AppUser(pageIndex: i);
      await user.readUserData(rootUser.followers[i]);
      returnList.add(user);
    }
    return PaginationGetterReturn(payload: returnList, end: end);
  }

  dynamic startAfterQuery(dynamic user) {
    user as AppUser;
    return user.pageIndex;
  }

  // Future<void> initUser() async {
  //   if (_isInitUserRunning) {
  //     return;
  //   }
  //   _isInitUserRunning = true;
  //   followersList.clear();
  //   for (var uid in followers) {
  //     AppUser user = AppUser();
  //     Map<String, dynamic>? userData = await user.readUserData(uid);
  //     if (userData != null) {
  //       followersList.add(AppUser.fromJson(userData));
  //     }
  //   }
  //   _isInitUserRunning = false;
  //   notifyListeners();
  // }
}
