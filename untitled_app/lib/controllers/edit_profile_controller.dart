import 'package:flutter/material.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profileImage;

  editProfileImagePressed() async {
    //FIXME crashes if you exit before function finishes
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      profileImage = locator<CurrentUser>().profileImage;

      notifyListeners();
    } else {}
  }
}
