import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/profile_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String profilePic;
  final int likes;
  final int following;
  final int followers;
  final bool user_settings; // idk if this needs to be done differently
  const ProfileHeader(
      {super.key,
      required this.username,
      required this.profilePic,
      required this.likes,
      required this.following,
      required this.followers,
      required this.user_settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user_settings ==
                  true) ... // im sure there is a better way to do this
                [
                Row(
                  children: [
                    Text(
                      "@$username",
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
              ]
              // else
              //   IconButton(
              //     onPressed: () {},
              //     icon: const Icon(Icons.more_horiz_outlined),
              //   )
              ,
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.26,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profilePic,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                username,
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
            _ProfilePageTopNumberDisplay(
                number: likes, label: AppLocalizations.of(context)!.likes),
            _ProfilePageTopNumberDisplay(
                number: followers,
                label: AppLocalizations.of(context)!.followers),
            _ProfilePageTopNumberDisplay(
                number: following,
                label: AppLocalizations.of(context)!.following),
          ],
        ),
      ],
    );
  }
}

class _ProfilePageTopNumberDisplay extends StatelessWidget {
  final int number;
  final String label;
  const _ProfilePageTopNumberDisplay(
      {required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width * 0.3,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: NumberFormat.compact().format(number),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          children: [
            TextSpan(
              text: "\n$label",
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
