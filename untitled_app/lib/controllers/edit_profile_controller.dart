import 'package:flutter/material.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profileImage;

  final bioController = TextEditingController(text: locator<CurrentUser>().bio);
  final bioFocus = FocusNode();
  int bioNewLines = '\n'.allMatches(locator<CurrentUser>().bio).length;
  int bioBodyChars = locator<CurrentUser>().bio.length;
  int titleChars = 0;
  bool showBioCounts = false;

  editProfileImagePressed() async {
    //FIXME crashes if you exit before function finishes
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      profileImage = locator<CurrentUser>().profileImage;

      notifyListeners();
    } else {}
  }

  updateCountsBody(String str) {
    bioBodyChars = str.length;
    bioNewLines = '\n'.allMatches(str).length;
    notifyListeners();
  }

  showCountsBody(bool show) {
    print(bioNewLines);
    showBioCounts = show;
    if (!show) {
      bioFocus.unfocus();
    }
    notifyListeners();
  }

  //TODO: will implement it updating database
}
