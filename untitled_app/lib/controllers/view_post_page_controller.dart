import 'package:flutter/widgets.dart';
import '../utilities/constants.dart' as c;
import '../utilities/locator.dart';
import '../custom_widgets/error_snack_bar.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../models/post_handler.dart';

class PostPageController extends ChangeNotifier {
  final Post? passedPost;
  late Post post;
  final BuildContext context;
  final TextEditingController commentFeild = TextEditingController();
  FocusNode commentFeildFocus = FocusNode();
  int chars = 0;
  PostPageController({required this.passedPost, required this.context}) {
    _init();
  }
  void _init() {
    if (passedPost != null) {
      post = passedPost!;
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
      locator<PostsHandling>()
          .createComment({"body": commentFeild.text}, post.postId);
      commentFeild.text = "";
    }
  }
}
