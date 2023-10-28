import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/login_controller.dart';
import '../custom_widgets/login_text_feild.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => LoginController(context: context),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<LoginController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<LoginController>(context, listen: false)
                          .previousPressed();
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).colorScheme.onBackground),
                        // Text(AppLocalizations.of(context)!.previous)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * .35,
                    width: width,
                    child: Image.asset('images/echo.png'),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.15,
                    child: TextButton(
                        onPressed: () =>
                            Provider.of<LoginController>(context, listen: false)
                                .logInPressed(),
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.55)),
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
                                            .onPrimary,
                                      ),
                                    ),
                        )),
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
                          fontSize: 13,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onBackground,
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
