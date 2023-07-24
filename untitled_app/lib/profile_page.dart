import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_profile.dart';
import 'widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: MediaQuery.sizeOf(context).width * 0.13,
                  backgroundImage: 
                  const NetworkImage(
                      "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_16x9.jpg?w=1200"),
                 ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePageTopNumberDisplay(
                  number: 12543469, label: AppLocalizations.of(context)!.likes),
              ProfilePageTopNumberDisplay(
                  number: 12300,
                  label: AppLocalizations.of(context)!.followers),
              ProfilePageTopNumberDisplay(
                  number: 25, label: AppLocalizations.of(context)!.following),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            ),
                    child: Text(
                      AppLocalizations.of(context)!.editProfile,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
