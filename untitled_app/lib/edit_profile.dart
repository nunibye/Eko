import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:untitled_app/image_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
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
      body: ListView(children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ImageSelection()],
          ),
        ),
      ]),
    );
  }
}

final imageHelper = ImageHelper();

class ImageSelection extends StatefulWidget {
  const ImageSelection({super.key});

  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  final user = FirebaseAuth.instance.currentUser;
  uploadProfilePicture(File? file) async {
    await FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${user?.uid}/profile.jpg")
        .putFile(file!);
  }

  Future<String?> _getProfileImage() async {
    try {
      var urlRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${user!.uid}/profile.jpg");
      var imageUrl = urlRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  File? _image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.26,
        child: IconButton(
          onPressed: () async {
            final files = await imageHelper.pickImage();
            if (files != null) {
              final croppedFile = await imageHelper.crop(file: files);
              if (croppedFile != null) {
                setState(() => _image = File(croppedFile.path));
                uploadProfilePicture(_image);
              }
            }
          },
          icon: ClipOval(
            child: FutureBuilder(
              future: _getProfileImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Image(
                        image: NetworkImage(
                            snapshot.data!),
                      ),
                      const Image(
                        image: AssetImage('images/edit.png'),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }
}
