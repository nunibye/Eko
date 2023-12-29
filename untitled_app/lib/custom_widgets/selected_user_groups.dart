import 'package:flutter/material.dart';
import 'package:untitled_app/models/users.dart';
import 'profile_picture_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'controllers/selected_user_groups_controller.dart';
import 'package:provider/provider.dart';

class SelectedUser extends StatelessWidget {
  final AppUser user;
  final bool selected;
  final int index;
  final void Function(int) setter;
  const SelectedUser(
      {super.key,
      required this.user,
      required this.selected,
      required this.index,
      required this.setter});

  void onPressed() {
    setter(index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedUserGroupsController(),
      builder: (context, child) {
        return InkWell(
            onTap: () => onPressed(),
            child: Container(
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
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
                    const SizedBox(width: 5),
                    Text((user.name != "") ? user.name : user.username)
                  ],
                ),
              ),
            ));
      },
    );
  }
}
