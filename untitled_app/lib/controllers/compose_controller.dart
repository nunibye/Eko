import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/current_user.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/error_snack_bar.dart';
import 'package:giphy_get/giphy_get.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';
import '../secrets/secrets.dart' as secrets;
import 'bottom_nav_bar_controller.dart';
import '../custom_widgets/post_card.dart';
import "package:go_router/go_router.dart";
import 'package:untitled_app/models/feed_post_cache.dart';
import '../models/users.dart' show AppUser;
import '../controllers/bottom_nav_bar_controller.dart';

class ComposeController extends ChangeNotifier {
  final BuildContext context;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final titleFocus = FocusNode();
  final bodyFocus = FocusNode();
  int newLines = 0;
  int bodyChars = 0;
  int titleChars = 0;
  bool showCount0 = false;
  bool showCount1 = false;
  GiphyGif? gif;

  ComposeController({required this.context}) {
    titleFocus.addListener(onTitleFocusChanged);
    bodyFocus.addListener(onBodyFocusChanged);
  }
  void onTitleFocusChanged() {
    if (titleFocus.hasFocus) {
      showCount0 = true;
    } else {
      showCount0 = false;
    }
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    locator<NavBarController>().goBranch(0);
    return false;
  }

  void onBodyFocusChanged() {
    if (bodyFocus.hasFocus) {
      showCount1 = true;
    } else {
      showCount1 = false;
    }
    notifyListeners();
  }

  // changeDisplayCount(bool value, int index) {
  //   if (index == 0) {
  //     showCount0 = value;
  //   } else {
  //     showCount1 = value;
  //   }
  //   notifyListeners();
  // }

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

  clearPressed() {
    hideKeyboard();
    gif = null;
    newLines = 0;
    bodyChars = 0;
    titleChars = 0;
    showCount0 = false;
    showCount1 = false;
    titleController.text = "";
    bodyController.text = "";
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
  postPressed(BuildContext context) {
    bodyController.text = bodyController.text.trim();
    titleController.text = titleController.text.trim();
    updateCountsBody(bodyController.text);
    updateCountsTitle(titleController.text);
    if (titleChars > c.maxTitleChars) {
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
      post["tags"] = ["public"];
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
      void popAndGo(BuildContext context) {
        context.pop();
        context.go("/feed", extra: true);
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(AppLocalizations.of(context)!.confirmation),
            content: SingleChildScrollView(
              child: PostCard(
                  post: Post(
                      tags: ["public"],
                      gifSource: post["gifSource"],
                      gifURL: post["gifUrl"],
                      postId: "postId",
                      time: "", //DateTime.now().toUtc().toIso8601String(),
                      title: post["title"],
                      author: AppUser.fromCurrent(locator<CurrentUser>()),
                      body: post["body"],
                      likes: 0),
                  isPreview: true),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  context.pop();
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.post),
                onPressed: () async {
                  final postID =
                      await locator<PostsHandling>().createPost(post);
                  locator<FeedPostCache>().addPost(
                      2,
                      Post(
                          tags: ["public"],
                          gifSource: post["gifSource"],
                          gifURL: post["gifUrl"],
                          postId: postID,
                          time: DateTime.now().toUtc().toIso8601String(),
                          title: post["title"],
                          author: locator<CurrentUser>(),
                          body: post["body"],
                          likes: 0));

                  titleController.text = "";
                  bodyController.text = "";
                  gif = null;
                  popAndGo(context);
                  notifyListeners();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
