import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    print("class : Utils  method : getInitials start");
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial;
    if (nameSplit.length > 2) {
      lastNameInitial = nameSplit[1][0];
    } else {
      lastNameInitial = "";
    }

    print("class : Utils  method : getInitials end");
    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile selectedPickedImage =
        await ImagePicker().getImage(source: source);
    File selectedImage = File(selectedPickedImage.path);
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();

    final path = tempDir.path;

    int random = Random().nextInt(1000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);
    return new File("$path/image_$random.jpg")
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}
