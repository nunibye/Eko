import 'package:flutter/material.dart';
import '../models/search_model.dart' show SearchedItem;
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_picture_loading.dart';
import 'package:provider/provider.dart';
import 'controllers/searched_user_controller.dart';

class UserCard extends StatelessWidget {
  final SearchedItem user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: SearchedUserController(user: user, context: context),
        builder: (context, child) {
          return InkWell(
            onTap: () => {
              Provider.of<SearchedUserController>(context, listen: false)
                  .onCardPressed()
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              child: Row(
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
                  Column(
                    children: [
                      Text(user.username),
                      Text("${user.firstName} ${user.lastName}")
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
