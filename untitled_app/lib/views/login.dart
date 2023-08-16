import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/login_controller.dart';
import '../constants.dart' as c;
import '../widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  

  //int currentStep = 0;

  

  // signInError(errorCode) {
  //   switch (errorCode) {
  //     case 'invalid-email':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.invalidEmailTittle,
  //           AppLocalizations.of(context)!.invalidEmailBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //     case 'user-not-found':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.userNotFoundTitle,
  //           AppLocalizations.of(context)!.userNotFoundBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           true);
  //       break;
  //     case 'wrong-password':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.wrongPasswordTittle,
  //           AppLocalizations.of(context)!.wrongPasswordBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //     case 'too-many-requests':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.tooManyRequestsTittle,
  //           AppLocalizations.of(context)!.tooManyRequestsBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //     case 'user-disabled':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.userDisabledTittle,
  //           AppLocalizations.of(context)!.userDisabledBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //     default:
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.defaultErrorTittle,
  //           AppLocalizations.of(context)!.defaultErrorBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //   }
  // }

  // Future signIn() async {
  //   if (emailController.text == '') {
  //     emailFocus.requestFocus();
  //   } else if (passwordController.text == '') {
  //     passwordFocus.requestFocus();
  //   } else {
  //     try {
  //       setState(() {
  //         loggingIn = true;
  //       });
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //           email: emailController.text, password: passwordController.text);
  //     } on FirebaseAuthException catch (e) {
  //       setState(() {
  //         loggingIn = false;
  //       });
  //       signInError(e.code);
  //     }
  //   }
  // }

  // Future<UserCredential?> signUp() async {
  //   if (emailController.text == '') {
  //     emailFocus.requestFocus();
  //   } else if (passwordController.text == '') {
  //     passwordFocus.requestFocus();
  //   } else {
  //     try {
  //       setState(() {
  //         loggingIn = true;
  //       });
  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text,
  //         password: passwordController.text,
  //       );
  //       // User has been signed up successfully, you can do additional operations if needed
  //       return userCredential;
  //     } on FirebaseAuthException catch (e) {
  //       setState(() {
  //         loggingIn = false;
  //       });
  //       signInError(e.code);
  //     }
  //   }
  //   return null;
  // }

  // // Add user data to Firestore
  // Future<void> _addUserDataToFirestore(User user) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final userData = {
  //     'uid': user.uid,
  //     'email': emailController.text,
  //     'username': userNameController.text,
  //     'name': {
  //       'firstName': firstNameController.text,
  //       'lastName': lastNameController.text,
  //     },
  //     'profileData': {
  //       'followers': 0,
  //       'following': 0,
  //       'likes': 0,
  //       'profilePicture': "NoProfilePicture",
  //     }
  //   };
  //   await firestore.collection('users').doc(user.uid).set(userData);
  // }

  // // Function to handle the "Next" button click
  // void _handleNextClick() async {
  //   final userCredential = await signUp();

  //   if (userCredential != null) {
  //     final user = userCredential.user;

  //     if (user != null) {
  //       await _addUserDataToFirestore(user);
  //       // User data added to Firestore successfully
  //       // You can navigate to the next page or perform any other action here.
  //     } else {
  //       print('User is null');
  //     }
  //   } else {
  //     print('Sign-up failed');
  //   }
  // }

  // forgotPasswordError(errorCode) {
  //   switch (errorCode) {
  //     case 'invalid-email':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.invalidEmailTittle,
  //           AppLocalizations.of(context)!.invalidEmailBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //     case 'user-not-found':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.userNotFoundTitle,
  //           AppLocalizations.of(context)!.userNotFoundBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           true);
  //       break;
  //     case 'too-many-requests':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.tooManyRequestsTittle,
  //           AppLocalizations.of(context)!.tooManyRequestsBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //     case 'channel-error':
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.defaultErrorTittle,
  //           AppLocalizations.of(context)!.channelErrorBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       emailFocus.requestFocus();
  //       break;
  //     default:
  //       _showMyDialog(
  //           AppLocalizations.of(context)!.defaultErrorTittle,
  //           AppLocalizations.of(context)!.defaultErrorBody,
  //           AppLocalizations.of(context)!.tryAgain,
  //           false);
  //       break;
  //   }
  // }

  // showForgotPasswordSuccess() {
  //   _showMyDialog(
  //       AppLocalizations.of(context)!.forgotPasswordTittle,
  //       AppLocalizations.of(context)!.forgotPasswordBody,
  //       AppLocalizations.of(context)!.close,
  //       false);
  // }

  // Future forgotPassword() async {
  //   await FirebaseAuth.instance
  //       .setLanguageCode(AppLocalizations.of(context)!.localeName);
  //   try {
  //     await FirebaseAuth.instance
  //         .sendPasswordResetEmail(email: emailController.text);
  //     showForgotPasswordSuccess();
  //   } on FirebaseAuthException catch (e) {
  //     print(e.code);
  //     forgotPasswordError(e.code);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final LoginController controller = LoginController();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          // leading: showNameInput
          //     ? IconButton(
          //         icon: const Icon(Icons.arrow_back),
          //         onPressed: () {
          //           setState(() {
          //             showNameInput = false;
          //           });
          //         },
          //       )
          //     : null,

          // Optional: You can set other properties for the AppBar as needed
          // title: Text("Login Page"), // Replace "Login Page" with your desired title
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: c.logoPaddingVert,
                    horizontal: c.logoPaddingHoriz),
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
                focus: controller.emailFocus,
                label: AppLocalizations.of(context)!.email,
                controller: controller.emailController,
                
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.006),
              CustomInputFeild(
                focus: controller.passwordFocus,
                label: AppLocalizations.of(context)!.password,
                
                controller: controller.passwordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
              ),
              //  if (!showNameInput) ...[
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   height: MediaQuery.of(context).size.width * 0.1,
                //   child: TextButton(
                //     onPressed: controller.forgotPasswordPressed(AppLocalizations.of(context)!.localeName),
                //     child: Text(
                //       AppLocalizations.of(context)!.forgotPassword,
                //       style: TextStyle(
                //         fontSize: 16,
                //         letterSpacing: 1,
                //         fontWeight: FontWeight.normal,
                //         color: Theme.of(context).colorScheme.primary,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.15,
                  child: TextButton(
                    onPressed: ()=>controller.logInPressed(),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: controller.loggingIn
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

                // const Padding(
                //     padding: EdgeInsets.all(12),
                //     child: Text(
                //         "---- or ----")), // TODO: placeholder, beautify later
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   height: MediaQuery.of(context).size.width * 0.10,
                //   child: TextButton(
                //     onPressed: () {
                //       // Show the first and last name input when "Create Account" button is clicked
                //       setState(() {
                //         showNameInput = true;
                //       });
                //     },
                //     style: TextButton.styleFrom(
                //       backgroundColor: Theme.of(context).colorScheme.secondary,
                //     ),
                //     child: Text(
                //       "Create Account",
                //       style: TextStyle(
                //         fontSize: 18,
                //         letterSpacing: 1,
                //         fontWeight: FontWeight.normal,
                //         color: Theme.of(context).colorScheme.primary,
                //       ),
                //     ),
                //   ),
                // ),
              // ] else ...[
              //   // Show the first and last name input if showNameInput is true
              //   // if (showNameInput) ...[
              //   SizedBox(height: MediaQuery.of(context).size.height * 0.009),
              //   CustomInputFeild(
              //     label: 'Username',
              //     controller: userNameController,
              //     inputType: TextInputType.text,
              //   ),
              //   SizedBox(height: MediaQuery.of(context).size.height * 0.009),
              //   CustomInputFeild(
              //     label: 'First Name',
              //     controller: firstNameController,
              //     inputType: TextInputType.text,
              //   ),
              //   SizedBox(height: MediaQuery.of(context).size.height * 0.006),
              //   CustomInputFeild(
              //     label: 'Last Name',
              //     controller: lastNameController,
              //     inputType: TextInputType.text,
              //   ),
              //   SizedBox(height: MediaQuery.of(context).size.height * 0.018),
              //   SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.9,
              //     height: MediaQuery.of(context).size.width * 0.15,
              //     child: TextButton(
              //       onPressed:
              //           _handleNextClick, // Use _handleNextClick function here
              //       style: TextButton.styleFrom(
              //           backgroundColor:
              //               Theme.of(context).colorScheme.secondary),
              //       child: Text(
              //         "Next",
              //         style: TextStyle(
              //           fontSize: 18,
              //           letterSpacing: 1,
              //           fontWeight: FontWeight.normal,
              //           color: Theme.of(context).colorScheme.primary,
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ));
  }
}
