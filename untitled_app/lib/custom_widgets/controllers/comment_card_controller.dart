import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/users.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart' show Post;
//import '../../models/feed_post_cache.dart' show FeedPostCache;

class CommentCardController extends ChangeNotifier {
  BuildContext context;

  Post post;
  late int likes;
  late bool liked;
  bool liking = false;
  CommentCardController({required this.context, required this.post}) {
    liked = locator<CurrentUser>().checkIsLiked(post.postId);
    likes = post.likes;

    notifyListeners();
  }

  avatarPressed() async {
    if (post.author.uid != locator<CurrentUser>().getUID()) {
      await context.pushNamed("sub_profile", extra: post.author);
      //update post liked in sub menu
      final newvalue = locator<CurrentUser>().checkIsLiked(post.postId);
      if (liked != newvalue) {
        liked = newvalue;
        likes += newvalue ? 1 : -1;
      }
      notifyListeners();
    } else {
      context.go("/profile");
    }
  }

  tagPressed(String username) async {
    String? uid = await locator<CurrentUser>().getUidFromUsername(username);
    if (uid != null && uid != locator<CurrentUser>().getUID()) {
      // Retrieve the user's profile using the uid
      AppUser taggedUser = AppUser();
      await taggedUser.readUserData(uid);

      await context.pushNamed("sub_profile", extra: taggedUser);
      //update post liked in sub menu
      final newvalue = locator<CurrentUser>().checkIsLiked(post.postId);
      if (liked != newvalue) {
        liked = newvalue;
        likes += newvalue ? 1 : -1;
      }
      notifyListeners();
    } else {
      context.go("/profile");
    }
  }

  likePressed() async {
    if (post.author.uid != locator<CurrentUser>().getUID()) {
      if (!liking) {
        liking = true;
        liked = locator<CurrentUser>()
            .checkIsLiked(post.postId); //prevent user from double likeing

        if (liked) {
          liked = false;
          //locator<FeedPostCache>().updateLikes(post.postId, -1);
          likes--;
          notifyListeners();
          //undo if it fails. maybe remove this
          if (!await locator<CurrentUser>()
              .removeLike(post.rootPostId!, post.postId)) {
            liked = true;
            //locator<FeedPostCache>().updateLikes(post.postId, 1);
            likes++;
            notifyListeners();
          }
        } else {
          liked = true;
          //locator<FeedPostCache>().updateLikes(post.postId, 1);
          likes++;
          notifyListeners();
          //undo if it fails
          if (!await locator<CurrentUser>()
              .addLike(post.rootPostId!, post.postId)) {
            liked = false;
            //locator<FeedPostCache>().updateLikes(post.postId, -1);
            likes--;
            notifyListeners();
          }
        }

        liking = false;
      }
    }
  }
}
