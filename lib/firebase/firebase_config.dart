import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wings_advanced_tasl/screens/api_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthServices {
  Future<User?> createAuthUser(String email, String password) async {
    User? userCredential;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value);
        userCredential = value.user!;
      });
    } on FirebaseException catch (error) {
      if (error.code == "ERROR_EMAIL_ALREADY_IN_USE" ||
          error.code == "account-exists-with-different-credential" ||
          error.code == "email-already-in-use") {
        try {
          await _auth
              .signInWithEmailAndPassword(email: email!, password: password!)
              .then((value) {
            userCredential = value.user!;
          });
        } on FirebaseException catch (error) {}
      } else {}
    }
    return userCredential;
  }

  Future signInWithEmailPassword(context,
      {required String email, required String password}) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        //   prefs.setBool("isLogin", true);
        if (value.user!.uid != null) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const APIPage(),
            ),
          );
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
