import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_picture_detail_controller.dart';
import '../custom_widgets/profile_picture_loading.dart';


class ProfilePictureDetail extends StatelessWidget {
  final String imageURL;

  const ProfilePictureDetail({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfilePictureDetailController(context: context),
        builder: (context, child) {
          return InkWell(
            onTap: () => Provider.of<ProfilePictureDetailController>(context,
                    listen: false)
                .backgroundPressed(),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow),
              child: Hero(
                tag: 'profileImage',
                child: IconButton(
                  onPressed: () {},
                  icon: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: imageURL,
                        placeholder: (context, url) =>
                            const LoadingProfileImage(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
