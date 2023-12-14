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
          floatingActionButton: SizedBox(
                  width: 70,
                  child: FloatingActionButton.large(
                    onPressed: () =>
                        Provider.of<SubGroupController>(context, listen: false).addPost(),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add,
                        size: 40),
                  ),
                ),
          body: (Provider.of<SubGroupController>(context, listen: true).group ==
                  null)
              ? const CircularProgressIndicator()
              : PaginationPage(
                  header: const _Header(),
                  getter:
                      Provider.of<SubGroupController>(context, listen: false)
                          .getGroupPosts,
                  card: postCardBuilder,
                  startAfterQuery:
                      Provider.of<SubGroupController>(context, listen: false)
                          .getTimeFromPost),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Row(
      children: [
        IconButton(
          color: Theme.of(context).colorScheme.onBackground,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        SizedBox(
          width: width * 0.13,
          height: width * 0.13,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              Provider.of<SubGroupController>(context, listen: true)
                  .group!
                  .icon,
              //style: TextStyle(fontSize: width * 0.25),
            ),
          ),
        ),
        //const Spacer(),
        SizedBox(
            width: width * 0.6,
            child: Text(
                Provider.of<SubGroupController>(context, listen: true)
                    .group!
                    .name,
                style: TextStyle(fontSize: width * 0.06),
                overflow: TextOverflow.ellipsis)),
        const Spacer(),
        IconButton(
          onPressed: () => Provider.of<SubGroupController>(context, listen: false).editGroup(),
          icon: const Icon(Icons.create),
        ),
      ],
    );
  }
}
