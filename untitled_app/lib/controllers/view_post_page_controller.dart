import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/custom_widgets/login_text_feild.dart';
import 'package:untitled_app/custom_widgets/warning_dialog.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/models/group_handler.dart';
import 'package:untitled_app/utilities/themes/dark_theme_provider.dart';
import '../models/search_model.dart';
import '../models/users.dart';
import '../utilities/constants.dart' as c;
import '../utilities/locator.dart';
import '../custom_widgets/error_snack_bar.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../models/post_handler.dart';
import 'package:go_router/go_router.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;
import '../models/feed_post_cache.dart';
import 'bottom_nav_bar_controller.dart';
import '../secrets/secrets.dart' as s;

class PostPageController extends ChangeNotifier {
  final Post? passedPost;
  Post? post;

  bool loading = true;
  final String id;
  final BuildContext context;
  final TextEditingController commentFeild = TextEditingController();
  FocusNode commentFeildFocus = FocusNode();
  int chars = 0;
  bool isAtSymbolTyped = false;
  bool isLoading = false;
  bool postNotFound = false;
  List<AppUser> hits = [];
  Timer? _debounce;
  GiphyGif? gif;
  final reportFocus = FocusNode();
  final reportController = TextEditingController();

  bool builtFromID = false;
  PostPageController({
    required this.passedPost,
    required this.context,
    required this.id,
  }) {
    _init();
  }
  void _init() async {
    if (passedPost != null) {
      post = passedPost!;
      notifyListeners();
    } else {
      if (post == null) {
        final readPost = await locator<PostsHandling>().getPostFromId(id);
        if (readPost != null) {
          if (readPost.tags.contains("public")) {
            post = readPost;
            builtFromID = true;
            post!.hasCache = true;
          } else {
            final group =
                await GroupHandler().getGroupFromId(readPost.tags.first);
            if (group != null &&
                group.members.contains(locator<CurrentUser>().getUID())) {
              post = readPost;
              builtFromID = true;
              post!.hasCache = false;
            } else {
              postNotFound = true;
            }
          }
        } else {
          postNotFound = true;
        }
      }

      notifyListeners();
    }
    if (!isLoggedIn()) {
      locator<NavBarController>().disable();
    }
  }

  bool isLoggedIn() {
    if (locator<CurrentUser>().getUID() == '') {
      return false;
    }
    return true;
  }

  dynamic getTimeFromPost(dynamic post) {
    return locator<PostsHandling>().getTimeFromPost(post);
  }

  void showLogInDialog() {
    showMyDialog(
        AppLocalizations.of(context)!.logIntoApp,
        AppLocalizations.of(context)!.logInRequired,
        [
          AppLocalizations.of(context)!.goBack,
          AppLocalizations.of(context)!.signIn
        ],
        [_pop, _goToLogin],
        context,
        dismissable: true);
  }

  void _pop() {
    context.pop();
  }

  void _goToLogin() {
    context.go('/');
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateCount(String str) {
    chars = str.length;
    //notifyListeners();j
  }

  void _deletePostFromDialog() {
    locator<PostsHandling>().deleteData("posts/${post!.postId}");
    _pop();
    _pop();
  }

  void deletePressed() {
    if (DateTime.parse(post!.time)
        .toLocal()
        .add(const Duration(hours: 48))
        .difference(DateTime.now())
        .isNegative) {
      //delete
      showMyDialog(
          AppLocalizations.of(context)!.deletePostWarningTitle,
          AppLocalizations.of(context)!.deletePostWarningBody,
          [
            AppLocalizations.of(context)!.cancel,
            AppLocalizations.of(context)!.delete
          ],
          [_pop, _deletePostFromDialog],
          context);
    } else {
      //too early
      showMyDialog(
          AppLocalizations.of(context)!.tooEarlyDeleteTitle,
          AppLocalizations.of(context)!.tooEarlyDeleteBody,
          [AppLocalizations.of(context)!.ok],
          [_pop],
          context);
    }
  }

  void reportPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final height = MediaQuery.sizeOf(context).height;
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            AppLocalizations.of(context)!.reportDetails,
            style: const TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.5),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                focusNode: reportFocus,

                // onChanged: (s) {
                //   Provider.of<ComposeController>(context, listen: false)
                //       .updateCountsBody(s);
                //   Provider.of<ComposeController>(context, listen: false)
                //       .checkAtSymbol(s);
                // },
                controller: reportController,

