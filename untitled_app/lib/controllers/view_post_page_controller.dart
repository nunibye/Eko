import 'package:flutter/widgets.dart';
import '../utilities/constants.dart' as c;
import '../utilities/locator.dart';
import '../custom_widgets/error_snack_bar.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../models/post_handler.dart';
import 'package:go_router/go_router.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;

class PostPageController extends ChangeNotifier {
  final Post? passedPost;
  Post? post;

  bool loading = true;
  final String id;
  final BuildContext context;
  final TextEditingController commentFeild = TextEditingController();
  FocusNode commentFeildFocus = FocusNode();
  int chars = 0;
  PostPageController(
      {required this.passedPost, required this.context, required this.id}) {
    _init();
  }
  void _init() async {
    if (passedPost != null) {
      post = passedPost!;
      notifyListeners();
    } else {
      post ??= (await locator<PostsHandling>()
          .getPostFromId(id))!; //FIXME might break if opening deleted post
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
    //notifyListeners();
  }

  void onExitPressed() {
    context.pop();
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
      locator<PostsHandling>().createComment(
          {"body": commentFeild.text}, post!.postId, post!.author.uid);
      // locator<FeedPostCache>().updateComments(post!.postId, 1);
      // notifyListeners();

      commentFeild.text = "";
      notifyListeners();
    }
  }
}
