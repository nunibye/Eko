import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart' as c;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets.dart';

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
  bool loggingIn = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    
    setState(() {
      loggingIn = true;
    });
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    
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
            label: AppLocalizations.of(context)!.email,
            controller: emailController,
            inputType: TextInputType.emailAddress,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.006),
          CustomInputFeild(
            label: AppLocalizations.of(context)!.password,
            controller: passwordController,
            inputType: TextInputType.visiblePassword,
            obscure: true,
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
              ))
        ],
      ),
    );
  }
}
