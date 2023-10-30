import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/error_snack_bar.dart';
import 'package:giphy_get/giphy_get.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';
import '../secrets/secrets.dart' as secrets;
import 'bottom_nav_bar_controller.dart';
import '../custom_widgets/warning_dialog.dart';

class ComposeController extends ChangeNotifier {
  final BuildContext context;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final titleFocus = FocusNode();
  final bodyFocus = FocusNode();
  int newLines = 0;
  int bodyChars = 0;
  int titleChars = 0;
  GiphyGif? gif;

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

  removeGifPressed() {
    gif = null;
    notifyListeners();
  }

  addGifPressed() async {
    locator<NavBarController>().disable();
    GiphyGif? newGif = await GiphyGet.getGif(
      context: context,
      apiKey: secrets.Secrets.GIPHY_API_KEY,
      lang: GiphyLanguage.english,
      //randomID: "abcd", // Optional - An ID/proxy for a specific user.
      tabColor: Colors.teal,
      debounceTimeInMilliseconds: 350,
    );
    //only update gif a gif was selected
    if (newGif != null) {
      gif = newGif;
    }
    notifyListeners();
    locator<NavBarController>().enable();
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
    } else if (titleController.text == "" &&
        bodyController.text == "" &&
        gif == null) {
      titleFocus.requestFocus();
      showSnackBar(
          text: AppLocalizations.of(context)!.emptyFieldError,
          context: context);
    } else {
      Map<String, dynamic> post = {};
      if (titleController.text != '') {
        post["title"] = titleController.text;
      }
      if (bodyController.text != '') {
        post["body"] = bodyController.text;
      }
      if (gif != null) {
        post["gifUrl"] = gif!.images!.fixedWidth.url;
        post["gifSource"] = gif!.url;
      }

      locator<PostsHandling>().createPost(post);
      titleController.text = "";
      bodyController.text = "";
      gif = null;
    }
  }

  void showPostDialog(BuildContext context, Function postPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to post?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                postPressed();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