                maxLines: null,
                maxLength: 300,
                cursorColor: Theme.of(context).colorScheme.onBackground,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onBackground),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(height * 0.01),
                  hintText: AppLocalizations.of(context)!.addText,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  //border: InputBorder.none,
                ),
              ),
            ),

            //  CustomInputFeild(
            //   focus: reportFocus,
            //   label: AppLocalizations.of(context)!.comments,
            //   controller: reportController,
            //   inputType: TextInputType.multiline,
            // ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                _pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.send),
              onPressed: () async {
                final message = reportController.text.trim();
                if (message != "") {
                  reportController.text = "";
                  await locator<PostsHandling>()
                      .addReport(post: post!, message: message);
                  _pop();
                } else {
                  showSnackBar(
                      context: context,
                      text: AppLocalizations.of(context)!.commentRequired);
                }
                //resetPassword(countryCode);
              },
            ),
          ],
        );
      },
    );
  }

  void checkAtSymbol(String text) {
    bool wasAtSymbolTyped = isAtSymbolTyped;
    int start = text.lastIndexOf('@');
    if (start != -1 && start < text.length - 1) {
      int end = text.indexOf(' ', start);
      if (end == -1) {
        // No space found after '@'
        isAtSymbolTyped = true;
        onSearchTextChanged(text.substring(start + 1));
      } else if (text.substring(end).contains('@')) {
        // Another '@' found after space
        isAtSymbolTyped = true;
        onSearchTextChanged(text.substring(start + 1, end));
      } else {
        // Space found after '@' and no other '@' found
        isAtSymbolTyped = false;
      }
    } else {
      isAtSymbolTyped = false;
    }
    if (wasAtSymbolTyped != isAtSymbolTyped) {
      notifyListeners();
    }
  }

  void updateTextField(
      String username, TextEditingController controller, FocusNode focus) {
    if (focus.hasFocus) {
      String currentText = controller.text;
      int atSymbolIndex = currentText.lastIndexOf('@');
      if (atSymbolIndex != -1) {
        String newText =
            '${currentText.substring(0, atSymbolIndex)}@$username ';
        controller.text = newText;
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: newText.length));
      }
      isAtSymbolTyped = false;
      notifyListeners();
    }
  }

  void onSearchTextChanged(String s) async {
    if (s == '') {
      hits = [];

      isLoading = false;
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce =
        Timer(const Duration(milliseconds: c.searchPageDebounce), () async {
      if (s != '') {
        hits = await SearchModel().hitsQuery(s);
        isLoading = false;
        notifyListeners();
      }
    });
  }

  replyPressed(String username) {
    commentFeildFocus.requestFocus();
    commentFeild.text = ('@$username ');
  }

  void onExitPressed() {
    context.pop();
  }

  void changeInternalLikes(int amount) {
    post!.likes += amount;
    //notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }

  Future<PaginationGetterReturn> getCommentsFromPost(dynamic time) async {
    return locator<PostsHandling>().getCommentPosts(time, post!.postId);
  }

  //TODO add more content like a preview of a post.
  Future<void> postCommentPressed() async {
    if (gif == null) {
      commentFeild.text = commentFeild.text.trim();
      updateCount(commentFeild.text);

      if (chars > c.maxCommentChars) {
        showSnackBar(
            text: AppLocalizations.of(context)!.tooManyChar, context: context);
      } else if (commentFeild.text == "") {
        commentFeildFocus.requestFocus();
        showSnackBar(
            text: AppLocalizations.of(context)!.emptyFieldError,
            context: context);
      } else {
        String comment = commentFeild.text;
        commentFeild.text = "";
        hideKeyboard();
        await locator<PostsHandling>().createComment(
            {"body": comment}, post!.postId, post!.author.uid, post!.postId);
        // int tempComments = post!.commentCount;
        // print(tempComments);
        if (post!.hasCache) {
          locator<FeedPostCache>().updateComments(post!.postId, 1);
          if (builtFromID) {
            post!.commentCount++;
          }
        } else {
          post!.commentCount++;
        }
        notifyListeners();
      }
    } else {
      await locator<PostsHandling>().createComment(
          {"gifUrl": gif!.images!.fixedWidth.url, "gifSource": gif!.url},
          post!.postId,
          post!.author.uid,
          post!.postId);
      if (post!.hasCache) {
        locator<FeedPostCache>().updateComments(post!.postId, 1);
        if (builtFromID) {
          post!.commentCount++;
        }
      } else {
        post!.commentCount++;
      }
      gif = null;
      notifyListeners();
    }
  }

  addGifPressed() async {
    locator<NavBarController>().disable();
    GiphyGif? newGif = await GiphyGet.getGif(
      context: context,
      apiKey: s.GIPHY_API_KEY,
      lang: GiphyLanguage.english,
      //randomID: "abcd", // Optional - An ID/proxy for a specific user.
      tabColor: Colors.teal,
      debounceTimeInMilliseconds: 350,
    );
    //only update gif a gif was selected
    if (newGif != null) {
      gif = newGif;
      postCommentPressed();
    }
    notifyListeners();
    locator<NavBarController>().enable();
  }
}
