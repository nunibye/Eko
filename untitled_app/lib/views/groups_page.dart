import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/groups_page_controller.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsPageController(context: context),
      builder: (context, child) {
        return WillPopScope(
            onWillPop: ()=>Provider.of<GroupsPageController>(context, listen: false)
                .onWillPop(),
            child: const Scaffold(
              body: _Header(),
            ));
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: const Color.fromARGB(255, 52, 51, 51),
          height: MediaQuery.sizeOf(context).height * 0.075,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.groups,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.waving_hand_rounded),
                    ),
                    IconButton(
                      onPressed: () => Provider.of<GroupsPageController>(
                              context,
                              listen: false)
                          .createGroupPressed(),
                      icon: const Icon(Icons.group_add),
                    ),
                    const SizedBox(width: 8)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
