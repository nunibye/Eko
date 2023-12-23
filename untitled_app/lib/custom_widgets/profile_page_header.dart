import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/followers_controller.dart';
import 'package:untitled_app/controllers/following_controller.dart';

import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../views/following.dart';
import '../views/followers.dart';
import 'profile_picture_loading.dart';

import '../controllers/bottom_nav_bar_controller.dart';
import '../utilities/locator.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String profilePic;
  final String profileBio;
  final String name;
  final int likes;
  final List<dynamic> following;
  final List<dynamic> followers;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.profilePic,
    required this.likes,
    required this.following,
    required this.followers,
    required this.profileBio,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'profileImage',
                      child: IconButton(
                        onPressed: () {
                          context.pushNamed("profile_picture_detail",
                              extra: profilePic);
                          locator<NavBarController>().disable();
                        },
                        icon: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.24,
                          height: MediaQuery.of(context).size.width * 0.24,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profilePic,
                              placeholder: (context, url) =>
                                  const LoadingProfileImage(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ProfilePageTopNumberDisplay(
                                  number: followers.length,
                                  label:
                                      AppLocalizations.of(context)!.followers,
                                  onPressed: () =>
                                      goFollowers(context, followers),
                                ),
                                _ProfilePageTopNumberDisplay(
                                  number: following.length,
                                  label:
                                      AppLocalizations.of(context)!.following,
                                  onPressed: () =>
                                      goFollowing(context, following),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      profileBio,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfilePageTopNumberDisplay extends StatelessWidget {
  final int number;
  final String label;
  final VoidCallback onPressed;

  const _ProfilePageTopNumberDisplay({
    required this.number,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: NumberFormat.compact().format(number),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.normal,
                fontSize: 17),
            children: [
              TextSpan(
                text: "\n$label",
                style: const TextStyle(fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}

goFollowing(context, List<dynamic> following) async {
  locator<NavBarController>().disable();
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) =>
            FollowingController(context: context, following: following),
        child: Following(
          following: following,
        ),
      ),
    ),
  );
  locator<NavBarController>().enable();
}

goFollowers(context, List<dynamic> followers) async {
  locator<NavBarController>().disable();
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) =>
            FollowersController(context: context, followers: followers),
        child: Followers(
          followers: followers,
        ),
      ),
    ),
  );
  locator<NavBarController>().enable();
}
