import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_picture_loading.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String profilePic;
  final int likes;
  final int following;
  final int followers;
 // idk if this needs to be done differently
  const ProfileHeader(
      {super.key,
      required this.username,
      required this.profilePic,
      required this.likes,
      required this.following,
      required this.followers,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.26,
                height: MediaQuery.sizeOf(context).width * 0.26,
                child: ClipOval(
                  child: 
                  CachedNetworkImage(
                    imageUrl: profilePic,
                    placeholder: (context, url) =>
                        const LoadingProfileImage(),
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
