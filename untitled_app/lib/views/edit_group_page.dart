import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/edit_group_page_controller.dart';
import 'package:untitled_app/custom_widgets/selected_user_groups.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/group_handler.dart';
import 'package:untitled_app/views/followers.dart';
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
      create: (context) => EditGroupPageController(context: context, group: group),
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

  // @override
  // Widget build(BuildContext context) {
  //   final width = MediaQuery.sizeOf(context).width;
  //   final height = MediaQuery.sizeOf(context).height;
  //   return Scaffold(
  //     body: Column(
  //       children: [
  //         Row(
  //           children: [
  //             TextButton(
  //                 onPressed: () => Provider.of<EditGroupPageController>(
  //                         context,
  //                         listen: false)
  //                     .exitPressed(),
  //                 child: Text(AppLocalizations.of(context)!.cancel)),
  //             const Spacer(),
  //             TextButton(
  //                 onPressed: () => Provider.of<EditGroupPageController>(
  //                         context,
  //                         listen: false)
  //                     .goForward(),
  //                 child: Text(AppLocalizations.of(context)!.next))
  //           ],
  //         ),
  //         IconButton(
  //           //iconSize: width * 0.2,
  //           onPressed: () =>
  //               Provider.of<EditGroupPageController>(context, listen: false)
  //                   .pickEmoji(),
  //           icon: (Provider.of<EditGroupPageController>(context, listen: true)
  //                       .icon ==
  //                   "")
  //               ? Icon(Icons.add_reaction_outlined, size: width * 0.3)
  //               : FittedBox(
  //                   fit: BoxFit.scaleDown,
  //                   child: Stack(
  //                     alignment: Alignment.topRight,
  //                     children: [
  //                       SizedBox(
  //                         width: width * 0.3,
  //                         height: width * 0.3,
  //                         child: FittedBox(
  //                           fit: BoxFit.contain,
  //                           child: Text(
  //                             Provider.of<EditGroupPageController>(context,
  //                                     listen: true)
  //                                 .icon,
  //                             //style: TextStyle(fontSize: width * 0.25),
  //                           ),
  //                         ),
  //                       ),
  //                       IconButton(
  //                         //iconSize: width * 0.1,
  //                         onPressed: () =>
  //                             Provider.of<EditGroupPageController>(context,
  //                                     listen: false)
  //                                 .clearIcon(),
  //                         icon: DecoratedBox(
  //                           decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color:
  //                                   Theme.of(context).colorScheme.background),
  //                           child: Icon(
  //                             Icons.cancel,
  //                             color: Theme.of(context).colorScheme.onBackground,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //         ),
  //         ProfileInputFeild(
  //             onChanged: (s) =>
  //                 Provider.of<EditGroupPageController>(context, listen: false)
  //                     .updateCanSwipe(),
  //             focus:
  //                 Provider.of<EditGroupPageController>(context, listen: false)
  //                     .nameFocus,
  //             maxLength: c.maxGroupName,
  //             width: width * 0.9,
  //             label: AppLocalizations.of(context)!.name,
  //             controller:
  //                 Provider.of<EditGroupPageController>(context, listen: false)
  //                     .nameController),
  //         ProfileInputFeild(
  //             maxLength: c.maxGroupDesc,
  //             width: width * 0.9,
  //             label: AppLocalizations.of(context)!.description,
  //             controller:
  //                 Provider.of<EditGroupPageController>(context, listen: false)
  //                     .descriptionController),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Followers(followers: Provider.of<EditGroupPageController>(context, listen: false)
              .getMembers());
  }
}

class _AddPeople extends StatelessWidget {
  const _AddPeople();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
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
                        .createGroup(),
                child: Text(
                    Provider.of<EditGroupPageController>(context, listen: true)
                            .selectedPeople
                            .isEmpty
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
