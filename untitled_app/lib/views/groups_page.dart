import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/groups_page_controller.dart';
import '../custom_widgets/pagination.dart';
import '../custom_widgets/group_card.dart';
import '../utilities/constants.dart' as c;
//import 'package:cloud_firestore/cloud_firestore.dart';

// void addTagToDocuments() async {
//   final collection = FirebaseFirestore.instance.collection('posts');
//   final snapshots = collection.snapshots();

//   snapshots.listen((snapshot) {
//     snapshot.docs.forEach((doc) {
//       print(doc.id);
//       doc.reference.update({'tags': ['public']});
//       doc.reference.update({'tag': FieldValue.delete()});
//     });
//   });
// }

class GroupsPage extends StatelessWidget {
  final bool rebuild;
  const GroupsPage({super.key, this.rebuild = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsPageController(context: context, rebuild: rebuild),
      builder: (context, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) =>
              Provider.of<GroupsPageController>(context, listen: false)
                  .onWillPop(),
          child: Scaffold(
            body: PaginationPage(
              getter: Provider.of<GroupsPageController>(context, listen: false)
                  .getGroups,
              card: groupCardBuilder,
              startAfterQuery:
                  Provider.of<GroupsPageController>(context, listen: false)
                      .getTimeFromGroup,
              appbar: SliverAppBar(
                title: Text(AppLocalizations.of(context)!.groups),
                centerTitle: true,
                floating: true,
                pinned: false,
                scrolledUnderElevation: 0.0,
                backgroundColor: Theme.of(context).colorScheme.background,
                actions: [
                  IconButton(
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: () => Provider.of<GroupsPageController>(context,
                            listen: false)
                        .createGroupPressed(),
                    icon: const Icon(Icons.group_add),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(3),
                  child: Divider(
                    color: Theme.of(context).colorScheme.outline,
                    height: c.dividerWidth,
                  ),
                ),
              ),
              //header: const _Header(),
            ),
          ),
        );
      },
    );
  }
}
