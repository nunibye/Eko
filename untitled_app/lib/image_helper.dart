import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageHelper {
  ImageHelper({ImagePicker? imagePicker, ImageCropper? imageCropper})
      : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  pickImage(
      {ImageSource source = ImageSource.gallery,
      int imageQuality = 100, imageHeight = 150}) async {
    return await _imagePicker.pickImage(maxHeight: imageHeight,
        source: source, imageQuality: imageQuality);
  }

  Future<CroppedFile?> crop(
      {required XFile file, CropStyle cropStyle = CropStyle.circle}) async {
    return await _imageCropper.cropImage(
        sourcePath: file.path,
        cropStyle: cropStyle,
        aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
        uiSettings: [
          AndroidUiSettings(
            showCropGrid: false,
            hideBottomControls: true,
          ),
          IOSUiSettings()//TODO make this look good
        ]);
  }
}
