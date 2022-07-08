import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/funcs.dart';
import 'package:trade/providers/provider_auth.dart';
import 'package:trade/simple_uis.dart';

class Auth {
  static Future logIn(
      {required context,
      required String emailAddress,
      required String password}) async {
    if (emailAddress == "" || password == "") {
      Funcs().showSnackBar(context, "Email/Password can not be empty!");
      return;
    }
    try {
      SimpleUIs().showProgressIndicator(context);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      Navigator.pop(context);
      Auth().getUserToProvider(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        Funcs().showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Funcs().showSnackBar(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      Navigator.pop(context);
      Funcs().showSnackBar(context, "ERROR");
    }
  }

  static Future signUp(
      {required context,
      required String emailAddress,
      required String password,
      required String displayName}) async {
    if (emailAddress == "" || password == "") {
      Funcs().showSnackBar(context, "Email/Password can not be empty!");
      return;
    }
    try {
      SimpleUIs().showProgressIndicator(context);
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await user.user?.updateDisplayName(displayName);
      Navigator.pop(context);
      Auth().getUserToProvider(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        Funcs().showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Funcs().showSnackBar(
            context, 'The account already exists for that email.');
      }
    }
  }

  static void listenToUser({required Function(User?) onChange}) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        onChange.call(null);
      } else {
        onChange.call(user);
      }
    });
  }

  Future logOut(context) async {
    await FirebaseAuth.instance.signOut();
    getUserToProvider(context);
  }

  void getUserToProvider(context) {
    User? userr = FirebaseAuth.instance.currentUser;
    Provider.of<ProviderAuth>(context, listen: false).updateUser(userr);
  }

  String getId() => FirebaseAuth.instance.currentUser?.uid ?? "";
  String getDisplayName() =>
      FirebaseAuth.instance.currentUser?.displayName ?? "";
  String getEmail() => FirebaseAuth.instance.currentUser?.email ?? "";
}
