import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/utilities/locator.dart';
import 'bottom_nav_bar_controller.dart';

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
}
