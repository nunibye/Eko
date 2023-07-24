import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

class ImageSelection extends StatefulWidget {
  const ImageSelection({super.key});

  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      setState(
        () {
          _image = img;
        },
      );
    } on PlatformException {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.26,
        child: IconButton(
          onPressed: () => _pickImage,
          icon: const ClipOval(
            child: Stack(
              children: [
                Image(
                  image: NetworkImage(
                      "https://avatarfiles.alphacoders.com/656/65658.png"),
                ),
                Image(
                  image: AssetImage('images/edit.png'),
                )
              ],
            ),
          ),
        ));
  }
}
