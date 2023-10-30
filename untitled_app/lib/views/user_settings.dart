import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

//import '../utilities/constants.dart' as c;
import '../controllers/settings_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
                  color: Theme.of(context).colorScheme.onBackground),
              onPressed: () => context.pop("poped"),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Lato',
                color: Theme.of(context).colorScheme.onBackground,
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
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              TextButton(
                onPressed: () {
                  Provider.of<SettingsController>(context, listen: false)
                      .signOut();
                },
                child: Text(
                  AppLocalizations.of(context)!.logOut,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Provider.of<SettingsController>(context, listen: false)
                        .deleteAccount(),
                child: Text(
                  AppLocalizations.of(context)!.deleteAccount,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
