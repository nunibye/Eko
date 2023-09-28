import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_picture_loading.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String profilePic;
  final String profileBio;
  final String bioName;
  final int likes;
  final int following;
  final int followers;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.profilePic,
    required this.likes,
    required this.following,
    required this.followers,
    required this.profileBio,
    required this.bioName,
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
                    SizedBox(
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
                                  number: likes,
                                  label: AppLocalizations.of(context)!.likes,
                                ),
                                _ProfilePageTopNumberDisplay(
                                  number: followers,
                                  label:
                                      AppLocalizations.of(context)!.followers,
                                ),
                                _ProfilePageTopNumberDisplay(
                                  number: following,
                                  label:
                                      AppLocalizations.of(context)!.following,
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
                      bioName,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
  const _ProfilePageTopNumberDisplay(
      {required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: NumberFormat.compact().format(number),
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 17),
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
