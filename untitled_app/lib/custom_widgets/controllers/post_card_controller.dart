import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart' show Post;

class PostCardController extends ChangeNotifier{
  BuildContext context;
  Post post;
  PostCardController({required this.context, required this.post});

  iconPressed() {
    if (post.uid != locator<CurrentUser>().getUID()) {
      context.goNamed("sub_profile", extra: post);
    }
  }
}
