import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/profile_page_top.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(), // Provide the ViewModel
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // FutureBuilder(
                //   future: getProfileImage(user!.uid),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return CircleAvatar(
                //         radius: MediaQuery.sizeOf(context).width * 0.13,
                //         backgroundImage: NetworkImage(snapshot.data!),
                //       );
                //     } else {
                //       return CircleAvatar(
                //         radius: MediaQuery.sizeOf(context).width * 0.13,
                //       );
                //     }
                //   },
                // ),
                const SizedBox(height: 10),
                Text(
                  profileController.username,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePageTopNumberDisplay(
                  number: profileController.likes,
                  label: AppLocalizations.of(context)!.likes),
              ProfilePageTopNumberDisplay(
                  number: profileController.followers,
                  label: AppLocalizations.of(context)!.followers),
              ProfilePageTopNumberDisplay(
                  number: profileController.following,
                  label: AppLocalizations.of(context)!.following),
            ],
          ),
        ],
      ),
    );
  }
}
