import 'dart:async';

import 'package:flutter/widgets.dart';
import '../models/current_user.dart';
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
  bool isUsernameFinished = false;
  bool isLoading = false;
  List<AppUser> hits = [];
  Timer? _debounce;

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
      post ??= (await locator<PostsHandling>()
          .getPostFromId(id))!; //FIXME might break if opening deleted post
      builtFromID = true;
      post!.hasCache = true;
      notifyListeners();
    }
  }

  dynamic getTimeFromPost(dynamic post) {
    return locator<PostsHandling>().getTimeFromPost(post);
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateCount(String str) {
    chars = str.length;
    //notifyListeners();j
  }

  void checkAtSymbol(String text) {
    if (text.contains('@')) {
      int start = text.indexOf('@');
      int end = text.indexOf(' ', start);
      if (end == -1) {
        // No space found after '@'
        isAtSymbolTyped = true;
        isUsernameFinished = false;
        onSearchTextChanged(text.substring(start + 1));
        notifyListeners();
      } else {
        // Space found after '@'
        isAtSymbolTyped = false;
        isUsernameFinished = true;
        onSearchTextChanged(text.substring(start + 1, end));
        notifyListeners();
      }
    } else {
      isAtSymbolTyped = false;
      isUsernameFinished = false;
    }
  }

  void updateTextField(String username) {
    String currentText = commentFeild.text;
    int atSymbolIndex = currentText.lastIndexOf('@');
    if (atSymbolIndex != -1) {
      String newText = '${currentText.substring(0, atSymbolIndex)}@$username ';
      commentFeild.text = newText;
      commentFeild.selection =
          TextSelection.fromPosition(TextPosition(offset: newText.length));
    }
    isAtSymbolTyped = false;
    isUsernameFinished = true;
    notifyListeners();
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
  void postCommentPressed() {
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
      locator<PostsHandling>().createComment({"body": commentFeild.text},
          post!.postId, post!.author.uid, post!.postId);
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
      commentFeild.text = "";
      notifyListeners();
    }
  }
}
