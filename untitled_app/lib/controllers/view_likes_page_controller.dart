import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/controllers/pagination_controller.dart';
import 'package:untitled_app/models/users.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../models/post_handler.dart';

class ViewLikesPageController extends ChangeNotifier {
  final String postId;
  ViewLikesPageController({required this.postId});

  Future<PaginationGetterReturn> getter(dynamic uid) async {
    return locator<PostsHandling>().getPostLikes(uid, postId);
  }

  dynamic startAfterQuery(dynamic user) async {
    user as AppUser;
    return user.uid;
  }
}
