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
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsPageController(context: context),
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

// class _Header extends StatelessWidget {
//   const _Header();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.background,
//       height: MediaQuery.sizeOf(context).height * 0.075,
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               AppLocalizations.of(context)!.groups,
//               style: const TextStyle(fontSize: 25),
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // IconButton(
//                 //   onPressed: () {

//                 //     //addTagToDocuments();
//                 //   },
//                 //   icon: const Icon(Icons.waving_hand_rounded),
//                 // ),
//                 IconButton(
//                   onPressed: () =>
//                       Provider.of<GroupsPageController>(context, listen: false)
//                           .createGroupPressed(),
//                   icon: const Icon(Icons.group_add),
//                 ),
//                 const SizedBox(width: 8)
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
