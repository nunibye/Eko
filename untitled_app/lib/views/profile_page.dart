import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

import '../custom_widgets/profile_page_header.dart';
import '../controllers/profile_controller.dart';
import '../custom_widgets/feed_builder.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(context: context),
      builder: (context, child) {
        return Scaffold(
          body: Consumer<ProfileController>(
            builder: (context, profileController, _) => FeedBuilder(
              //query. Ok to be here in MVVM becasue it doesn't interact with database. Just a template for a request
              firestoreQuery: FirebaseFirestore.instance
                  .collection('posts')
                  .where("author",
                      isEqualTo:
                          Provider.of<ProfileController>(context, listen: false)
                              .getUID())
                  .orderBy('time', descending: true),
              //This widget will be first in the list. use Column for this not ListView
              header: const Header(),
              user: Provider.of<ProfileController>(context, listen: true).user,
              //Optional funtion to call on refresh.
              refreshFunction:
                  Provider.of<ProfileController>(context, listen: false)
                      .onPageRefresh,
            ),
          ),
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ProfileController>(
          builder: (context, profileController, _) => Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      "@${profileController.username}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () =>
                          Provider.of<ProfileController>(context, listen: false)
                              .settingsButtonPressed(),
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 25,
                        weight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              ProfileHeader(
                username: profileController.username,
                profilePic: profileController.profileImage,
                likes: profileController.likes,
                following: profileController.following.length,
                followers: profileController.followers.length,
                profileBio: profileController.profileBio,
                name: profileController.name,
              ),
            ],
          ),
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
                        width: 2, color: Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () =>
                      Provider.of<ProfileController>(context, listen: false)
                          .editProfilePressed(),
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
        ),
      ],
    );
  }
}
