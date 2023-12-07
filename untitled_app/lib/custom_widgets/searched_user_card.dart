import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/users.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_picture_loading.dart';
import 'package:provider/provider.dart';
import 'controllers/searched_user_controller.dart';

class UserCard extends StatelessWidget {
  final bool? initialBool;
  final AppUser user;
  final bool groupSearch;
  final void Function(AppUser, bool)? adder;
  const UserCard(
      {super.key, required this.user, this.groupSearch = false, this.adder, this.initialBool});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: SearchedUserController(
            user: user,
            context: context,
            groupSearch: groupSearch,
            adder: adder,
            initialBool: initialBool),
        builder: (context, child) {
          return InkWell(
            onTap: () {
              if (groupSearch) {
                Provider.of<SearchedUserController>(context, listen: false)
                    .onAddPressed();
              } else {
                Provider.of<SearchedUserController>(context, listen: false)
                    .onCardPressed();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.115,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.profilePicture,
                            placeholder: (context, url) =>
                                const LoadingProfileImage(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(user.username), Text(user.name)],
                        ),
                      ),
                    ],
                  ),
                  if (groupSearch)
                    Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Provider.of<SearchedUserController>(context,
                                    listen: true)
                                .added
                            ? const Icon(Icons.check_circle)
                            : const Icon(Icons.circle_outlined))
                  else
                    SizedBox(
                      width: 120, //FIXME make dynamic
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Provider.of<SearchedUserController>(
                                      context,
                                      listen: true)
                                  .isFollowing
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => Provider.of<SearchedUserController>(
                                context,
                                listen: false)
                            .onFollowPressed(),
                        child: Text(
                          Provider.of<SearchedUserController>(context,
                                      listen: true)
                                  .isFollowing
                              ? AppLocalizations.of(context)!.following
                              : AppLocalizations.of(context)!.follow,
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
