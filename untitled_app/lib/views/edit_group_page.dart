import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/edit_group_page_controller.dart';
import 'package:untitled_app/controllers/group_members_controller.dart';
import 'package:untitled_app/custom_widgets/selected_user_groups.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/group_handler.dart';
import 'package:untitled_app/models/users.dart';
import 'package:untitled_app/utilities/locator.dart';
import 'package:untitled_app/views/followers.dart';
import 'package:untitled_app/views/group_members.dart';
import '../controllers/create_group_page_controller.dart';
import '../custom_widgets/edit_profile_text_field.dart';
import '../utilities/constants.dart' as c;
import 'package:go_router/go_router.dart';
import '../custom_widgets/searched_user_card.dart';

class EditGroupPage extends StatelessWidget {
  Group group;
  EditGroupPage({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          EditGroupPageController(context: context, group: group),
      builder: (context, child) {
        return WillPopScope(
            onWillPop: () =>
                Provider.of<EditGroupPageController>(context, listen: false)
                    .exitPressed(),
            child: PageView(
              physics:
                  Provider.of<EditGroupPageController>(context, listen: true)
                          .canSwipe
                      ? null
                      : const NeverScrollableScrollPhysics(),
              controller:
                  Provider.of<EditGroupPageController>(context, listen: false)
                      .pageController,
              children: [_GroupSettings(), _AddPeople()],
            ));
      },
    );
  }
}

class _GroupSettings extends StatelessWidget {
  _GroupSettings();

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
      create: (context) => GroupMembersController(
          context: context,
          members: Provider.of<EditGroupPageController>(context, listen: false)
              .getMembers()),
      builder: (context, child) {
        GroupMembersController controller =
            Provider.of<GroupMembersController>(context);
        Group group =
            Provider.of<EditGroupPageController>(context, listen: false)
                .getGroup();
        Provider.of<EditGroupPageController>(context, listen: false)
            .loadMembersList(
                Provider.of<GroupMembersController>(context, listen: false)
                    .membersList);

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
                                .initializeSearch();
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

class _AddPeople extends StatelessWidget {
  _AddPeople();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final membersList =
        Provider.of<EditGroupPageController>(context).getMembersList();
    final selectedPeople =
        Provider.of<EditGroupPageController>(context, listen: true)
            .selectedPeople;

    return GestureDetector(
      onPanDown: (details) =>
          Provider.of<EditGroupPageController>(context, listen: false)
              .hideKeyboard(),
      onTap: () => Provider.of<EditGroupPageController>(context, listen: false)
          .hideKeyboard(),
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () => Provider.of<EditGroupPageController>(context,
                          listen: false)
                      .exitPressed(),
                  child: Text(AppLocalizations.of(context)!.cancel)),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Provider.of<EditGroupPageController>(context, listen: false)
                        .updateGroupMembers(),
                child: Text(
                    SetEquality()
                            .equals(selectedPeople.toSet(), membersList.toSet())
                        ? ""
                        : AppLocalizations.of(context)!.save),
              )
            ],
          ),
          TextField(
            cursorColor: Theme.of(context).colorScheme.onBackground,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(height * 0.01),
              prefixIcon: Padding(
                padding: EdgeInsets.all(width * 0.035),
                child: Image.asset('images/algolia_logo.png',
                    width: width * 0.05, height: width * 0.05),
              ),
              hintText: AppLocalizations.of(context)!.search,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (s) =>
                Provider.of<EditGroupPageController>(context, listen: false)
                    .onSearchTextChanged(s),
            controller:
                Provider.of<EditGroupPageController>(context, listen: false)
                    .searchTextController,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 20),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            height: Provider.of<EditGroupPageController>(context, listen: true)
                    .selectedPeople
                    .isNotEmpty
                ? height * 0.05
                : 0,
            child: ListView.builder(
              controller:
                  Provider.of<EditGroupPageController>(context, listen: true)
                      .selectedPeopleScroll,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount:
                  Provider.of<EditGroupPageController>(context, listen: true)
                      .selectedPeople
                      .length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SelectedUser(
                    user: Provider.of<EditGroupPageController>(context,
                            listen: true)
                        .selectedPeople[index],
                    index: index,
                    selected: (index ==
                        Provider.of<EditGroupPageController>(context,
                                listen: true)
                            .selectedToDelete),
                    setter: Provider.of<EditGroupPageController>(context,
                            listen: false)
                        .setSelectedToDelete,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Provider.of<EditGroupPageController>(context, listen: true)
                    .isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Provider.of<EditGroupPageController>(context, listen: true)
                        .hits
                        .isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noResultsFound,
                          style: TextStyle(
                              fontSize: 18,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      )
                    : ListView.builder(
                        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: Provider.of<EditGroupPageController>(context,
                                listen: true)
                            .hits
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return UserCard(
                            initialBool: Provider.of<EditGroupPageController>(
                                    context,
                                    listen: false)
                                .isUserSelected(
                                    Provider.of<EditGroupPageController>(
                                            context,
                                            listen: true)
                                        .hits[index]),
                            adder: Provider.of<EditGroupPageController>(context,
                                    listen: false)
                                .addRemovePersonToList,
                            groupSearch: true,
                            user: Provider.of<EditGroupPageController>(context,
                                    listen: true)
                                .hits[index],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
