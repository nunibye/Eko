import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/profile_page_top.dart';
import '../controllers/profile_controller.dart';
import '../custom_widgets/feed_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(),
      builder: (context, child) {
        return FeedBuilder(
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
          //Optional funtion to call on refresh.
          refreshFunction:
              Provider.of<ProfileController>(context, listen: false)
                  .onPageRefresh,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "@${Provider.of<ProfileController>(context, listen: true).username}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                      size: 35,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.26,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        Provider.of<ProfileController>(context, listen: true)
                            .profileImage,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                Provider.of<ProfileController>(context, listen: true).username,
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
                number:
                    Provider.of<ProfileController>(context, listen: true).likes,
                label: AppLocalizations.of(context)!.likes),
            ProfilePageTopNumberDisplay(
                number: Provider.of<ProfileController>(context, listen: true)
                    .followers,
                label: AppLocalizations.of(context)!.followers),
            ProfilePageTopNumberDisplay(
                number: Provider.of<ProfileController>(context, listen: true)
                    .following,
                label: AppLocalizations.of(context)!.following),
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
                        width: 2, color: Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                  ).then((value) {
                    Provider.of<ProfileController>(context, listen: false)
                        .editProfileDissmissed();
                  }),
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
