import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/profile_picture_loading.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../utilities/constants.dart' as c;
import '../controllers/edit_profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileController(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => context.pop("poped"),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              AppLocalizations.of(context)!.editProfile,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Lato',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).width * 0.26,
                      width: MediaQuery.sizeOf(context).width * 0.26,
                      child: IconButton(
                        onPressed: () => Provider.of<EditProfileController>(
                                context,
                                listen: false)
                            .editProfileImagePressed(),
                        icon: ClipOval(
                            child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: Provider.of<EditProfileController>(
                                      context,
                                      listen: true)
                                  .profileImage,
                              placeholder: (context, url) =>
                                  const LoadingProfileImage(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            const Image(
                              image: AssetImage('images/edit.png'),
                            )
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
