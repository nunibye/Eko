import 'package:flutter/material.dart';
import 'package:untitled_app/models/users.dart';

class GroupMembersController extends ChangeNotifier {
  final BuildContext context;
  final List<dynamic> members;
  List<AppUser> membersList = [];
  bool _isInitUserRunning = false;

  GroupMembersController({
    required this.context,
    required this.members,
  }) {
    initUser();
  }

  Future<void> initUser() async {
    if (_isInitUserRunning) {
      return;
    }
    _isInitUserRunning = true;
    membersList.clear();
    for (var uid in members) {
      AppUser user = AppUser();
      Map<String, dynamic>? userData = await user.readUserData(uid);
      if (userData != null) {
        membersList.add(AppUser.fromJson(userData));
      }
    }
    _isInitUserRunning = false;
    notifyListeners();
  }
}
