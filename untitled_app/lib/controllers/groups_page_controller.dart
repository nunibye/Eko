import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupsPageController extends ChangeNotifier {
  final BuildContext context;
  GroupsPageController({required this.context});
  void createGroupPressed() {
    context.push("/groups/create_group");
  }
}
