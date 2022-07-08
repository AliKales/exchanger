import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trade/firebase/auth.dart';
import 'package:trade/values.dart';

class Funcs {
  final ImagePicker _picker = ImagePicker();

  Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  void navigatorPushReplacement(context, page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

  void showSnackBar(context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customRadius),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<String?> takePhotoWithCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo?.path;
  }

  DateTime getGMTDateTimeNow() {
    int iS = DateTime.now().timeZoneOffset.inSeconds;
    return DateTime.now().subtract(Duration(seconds: iS));
  }

  DateTime? getFixedDateTime(DateTime? dT) {
    int iS = DateTime.now().timeZoneOffset.inSeconds;
    return dT?.add(Duration(seconds: iS));
  }

  String getIdByTime(DateTime dT) {
    return DateTime(4000).difference(dT).inSeconds.toString() +
        Auth().getEmail().split("@").first;
    //return "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}${dateTime.millisecond}";
  }

  String formatDate(DateTime dt) {
    String month = dt.month.toString();
    if (month.length == 1) {
      month = "0$month";
    }
    return "${dt.day}.$month.${dt.year} ${dt.hour}:${dt.minute}";
  }
}
