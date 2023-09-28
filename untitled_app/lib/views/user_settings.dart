import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/utilities/router_notifier.dart';
//import '../utilities/constants.dart' as c;
import '../controllers/settings_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../utilities/locator.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';


class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsController(context: context),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => context.pop("poped"),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              AppLocalizations.of(context)!.editProfile,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Lato',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                value: Provider.of<SettingsController>(context, listen: false)
                    .getValue(),
                onChanged: (value) =>
                    Provider.of<SettingsController>(context, listen: false)
                        .changeValue(value),
              ),
              TextButton(
                onPressed: () {
                  // FIXME there is something weird with redirect not disposing of the stack. not sure how to do that worked on it for 1 hour hehe <3
                  locator<RouterNotifier>()
                      .signOut(context);
                },
                child: Text(AppLocalizations.of(context)!.logOut),
              ),
            ],
          ),
        );
      },
    );
  }
}
