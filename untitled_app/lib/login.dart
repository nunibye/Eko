import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart' as c;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  bool loggingIn = false;
  bool showNameInput = false; // control whether to show the name input or not.
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  int currentStep = 0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _showMyDialog(
      String title, String line1, String button1, bool signUp) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(line1),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(button1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (signUp)
              TextButton(
                child: Text(AppLocalizations.of(context)!.signUp),
                onPressed: () {
                  Navigator.of(context).pop(); //TODO fix this
                },
              ),
          ],
        );
      },
    );
  }

  signInError(errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        _showMyDialog(
            AppLocalizations.of(context)!.invalidEmailTittle,
            AppLocalizations.of(context)!.invalidEmailBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'user-not-found':
        _showMyDialog(
            AppLocalizations.of(context)!.userNotFoundTitle,
            AppLocalizations.of(context)!.userNotFoundBody,
            AppLocalizations.of(context)!.tryAgain,
            true);
        break;
      case 'wrong-password':
        _showMyDialog(
            AppLocalizations.of(context)!.wrongPasswordTittle,
            AppLocalizations.of(context)!.wrongPasswordBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'too-many-requests':
        _showMyDialog(
            AppLocalizations.of(context)!.tooManyRequestsTittle,
            AppLocalizations.of(context)!.tooManyRequestsBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'user-disabled':
        _showMyDialog(
            AppLocalizations.of(context)!.userDisabledTittle,
            AppLocalizations.of(context)!.userDisabledBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      default:
        _showMyDialog(
            AppLocalizations.of(context)!.defaultErrorTittle,
            AppLocalizations.of(context)!.defaultErrorBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
    }
  }

  Future signIn() async {
    if (emailController.text == '') {
      emailFocus.requestFocus();
    } else if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      try {
        setState(() {
          loggingIn = true;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } on FirebaseAuthException catch (e) {
        setState(() {
          loggingIn = false;
        });
        signInError(e.code);
      }
    }
  }

  Future<UserCredential?> signUp() async {
    if (emailController.text == '') {
      emailFocus.requestFocus();
    } else if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      try {
        setState(() {
          loggingIn = true;
        });
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // User has been signed up successfully, you can do additional operations if needed
        return userCredential;
      } on FirebaseAuthException catch (e) {
        setState(() {
          loggingIn = false;
        });
        signInError(e.code);
      }
    }
    return null;
  }

  // TODO: fix this to work
  // Add user data to Firestore
  Future<void> _addUserDataToFirestore(User user) async {
    final firestore = FirebaseFirestore.instance;
    final userData = {
      'uid': user.uid,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
    };
    print('here');
    await firestore.collection('users').add(userData);
  }

  // Function to handle the "Next" button click
  void _handleNextClick() async {
    final userCredential = await signUp();
   
    if (userCredential != null) {
      final user = userCredential.user;

      if (user != null) {
        await _addUserDataToFirestore(user);
        // User data added to Firestore successfully
        // You can navigate to the next page or perform any other action here.
      } else {
        print('User is null');
      }
    } else {
      print('Sign-up failed');
    }
  }

  forgotPasswordError(errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        _showMyDialog(
            AppLocalizations.of(context)!.invalidEmailTittle,
            AppLocalizations.of(context)!.invalidEmailBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'user-not-found':
        _showMyDialog(
            AppLocalizations.of(context)!.userNotFoundTitle,
            AppLocalizations.of(context)!.userNotFoundBody,
            AppLocalizations.of(context)!.tryAgain,
            true);
        break;
      case 'too-many-requests':
        _showMyDialog(
            AppLocalizations.of(context)!.tooManyRequestsTittle,
            AppLocalizations.of(context)!.tooManyRequestsBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'channel-error':
        _showMyDialog(
            AppLocalizations.of(context)!.defaultErrorTittle,
            AppLocalizations.of(context)!.channelErrorBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        emailFocus.requestFocus();
        break;
      default:
        _showMyDialog(
            AppLocalizations.of(context)!.defaultErrorTittle,
            AppLocalizations.of(context)!.defaultErrorBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
    }
  }

  showForgotPasswordSuccess() {
    _showMyDialog(
        AppLocalizations.of(context)!.forgotPasswordTittle,
        AppLocalizations.of(context)!.forgotPasswordBody,
        AppLocalizations.of(context)!.close,
        false);
  }

  Future forgotPassword() async {
    await FirebaseAuth.instance
        .setLanguageCode(AppLocalizations.of(context)!.localeName);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      showForgotPasswordSuccess();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      forgotPasswordError(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: c.logoPaddingVert, horizontal: c.logoPaddingHoriz),
            child: Container(
              //logo
              height: MediaQuery.of(context).size.width * 0.2,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: const BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
          CustomInputFeild(
            focus: emailFocus,
            label: AppLocalizations.of(context)!.email,
            controller: emailController,
            inputType: TextInputType.emailAddress,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.006),
          CustomInputFeild(
            focus: passwordFocus,
            label: AppLocalizations.of(context)!.password,
            controller: passwordController,
            inputType: TextInputType.visiblePassword,
            obscure: true,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.1,
            child: TextButton(
              onPressed: forgotPassword,
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.009),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.15,
            child: TextButton(
              onPressed: signIn,
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              child: loggingIn
                  ? const CircularProgressIndicator()
                  : Text(
                      AppLocalizations.of(context)!.logIn,
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(12),
              child: Text("---- or ----")), // TODO: placeholder, beautify later
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.10,
            child: TextButton(
              onPressed: () {
                // Show the first and last name input when "Create Account" button is clicked
                setState(() {
                  showNameInput = true;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // Show the first and last name input if showNameInput is true
          if (showNameInput) ...[
            SizedBox(height: MediaQuery.of(context).size.height * 0.009),
            CustomInputFeild(
              label: 'First Name',
              controller: firstNameController,
              inputType: TextInputType.text,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.006),
            CustomInputFeild(
              label: 'Last Name',
              controller: lastNameController,
              inputType: TextInputType.text,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.15,
              child: TextButton(
                onPressed:
                    _handleNextClick, // Use _handleNextClick function here
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
