import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/users.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart';
import '../../models/feed_post_cache.dart' show FeedPostCache;
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'pagination_controller.dart';
import '../../controllers/view_post_page_controller.dart';

class PostCardController extends ChangeNotifier {
  BuildContext context;
  Post post;
  late int comments;
  late int likes;
  late bool liked;
  bool liking = false;
  bool sharing = false;
  double _opacity = 0;
  double get opacity => _opacity;

  final bool isBuiltFromId;
  PostCardController(
      {required this.context,
      required this.post,
      required this.isBuiltFromId}) {
    _init();
  }
  _init() async {
    liked = locator<CurrentUser>().checkIsLiked(post.postId);

    likes = post.likes;

    comments = post.commentCount;

    ///comments = await locator<PostsHandling>().countComments(post.postId);

    notifyListeners();
  }

//FIXME could be optomized
  void rebuildFeed() {
    Provider.of<PaginationController>(context, listen: false).rebuildFunction();
  }

  postPressed() {
    context.push("/feed/post/${post.postId}", extra: post).then((v) async {
      //comments = await locator<PostsHandling>().countComments(post.postId);

      rebuildFeed();
    });
  }

  commentPressed() {
    postPressed();
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

  sharePressed() async {
    if (!sharing) {
      sharing = true;
      await Share.shareWithResult(
          'Check out my post on Echo: https://untitled-2832f.web.app/feed/post/${post.postId}');
      sharing = false;
    }
  }

  likePressed() async {
    if (post.author.uid != locator<CurrentUser>().getUID()) {
      if (!liking) {
        //set bool
        liking = true;
        //get action
        liked = locator<CurrentUser>()
            .checkIsLiked(post.postId); //prevent user from double likeing

        if (liked) {
          //set bool
          liked = false;
          //remove like
          likes--;
          //also remove from parent if not linked to cache
          if (isBuiltFromId) {
            Provider.of<PostPageController>(context, listen: false)
                .changeInternalLikes(-1);
          }
          //update cache if present
          if (post.hasCache) {
            locator<FeedPostCache>().updateLikes(post.postId, -1);
          }

          notifyListeners();
          //undo if it fails. maybe remove this
          if (!await locator<CurrentUser>().removeLike(post.postId, null)) {
            liked = true;
            likes++;
            if (isBuiltFromId) {
              Provider.of<PostPageController>(context, listen: false)
                  .changeInternalLikes(1);
            }

            if (post.hasCache) {
              locator<FeedPostCache>().updateLikes(post.postId, 1);
            }

            notifyListeners();
          }
        } else {
          // animation
          _opacity = 1;
          notifyListeners();
          Future.delayed(const Duration(milliseconds: 500), () {
            _opacity = 0;
            notifyListeners();
          });

          liked = true;
          //locator<FeedPostCache>().updateLikes(post.postId, 1);
          likes++;
          if (isBuiltFromId) {
            Provider.of<PostPageController>(context, listen: false)
                .changeInternalLikes(1);
          }

          if (post.hasCache) {
            locator<FeedPostCache>().updateLikes(post.postId, 1);
          }

          notifyListeners();
          //undo if it fails
          if (!await locator<CurrentUser>().addLike(post.postId, null)) {
            liked = false;
            //locator<FeedPostCache>().updateLikes(post.postId, -1);
            likes--;
            if (isBuiltFromId) {
              Provider.of<PostPageController>(context, listen: false)
                  .changeInternalLikes(-1);
            }

            if (post.hasCache) {
              locator<FeedPostCache>().updateLikes(post.postId, -1);
            }
            notifyListeners();
          }
        }
        //only rebuild from parent here to avoid reseting bool
        if (isBuiltFromId) {
          Provider.of<PostPageController>(context, listen: false).rebuild();
        }
        liking = false;
      }
    }
  }
}
