import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/login_controller.dart';
import '../constants.dart' as c;
import '../custom_widgets/login_text_feild.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginController(),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<LoginController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            // appBar: AppBar(
            //   backgroundColor: Theme.of(context).colorScheme.background,
            // ),
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
                    
                    focus: Provider.of<LoginController>(context, listen: false)
                        .emailFocus,
                    label: AppLocalizations.of(context)!.email,
                    controller:
                        Provider.of<LoginController>(context, listen: false)
                            .emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.006),
                  CustomInputFeild(
                    textInputAction: TextInputAction.go,
                    onEditingComplete: () =>
                        Provider.of<LoginController>(context, listen: false)
                            .logInPressed(),
                    focus: Provider.of<LoginController>(context, listen: false)
                        .passwordFocus,
                    label: AppLocalizations.of(context)!.password,
                    controller:
                        Provider.of<LoginController>(context, listen: false)
                            .passwordController,
                    inputType: TextInputType.visiblePassword,
                    password: true,
                  ),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.15,
                    child: TextButton(
                        onPressed: () =>
                            Provider.of<LoginController>(context, listen: false)
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

                  const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                          "---- or ----")), // TODO: placeholder, beautify later
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.10,
                    child: TextButton(
                      onPressed: () =>
                          Provider.of<LoginController>(context, listen: false)
                              .signUp(),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
