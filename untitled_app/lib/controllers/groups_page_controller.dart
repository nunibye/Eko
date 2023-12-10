import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/utilities/locator.dart';
import 'bottom_nav_bar_controller.dart';
import '../models/group_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;

class GroupsPageController extends ChangeNotifier {
  final BuildContext context;
  GroupsPageController({required this.context});
  void createGroupPressed() {
    context.push("/groups/create_group");
  }

  Future<bool> onWillPop() async {
    locator<NavBarController>().goBranch(0);
    return false;
  }

  Future<PaginationGetterReturn> getGroups(dynamic time) {
    return GroupHandler().getGroups(time);
  }

  dynamic getTimeFromGroup(dynamic group) {
    return (group as Group).lastActivity;
  }
}
