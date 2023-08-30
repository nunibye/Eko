import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
//import '../utilities/constants.dart' as c;
import '../controllers/settings_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/dark_theme_provider.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

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
                    title: Text('Dark Mode'),
                    value: themeChange.darkTheme,
                    onChanged: (value) {
                      themeChange.darkTheme = value;
                      print(value);
                    },
                  ),
                ],
              ));
        }
  }
