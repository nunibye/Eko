import 'package:flutter/material.dart';
import '../locator.dart';
import '../models/current_user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profileImage;

  editProfileImagePressed() async {
    //FIXME crashes if you exit before function finishes
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      profileImage = locator<CurrentUser>().profileImage;
      print("good");
      notifyListeners();
    } else {
      print("fail");
    }
  }
}
