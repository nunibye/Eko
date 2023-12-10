import 'package:flutter/material.dart';
import '../models/group_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/sub_group_controller.dart';
import '../custom_widgets/pagination.dart';
import '../custom_widgets/post_card.dart';

class SubGroupPage extends StatelessWidget {
  final Group? group;
  final String id;
  const SubGroupPage({super.key, required this.group, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            SubGroupController(passedGroup: group, context: context, id: id),
        builder: (context, child) {
          return Scaffold(
            body:
                (Provider.of<SubGroupController>(context, listen: true).group ==
                        null)
                    ? const CircularProgressIndicator()
                    : PaginationPage(
                        header: const _Header(),
                        getter: Provider.of<SubGroupController>(context, listen: false).getGroupPosts,
                        card: postCardBuilder,
                        startAfterQuery: Provider.of<SubGroupController>(context, listen: false).getTimeFromPost),
          );
        });
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        const Spacer(),
        Text(
            Provider.of<SubGroupController>(context, listen: true).group!.name),
        const Spacer(),
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.create),
        ),
      ],
    );
  }
}
