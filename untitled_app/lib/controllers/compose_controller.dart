import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/error_snack_bar.dart';
import 'package:giphy_get/giphy_get.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';

class ComposeController extends ChangeNotifier {
  final BuildContext context;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final titleFocus = FocusNode();
  final bodyFocus = FocusNode();
  int newLines = 0;
  int bodyChars = 0;
  int titleChars = 0;

  ComposeController({required this.context});

  updateCountsBody(String str) {
    bodyChars = str.length;
    newLines = '\n'.allMatches(str).length;
    notifyListeners();
  }


  updateCountsTitle(String str) {
    titleChars = str.length;
    notifyListeners();
  }
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  

//TODO add more content like a preview of a post.
  postPressed() {
    bodyController.text = bodyController.text.trim();
    titleController.text = titleController.text.trim();
    updateCountsBody(bodyController.text);
    updateCountsTitle(titleController.text);
    if (titleChars > c.maxTittleChars) {
      showSnackBar(
          text: AppLocalizations.of(context)!.tooManyChar, context: context);
    } else if (newLines > c.maxPostLines) {
      
      showSnackBar(
          text: AppLocalizations.of(context)!.tooManyLine, context: context);
    } else if (bodyChars > c.maxPostChars) {
      showSnackBar(
          text: AppLocalizations.of(context)!.tooManyChar, context: context);
    } else if (titleController.text == "") {
      titleFocus.requestFocus();
      showSnackBar(
          text: AppLocalizations.of(context)!.emptyFieldError,
          context: context);
    } else if (bodyController.text == "") {
      bodyFocus.requestFocus();
      showSnackBar(
          text: AppLocalizations.of(context)!.emptyFieldError,
          context: context);
    } else {
      locator<PostsHandling>().createPost(
          {"title": titleController.text, "body": bodyController.text});
      titleController.text = "";
      bodyController.text = "";
    }
  }
}
