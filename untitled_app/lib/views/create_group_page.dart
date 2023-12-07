import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/custom_widgets/selected_user_groups.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/create_group_page_controller.dart';
import '../custom_widgets/edit_profile_text_field.dart';
import '../utilities/constants.dart' as c;
import 'package:go_router/go_router.dart';
import '../custom_widgets/searched_user_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateGroupPageController(context: context),
      builder: (context, child) {
        return PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller:
              Provider.of<CreateGroupPageController>(context, listen: false)
                  .pageController,
          children: const [_GetInfo(), _AddPeople()],
        );
      },
    );
  }
}

class _GetInfo extends StatelessWidget {
  const _GetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () => context.pop(),
                  child: Text(AppLocalizations.of(context)!.cancel)),
              const Spacer(),
              TextButton(
                  onPressed: () => Provider.of<CreateGroupPageController>(
                          context,
                          listen: false)
                      .goForward(),
                  child: Text(AppLocalizations.of(context)!.next))
            ],
          ),
          IconButton(
            //iconSize: width * 0.2,
            onPressed: () =>
                Provider.of<CreateGroupPageController>(context, listen: false)
                    .pickEmoji(),
            icon: (Provider.of<CreateGroupPageController>(context, listen: true)
                        .icon ==
                    "")
                ? Icon(Icons.add_reaction_outlined, size: width * 0.3)
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SizedBox(
                            width: width * 0.3,
                            height: width * 0.3,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                Provider.of<CreateGroupPageController>(context,
                                        listen: true)
                                    .icon,
                                //style: TextStyle(fontSize: width * 0.25),
                              ),
                            )),
                        IconButton(
                          //iconSize: width * 0.1,
                          onPressed: () =>
                              Provider.of<CreateGroupPageController>(context,
                                      listen: false)
                                  .clearIcon(),
                          icon: DecoratedBox(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).colorScheme.background),
                            child: Icon(
                              Icons.cancel,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          ProfileInputFeild(
              maxLength: c.maxGroupName,
              width: width * 0.9,
              label: AppLocalizations.of(context)!.name,
              controller:
                  Provider.of<CreateGroupPageController>(context, listen: false)
                      .nameController),
          ProfileInputFeild(
              maxLength: c.maxGroupDesc,
              width: width * 0.9,
              label: AppLocalizations.of(context)!.description,
              controller:
                  Provider.of<CreateGroupPageController>(context, listen: false)
                      .descriptionController),
        ],
      ),
    );
  }
}

class _AddPeople extends StatelessWidget {
  const _AddPeople({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onPanDown: (details) =>
          Provider.of<CreateGroupPageController>(context, listen: false)
              .hideKeyboard(),
      onTap: () =>
          Provider.of<CreateGroupPageController>(context, listen: false)
              .hideKeyboard(),
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () => Provider.of<CreateGroupPageController>(
                          context,
                          listen: false)
                      .goBack(),
                  child: Text(AppLocalizations.of(context)!.goBack)),
              const Spacer(),
              TextButton(
                  onPressed: () => Provider.of<CreateGroupPageController>(
                          context,
                          listen: false)
                      .createGroup(),
                  child: Text(AppLocalizations.of(context)!.save))
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
                Provider.of<CreateGroupPageController>(context, listen: false)
                    .onSearchTextChanged(s),
            controller:
                Provider.of<CreateGroupPageController>(context, listen: false)
                    .searchTextController,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 20),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            height:
                Provider.of<CreateGroupPageController>(context, listen: true)
                        .selectedPeople
                        .isNotEmpty
                    ? height * 0.05
                    : 0,
            child: ListView.builder(
              controller:
                  Provider.of<CreateGroupPageController>(context, listen: true)
                      .selectedPeopleScroll,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount:
                  Provider.of<CreateGroupPageController>(context, listen: true)
                      .selectedPeople
                      .length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SelectedUser(
                    user: Provider.of<CreateGroupPageController>(context,
                            listen: true)
                        .selectedPeople[index],
                    index: index,
                    selected: (index ==
                        Provider.of<CreateGroupPageController>(context,
                                listen: true)
                            .selectedToDelete),
                    setter: Provider.of<CreateGroupPageController>(context,
                            listen: false)
                        .setSelectedToDelete,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Provider.of<CreateGroupPageController>(context, listen: true)
                    .isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Provider.of<CreateGroupPageController>(context, listen: true)
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
                        itemCount: Provider.of<CreateGroupPageController>(
                                context,
                                listen: true)
                            .hits
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return UserCard(
                              initialBool: Provider.of<CreateGroupPageController>(
                                      context,
                                      listen: false)
                                  .isUserSelected(
                                      Provider.of<CreateGroupPageController>(
                                              context,
                                              listen: true)
                                          .hits[index]),
                              adder: Provider.of<CreateGroupPageController>(context,
                                      listen: false)
                                  .addRemovePersonToList,
                              groupSearch: true,
                              user: Provider.of<CreateGroupPageController>(context,
                                      listen: true)
                                  .hits[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
