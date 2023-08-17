import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String email;
  String firstName;
  String lastName;
  String userName;
  CurrentUser(
      {this.email = '',
      this.firstName = '',
      this.userName = '',
      this.lastName = ''});

  Future signUp(password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future signIn(password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future forgotPassword(countryCode) async {
    await FirebaseAuth.instance.setLanguageCode(countryCode);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }
}
