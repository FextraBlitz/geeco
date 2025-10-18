import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if(image != null) {
    return File(image.path);
  }
  throw Future.error("Error: No Photo Taken");
}