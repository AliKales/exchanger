import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProviderAuth with ChangeNotifier {
  User? user;

  User? get getUser => user;

  void updateUser(User? userToUpdate) {
    user = userToUpdate;
    notifyListeners();
  }
}
