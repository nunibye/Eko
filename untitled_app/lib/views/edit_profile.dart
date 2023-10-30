import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/edit_profile_text_field.dart';
import 'package:untitled_app/custom_widgets/profile_picture_loading.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../utilities/constants.dart' as c;
import '../controllers/edit_profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../utilities/constants.dart' as c;
//import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => EditProfileController(context: context),
      builder: (context, child) {
        return GestureDetector(
            onTap: () =>
                Provider.of<EditProfileController>(context, listen: false)
                    .hideKeyboard(),
            child: Scaffold(
              body: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).colorScheme.onBackground),
                        onPressed: () => Provider.of<EditProfileController>(
                                          context,
                                          listen: false)
                                      .exitPressed(),
                      ),
                     
                      Text(
                        AppLocalizations.of(context)!.editProfile,
                        //AppLocalizations.of(context)!.save,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Lato',
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        child: Text(
                          
                          AppLocalizations.of(context)!.save,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Lato',
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        onPressed: () => Provider.of<EditProfileController>(
                                          context,
                                          listen: false)
                                      .savePressed(),
                      ),
                      
                      //const Spacer(),
                      
                    ],
                  ),
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
                        ),
                      ],
                    ),
                  ),

                  // if (Provider.of<EditProfileController>(context, listen: false)
                  //     .showBioCounts)
                  //   Consumer<EditProfileController>(
                  //     builder: (context, bioController, _) => Row(
                  //       children: [
                  //         Text(
                  //             "${bioController.bioBodyChars}/${c.maxBioChars} ${AppLocalizations.of(context)!.characters}"),
                  //         const Spacer()
                  //         // no new lines atm
                  //         // Text(
                  //         //     "${bioController.bioNewLines}/${c.maxBioLines} ${AppLocalizations.of(context)!.newLines}"),
                  //       ],
                  //     ),
                  // ),
                  ProfileInputFeild(
                    // onTap: () {
                    //   Provider.of<EditProfileController>(context, listen: false)
                    //       .showCountsName(true);
                    // },
                    // onEditingComplete: () => {
                    //   // Provider.of<EditProfileController>(context, listen: false)
                    //   //     .showCountsName(false),
                    //   Provider.of<EditProfileController>(context, listen: false)
                    //       .saveNameData(Provider.of<EditProfileController>(
                    //               context,
                    //               listen: false)
                    //           .nameController
                    //           .text)
                    // },
                    focus: Provider.of<EditProfileController>(context,
                            listen: false)
                        .nameFocus,
                    label: AppLocalizations.of(context)!.name,
                    controller: Provider.of<EditProfileController>(context,
                            listen: false)
                        .nameController,
                    maxLength: c.maxNameChars,
                  ),
                  ProfileInputFeild(
                    // onTap: () {
                    //   Provider.of<EditProfileController>(context, listen: false)
                    //       .showCountsBio(true);
                    // },
                    // onEditingComplete: () => {
                    //   // Provider.of<EditProfileController>(context, listen: false)
                    //   //     .showCountsBio(false),
                    //   Provider.of<EditProfileController>(context, listen: false)
                    //       .saveBioData(Provider.of<EditProfileController>(
                    //               context,
                    //               listen: false)
                    //           .bioController
                    //           .text)
                    // },
                    focus: Provider.of<EditProfileController>(context,
                            listen: false)
                        .bioFocus,
                    label: AppLocalizations.of(context)!.bioTitle,
                    controller: Provider.of<EditProfileController>(context,
                            listen: false)
                        .bioController,
                    maxLength: c.maxBioChars,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
