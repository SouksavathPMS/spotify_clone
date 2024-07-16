import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

showSnackbar(
  BuildContext context, {
  required String content,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          content,
        ),
      ),
    );
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerRes == null) {
      return null;
    }
    return File(filePickerRes.files.first.xFile.path);
  } catch (e) {
    return null;
  }
}

Future<(File?, String?)> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerRes == null) {
      return (null, null);
    }
    return (
      File(filePickerRes.files.first.xFile.path),
      filePickerRes.names.first
    );
  } catch (e) {
    return (null, null);
  }
}
