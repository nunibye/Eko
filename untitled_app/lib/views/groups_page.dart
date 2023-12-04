import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/groups_page_controller.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsPageController(),
      builder: (context, child) {
        return const Center(
          child: Text("coming soon"),
        );
      },
    );
  }
}
