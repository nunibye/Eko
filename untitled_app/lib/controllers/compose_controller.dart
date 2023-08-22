import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/error_snack_bar.dart';
import '../utilities/navigation_service.dart';
import '../utilities/locator.dart';
import '../models/posts.dart';

class ComposeController extends ChangeNotifier {
  final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final titleFocus = FocusNode();
  final bodyFocus = FocusNode();
  int newLines = 0;
  int bodyChars = 0;
  int titleChars = 0;

  updateCountsBody(String str) {
    bodyChars = str.length;
    newLines = '\n'.allMatches(str).length;
    notifyListeners();
  }

  updateCountsTitle(String str) {
    titleChars = str.length;
    notifyListeners();
  }

  postPressed() {
    bodyController.text = bodyController.text.trim();
    titleController.text = titleController.text.trim();
    updateCountsBody(bodyController.text);
    updateCountsTitle(titleController.text);
    if (titleChars > c.maxTittleChars) {
      showSnackBar(text: AppLocalizations.of(_context)!.tooManyChar);
    } else if (newLines > c.maxPostLines) {
      showSnackBar(text: AppLocalizations.of(_context)!.tooManyChar);
    } else if (bodyChars > c.maxPostChars) {
      showSnackBar(text: AppLocalizations.of(_context)!.tooManyLine);
    } else if (titleController.text == "") {
      titleFocus.requestFocus();
      showSnackBar(text: AppLocalizations.of(_context)!.emptyFieldError);
    } else if (bodyController.text == "") {
      bodyFocus.requestFocus();
      showSnackBar(text: AppLocalizations.of(_context)!.emptyFieldError);
    } else {
      locator<PostsHandling>().createPost(
          {"title": titleController.text, "body": bodyController.text});
      titleController.text = "";
      bodyController.text = "";
    }
  }
}
