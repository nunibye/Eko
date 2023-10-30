import 'package:flutter/material.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';
import 'package:go_router/go_router.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profilePicture;
  String profileBio = locator<CurrentUser>().bio;
  final BuildContext context;
  final bioController = TextEditingController(text: locator<CurrentUser>().bio);
  final bioFocus = FocusNode();
  // int bioNewLines = '\n'.allMatches(locator<CurrentUser>().bio).length;
  // int bioBodyChars = locator<CurrentUser>().bio.length;

  final nameController =
      TextEditingController(text: locator<CurrentUser>().name);
  final nameFocus = FocusNode();
  // int bioNameBodyChars = locator<CurrentUser>().bioName.length;

  int titleChars = 0;
  bool showBioCounts = false;
  bool showBioNameCounts = false;
  EditProfileController({required this.context});
  editProfileImagePressed() async {
    //FIXME crashes if you exit before function finishes
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      profileImage = locator<CurrentUser>().profilePicture;

      notifyListeners();
    } else {}
  }

  // updateCountsBio(String str) {
  //   bioBodyChars = str.length;
  //   bioNewLines = '\n'.allMatches(str).length;
  //   notifyListeners();
  // }

  // updateCountsBioName(String str) {
  //   bioNameBodyChars = str.length;
  //   notifyListeners();
  // }
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void exitPressed() {
    context.pop("poped");
  }

  void savePressed() {
    if (locator<CurrentUser>().name != nameController.text) {
      saveNameData(nameController.text);
    }
    if (locator<CurrentUser>().bio != bioController.text) {
      saveBioData(bioController.text);
    }
    context.pop("poped");
  }

  // showCountsBio(bool show) {
  //   showBioCounts = show;
  //   if (!show) {
  //     bioFocus.unfocus();
  //   }
  //   notifyListeners();
  // }

  // showCountsName(bool show) {
  //   showBioNameCounts = show;
  //   if (!show) {
  //     nameFocus.unfocus();
  //   }
  //   notifyListeners();
  // }

  saveBioData(String bio) async {
    // TODO: This will eventually need to upload all the data that changed as profile editing gets larger
    // Im thinking a 'save' and 'cancel' button pops up on the app bar is an edit is detected
    if (await locator<CurrentUser>().uploadProfileBio(bio) == "success") {
      locator<CurrentUser>().bio = bio;
      
      
    } 
  }

  saveNameData(String name) async {
    if (await locator<CurrentUser>().uploadProfileName(name) == "success") {
      locator<CurrentUser>().name = name;
      
    }
  }
}
