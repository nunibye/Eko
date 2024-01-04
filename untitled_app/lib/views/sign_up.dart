import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/sign_up_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/login_text_feild.dart';
import '../utilities/constants.dart' as c;

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Row(
        children: [
          Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.onBackground),
          Consumer<SignUpController>(
            builder: (context, signUpController, _) => Text(
              AppLocalizations.of(context)!.previous,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          )
        ],
      ),
      onPressed: () =>
          Provider.of<SignUpController>(context, listen: false).backPressed(),
    );
  }
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpController(context: context),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<SignUpController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: Provider.of<SignUpController>(context, listen: false)
                  .pageController,
              children: const <Widget>[
                GetInfo(),
                GetPassword(),
                Placeholder(), //FIXME for some reson this stops everything from breaking
              ],
            ),
          ),
        );
      },
    );
  }
}

class GetInfo extends StatelessWidget {
  const GetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final width = c.widthGetter(context);
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Center(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const _BackButton(),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
                height: height * .1,
                child: Align(
                  child: Text(AppLocalizations.of(context)!.createAnAccount,
                      style: TextStyle(
                          fontSize: 35,
                          color: Theme.of(context).colorScheme.onBackground)),
                )),
            Divider(
              height: 0,
              thickness: height * 0.002,
              indent: width * 0.07,
              endIndent: width * 0.07,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            SizedBox(
              height: height * 0.06,
            ),
            CustomInputFeild(
              focus: Provider.of<SignUpController>(context, listen: false)
                  .nameFocus,
              label: AppLocalizations.of(context)!.name,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .nameController,
              inputType: TextInputType.text,
            ),
            SizedBox(height: height * c.loginPadding),
            CustomInputFeild(
              onChanged: (s) =>
                  Provider.of<SignUpController>(context, listen: false)
                      .onUsernameChanged(s),
              focus: Provider.of<SignUpController>(context, listen: false)
                  .usernameFocus,
              label: AppLocalizations.of(context)!.userName,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .usernameController,
              inputType: TextInputType.text,
            ),
            if (Provider.of<SignUpController>(context, listen: true)
                    .usernameController
                    .text !=
                '')
              Row(
                children: [
                  const SizedBox(width: 5),
                  Consumer<SignUpController>(
                    builder: (context, signUpController, _) => signUpController
                            .validUsername
                        ? signUpController.isChecking
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: width * 0.05,
                                  height: width * 0.05,
                                  child: const CircularProgressIndicator(),
                                ))
                            : signUpController.availableUsername
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      AppLocalizations.of(context)!.available,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .usernameInUse,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.invalidUserName,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                              InkWell(
                                  onTap: () {
                                    Provider.of<SignUpController>(context,
                                            listen: false)
                                        .showUserNameReqs();
                                  },
                                  child: Icon(
                                    Icons.help_outline_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ))
                            ],
                          ),
                  )
                ],
              ),

            // ElevatedButton(onPressed:()=> Provider.of<SignUpController>(context, listen: false)
            //       .isUsernameAvailable(), child: Text("check")),
            SizedBox(height: height * c.loginPadding),
            CustomInputFeild(
              label: AppLocalizations.of(context)!.email,
              focus: Provider.of<SignUpController>(context, listen: false)
                  .emailFocus,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .emailController,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: height * 0.1,
            ),
            // CustomInputFeild(
            //   focus: Provider.of<SignUpController>(context, listen: false)
            //       .dobFocus,
            //   onEditingComplete: () =>
            //       Provider.of<SignUpController>(context, listen: false)
            //           .keyboardGoToNextPage(),
            //   label: AppLocalizations.of(context)!.dateOfBirth,
            //   controller: Provider.of<SignUpController>(context, listen: false)
            //       .dobController,
            //   textInputAction: TextInputAction.send,
            //   inputType: TextInputType.datetime,
            // ),
            SizedBox(
              height: height * 0.1,
            ),
            SizedBox(
              width: width * 0.9,
              height: width * 0.15,
              child: TextButton(
                onPressed: () =>
                    Provider.of<SignUpController>(context, listen: false)
                        .forwardPressed(),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: Text(
                  AppLocalizations.of(context)!.cont,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class GetPassword extends StatelessWidget {
  const GetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final width = c.widthGetter(context);
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Center(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const _BackButton(),
            SizedBox(
                height: height * .1,
                child: Align(
                  child: Text(AppLocalizations.of(context)!.createAPassword,
                      style: TextStyle(
                          fontSize: 35,
                          color: Theme.of(context).colorScheme.onBackground)),
                )),
            Divider(
              height: 0,
              thickness: height * 0.002,
              indent: width * 0.07,
              endIndent: width * 0.07,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            SizedBox(
              height: height * 0.05,
            ),

            SizedBox(height: height * c.loginPadding),
            CustomInputFeild(
              onChanged: (s) =>
                  Provider.of<SignUpController>(context, listen: false)
                      .passwordChanged(),
              onEditingComplete: () =>
                  Provider.of<SignUpController>(context, listen: false)
                      .passwordConfirmFocus
                      .requestFocus(),
              label: AppLocalizations.of(context)!.password,
              focus: Provider.of<SignUpController>(context, listen: false)
                  .passwordFocus,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .passwordController,
              inputType: TextInputType.visiblePassword,
              password: true,
            ),
            SizedBox(height: height * c.loginPadding),
            CustomInputFeild(
              onChanged: (s) =>
                  Provider.of<SignUpController>(context, listen: false)
                      .passwordChanged(),
              onEditingComplete: () =>
                  Provider.of<SignUpController>(context, listen: false)
                      .signUpPressed(),
              textInputAction: TextInputAction.done,
              label: AppLocalizations.of(context)!.confirmPassword,
              focus: Provider.of<SignUpController>(context, listen: false)
                  .passwordConfirmFocus,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .passwordConfirmController,
              inputType: TextInputType.visiblePassword,
              password: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * c.loginPadding,
              ),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: Provider.of<SignUpController>(context, listen: true)
                    .passwordPercent,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Consumer<SignUpController>(
                builder: (context, signUpController, _) => Text(
                  "${signUpController.passed[0]}${AppLocalizations.of(context)!.passwordLen}\n"
                  "${signUpController.passed[1]}${AppLocalizations.of(context)!.passwordLower}\n"
                  "${signUpController.passed[2]}${AppLocalizations.of(context)!.passwordUpper}\n"
                  "${signUpController.passed[3]}${AppLocalizations.of(context)!.passwordNumber}\n"
                  "${signUpController.passed[4]}${AppLocalizations.of(context)!.passwordSpecial}\n"
                  "${signUpController.passed[5]}${AppLocalizations.of(context)!.passwordMatch}\n",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            //const Spacer(),
            SizedBox(
              height: height * 0.05,
            ),
            SizedBox(
              width: width * 0.9,
              height: width * 0.15,
              child: TextButton(
                onPressed: () =>
                    Provider.of<SignUpController>(context, listen: false)
                        .signUpPressed(),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: Provider.of<SignUpController>(context, listen: true)
                        .loggingIn
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : Text(
                        AppLocalizations.of(context)!.cont,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    ));
  }
}
