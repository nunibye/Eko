import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/login_controller.dart';

class CurrentUser {
  String email;
  String password;
  CurrentUser({this.email = '', this.password = ''});

  Future signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return(e.code);
    }
  }

  Future forgotPassword(countryCode) async {
    await FirebaseAuth.instance.setLanguageCode(countryCode);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      //showForgotPasswordSuccess();
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      //forgotPasswordError(e.code);
    }
  }
}
