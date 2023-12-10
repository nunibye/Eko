import 'package:flutter/material.dart';
import 'package:untitled_app/models/group_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;
    import '../utilities/locator.dart';
    import '../models/post_handler.dart';

class SubGroupController extends ChangeNotifier {
  final Group? passedGroup;
  Group? group;
  final String id;
  final BuildContext context;
  SubGroupController({
    required this.passedGroup,
    required this.context,
    required this.id,
  }) {
    _init();
  }
  Future<PaginationGetterReturn> getGroupPosts(dynamic time) {
    return locator<PostsHandling>().getGroupPosts(time, id);
  }

  dynamic getTimeFromPost(dynamic post) {
    return locator<PostsHandling>().getTimeFromPost(post);
  }
  Future<void> _init()async{
    if (passedGroup != null) {
      group = passedGroup!;
      notifyListeners();
    }else{
      group ??= await GroupHandler().getGroupFromId(id); //FIXME might break if opening deleted group
      // builtFromID = true;
      // post!.hasCache = true;
      notifyListeners();
    }

  }
}
