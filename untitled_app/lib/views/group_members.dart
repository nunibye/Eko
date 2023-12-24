import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/edit_group_page_controller.dart';
import 'package:untitled_app/controllers/followers_controller.dart';
import 'package:untitled_app/controllers/group_members_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/group_handler.dart';
import '../custom_widgets/searched_user_card.dart';

class GroupSettings extends StatelessWidget {
  final List<dynamic> members;
  final Group group;

  const GroupSettings({required this.members, required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
      create: (context) =>
          GroupMembersController(context: context, members: members),
      builder: (context, child) {
        GroupMembersController controller =
            Provider.of<GroupMembersController>(context);

        if (controller.membersList.isEmpty) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () => context.pop("poped"),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              // title: Text(
              //   group.name,
              //   style: TextStyle(
              //     fontWeight: FontWeight.normal,
              //     fontFamily: 'Lato',
              //     color: Theme.of(context).colorScheme.onBackground,
              //   ),
              // ),
            ),
            body: Padding(
              padding:
                  EdgeInsets.only(left: height * 0.02, right: height * 0.02),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        (group.icon != '')
                            ? SizedBox(
                                width: width * 0.4,
                                height: width * 0.4,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    group.icon,
                                    style: TextStyle(fontSize: width * 0.15),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                width: width * 0.3,
                                height: width * 0.3,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    group.name[0],
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: width * 0.15,
                                    ),
                                  ),
                                ),
                              ),
                        //FIXME: how can i get there to be less padding between the emoji and title
                        Text(
                          group.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.person_add_outlined),
                          color: Theme.of(context).colorScheme.onBackground,
                          onPressed: () {
                            Provider.of<EditGroupPageController>(context,
                                    listen: false)
                                .goForward();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications_none),
                          color: Theme.of(context).colorScheme.onBackground,
                          onPressed: () {
                            // TODO
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app_rounded),
                          color: Theme.of(context).colorScheme.onBackground,
                          onPressed: () {
                            // TODO
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return UserCard(
                          user: Provider.of<GroupMembersController>(context,
                                  listen: true)
                              .membersList[index],
                        );
                      },
                      childCount: Provider.of<GroupMembersController>(context,
                              listen: true)
                          .membersList
                          .length,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
