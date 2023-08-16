import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/login_controller.dart';
import '../constants.dart' as c;
import '../widgets.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/navigation_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  //int currentStep = 0;

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

  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginController(),
        builder: (context, child) {
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
                      focus:
                          Provider.of<LoginController>(context, listen: false)
                              .emailFocus,
                      label: AppLocalizations.of(context)!.email,
                      controller:
                          Provider.of<LoginController>(context, listen: false)
                              .emailController,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006),
                    CustomInputFeild(
                      focus:
                          Provider.of<LoginController>(context, listen: false)
                              .passwordFocus,
                      label: AppLocalizations.of(context)!.password,
                      controller:
                          Provider.of<LoginController>(context, listen: false)
                              .passwordController,
                      inputType: TextInputType.visiblePassword,
                      obscure: true,
                    ),
                    //  if (!showNameInput) ...[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: TextButton(
                        onPressed: () =>
                            Provider.of<LoginController>(context, listen: false)
                                .forgotPasswordPressed(
                                    AppLocalizations.of(context)!.localeName),
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
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.009),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: TextButton(
                          onPressed: () => Provider.of<LoginController>(context,
                                  listen: false)
                              .logInPressed(),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          child: Consumer<LoginController>(
                            builder: (context, loginController, _) =>
                                loginController.loggingIn
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        AppLocalizations.of(context)!.logIn,
                                        style: TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                          )),
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
        });
  }
}
