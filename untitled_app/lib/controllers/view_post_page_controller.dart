import 'package:flutter/widgets.dart';
import '../utilities/constants.dart' as c;
import '../utilities/locator.dart';
import '../custom_widgets/error_snack_bar.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../models/post_handler.dart';

class PostPageController extends ChangeNotifier {
  final Post? post;
  final BuildContext context;
  String postId = "";
  String title = "";
  String body = "";
  String profilePic = "";
  String name = "";

  String username = "";
  TextEditingController commentFeild = TextEditingController();
  FocusNode commentFeildFocus = FocusNode();
  int chars = 0;
  PostPageController({required this.post, required this.context}) {
    _init();
  }
  void _init() {
    if (post != null) {
      postId = post!.postId;
      title = post!.title;
      body = post!.body;
      profilePic = post!.profilePic;
      name = post!.name;
      username = post!.username;
    }
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  updateCount(String str) {
    chars = str.length;
    notifyListeners();
  }

  //TODO add more content like a preview of a post.
  postCommentPressed() {
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
      locator<PostsHandling>().createComment({"body": commentFeild.text,"title":""}, postId);
      commentFeild.text = "";
    }
  }
}
