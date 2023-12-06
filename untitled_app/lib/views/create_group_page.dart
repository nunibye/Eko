import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/create_group_page_controller.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateGroupPageController(),
      builder: (context, child) {
        return const Placeholder();
      },
    );
  }
}
