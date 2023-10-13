import 'package:flutter/widgets.dart';
import '../models/post_handler.dart' show Post;
import '../models/current_user.dart';
import '../utilities/locator.dart';

class PostPageController extends ChangeNotifier {
  final Post? post;
  String title = "";
  String body = "";

  PostPageController({required this.post}) {
    _init();
  }
  void _init() {
    if (post != null) {
      title = post!.title;
      body = post!.body;
    }
  }
}
