import 'package:flutter/material.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../custom_widgets/warning_dialog.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profilePicture;
  File? newProfileImage;

  //String profileBio = locator<CurrentUser>().bio;
  final BuildContext context;
  bool showSave = false;
  final bioController = TextEditingController(text: locator<CurrentUser>().bio);
  // final bioFocus = FocusNode();
  // int bioNewLines = '\n'.allMatches(locator<CurrentUser>().bio).length;
  // int bioBodyChars = locator<CurrentUser>().bio.length;

  final nameController =
      TextEditingController(text: locator<CurrentUser>().name);
  // final nameFocus = FocusNode();
  // int bioNameBodyChars = locator<CurrentUser>().bioName.length;

  int titleChars = 0;
  bool showBioCounts = false;
  bool showBioNameCounts = false;
  EditProfileController({required this.context});
  editProfileImagePressed() async {
    newProfileImage = await locator<CurrentUser>().setPreviewProfileImage();
    if (newProfileImage != null) {
      checkChanges();
      notifyListeners();
    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void checkChanges() {
    if (locator<CurrentUser>().name != nameController.text ||
        locator<CurrentUser>().bio != bioController.text ||
        newProfileImage != null) {
      showSave = true;
      notifyListeners();
    } else {
      showSave = false;
      notifyListeners();
    }
  }

  void _pop() {
    context.pop("poped");
  }

  void _popTwice() {
    _pop();
    _pop();
  }

  void _showLoadingDialog() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, __, ___) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void exitPressed() {
    showMyDialog(
        AppLocalizations.of(context)!.exitEditProfileTitle,
        AppLocalizations.of(context)!.exitEditProfileBody,
        [
          AppLocalizations.of(context)!.exit,
          AppLocalizations.of(context)!.stay
        ],
        [_popTwice, _pop],
        context);
  }

  void savePressed() async {
    if (locator<CurrentUser>().name != nameController.text) {
      await _saveNameData(nameController.text);
    }
    if (locator<CurrentUser>().bio != bioController.text) {
      await _saveBioData(bioController.text);
    }
    if (newProfileImage != null) {
      _showLoadingDialog();
      await locator<CurrentUser>().uploadProfilePicture(newProfileImage!);
      _pop();
    }
    _pop();
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

  Future<void> _saveBioData(String bio) async {
    // TODO: This will eventually need to upload all the data that changed as profile editing gets larger
    // Im thinking a 'save' and 'cancel' button pops up on the app bar is an edit is detected
    if (await locator<CurrentUser>().uploadProfileBio(bio) == "success") {
      locator<CurrentUser>().bio = bio;
    }
  }

  Future<void> _saveNameData(String name) async {
    if (await locator<CurrentUser>().uploadProfileName(name) == "success") {
      locator<CurrentUser>().name = name;
    }
  }
}
