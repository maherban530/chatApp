import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(
    BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: const TextStyle(fontSize: 16),
    ),
  ));
}

bool isFileDownloaded(directoryPath, fileName) {
  List files = Directory(directoryPath).listSync();
  bool isDownloaded = false;
  for (var file in files) {
    if (file.path == "$directoryPath/$fileName") {
      isDownloaded = true;
    }
  }

  return isDownloaded;
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? imageFile;

  try {
    XFile? xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (xFile != null) {
      imageFile = File(xFile.path);
    }
  } catch (e) {
    buildShowSnackBar(context, e.toString());
  }

  return imageFile;
}
// void showSnackBar(
//   BuildContext context, {
//   required String content,
// }) =>
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(content),
//       ),
//     );
