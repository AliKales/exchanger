import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trade/funcs.dart';
import 'package:trade/simple_uis.dart';

class Storage {
  static final storageRef = FirebaseStorage.instance.ref();

  static Future<String?> uploadFile({
    required context,
    required File file,
    required String path,
  }) async {
    try {
      SimpleUIs().showProgressIndicator(context);

      final mountainImagesRef = Storage.storageRef.child(path);

      await mountainImagesRef.putFile(file);

      Navigator.pop(context);

      return mountainImagesRef.getDownloadURL();
    } on FirebaseException catch (e) {
      Navigator.pop(context);

      Funcs().showSnackBar(context, "ERROR!");
      return null;
    } catch (e) {
      Navigator.pop(context);

      Funcs().showSnackBar(context, "ERROR!");
      return null;
    }
  }
}
