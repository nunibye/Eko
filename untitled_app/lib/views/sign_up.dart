import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/sign_up_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/login_text_feild.dart';
import '../utilities/constants.dart' as c;

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final temp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpController(context: context),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<SignUpController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leadingWidth: 150,
              leading: IconButton(
                icon: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    Consumer<SignUpController>(
                      builder: (context, signUpController, _) => Text(
                        signUpController.firstPage
                            ? AppLocalizations.of(context)!.logIn
                            : AppLocalizations.of(context)!.previous,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
                onPressed: () =>
                    Provider.of<SignUpController>(context, listen: false)
                        .backPressed(),
              ),
              actions: [
                if (!Provider.of<SignUpController>(context, listen: true)
                    .lastPage)
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () =>
                        Provider.of<SignUpController>(context, listen: false)
                            .forwardPressed(),
                  )
              ],
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                AppLocalizations.of(context)!.signUp,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: Provider.of<SignUpController>(context, listen: false)
                  .pageController,
              children: const <Widget>[
                GetLegalName(),
                GetUserName(),
                GetEmail(),
                Placeholder(), //FIXME for some reson this stops everything from breaking
              ],
            ),
          ),
        );
      },
    );
  }
}

class GetLegalName extends StatelessWidget {
  const GetLegalName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CustomInputFeild(
              focus: Provider.of<SignUpController>(context, listen: false)
                  .focus1,
              label: AppLocalizations.of(context)!.firstName,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller1,
              inputType: TextInputType.text,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * c.loginPadding),
            CustomInputFeild(
              textInputAction: TextInputAction.go,
              focus: Provider.of<SignUpController>(context, listen: false)
                  .focus2,
              onEditingComplete: () =>
                  Provider.of<SignUpController>(context, listen: false)
                      .keyboardGoToNextPage(),
              label: AppLocalizations.of(context)!.lastName,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller2,
              inputType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}

class GetUserName extends StatelessWidget {
  const GetUserName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CustomInputFeild(
              focus:
                  Provider.of<SignUpController>(context, listen: false).focus1,
              textInputAction: TextInputAction.go,
              onEditingComplete: () =>
                  Provider.of<SignUpController>(context, listen: false)
                      .keyboardGoToNextPage(),
              label: AppLocalizations.of(context)!.userName,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller1,
              inputType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}

class GetEmail extends StatelessWidget {
  const GetEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),child: Center(
        child: ListView(
          children: [
            CustomInputFeild(
              label: AppLocalizations.of(context)!.email,
              focus:
                  Provider.of<SignUpController>(context, listen: false).focus1,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller1,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * c.loginPadding),
            CustomInputFeild(
              onChanged: (s) =>
                  Provider.of<SignUpController>(context, listen: false)
                      .passwordChanged(),
              onEditingComplete: () =>
                  Provider.of<SignUpController>(context, listen: false)
                      .focus3
                      .requestFocus(),
              label: AppLocalizations.of(context)!.password,
              focus:
                  Provider.of<SignUpController>(context, listen: false).focus2,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller2,
              inputType: TextInputType.visiblePassword,
              password: true,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * c.loginPadding),
            CustomInputFeild(
              onChanged: (s) =>
                  Provider.of<SignUpController>(context, listen: false)
                      .passwordChanged(),
              onEditingComplete: () =>
                  Provider.of<SignUpController>(context, listen: false)
                      .signUpPressed(),
              textInputAction: TextInputAction.done,
              label: AppLocalizations.of(context)!.confirmPassword,
              focus:
                  Provider.of<SignUpController>(context, listen: false).focus3,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller3,
              inputType: TextInputType.visiblePassword,
              password: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * c.loginPadding,
                  ),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: Provider.of<SignUpController>(context, listen: true)
                    .passwordPercent,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Container(alignment: Alignment.centerLeft,child: Consumer<SignUpController>(
              builder: (context, signUpController, _) => Text(
                  "${signUpController.passed[0]}${AppLocalizations.of(context)!.passwordLen}\n"
                  "${signUpController.passed[1]}${AppLocalizations.of(context)!.passwordLower}\n"
                  "${signUpController.passed[2]}${AppLocalizations.of(context)!.passwordUpper}\n"
                  "${signUpController.passed[3]}${AppLocalizations.of(context)!.passwordNumber}\n"
                  "${signUpController.passed[4]}${AppLocalizations.of(context)!.passwordSpecial}\n"
                  "${signUpController.passed[5]}${AppLocalizations.of(context)!.passwordMatch}\n",
                  style: const  TextStyle(fontSize: 18),),
            ),),
            //const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.15,
              child: TextButton(
                onPressed: () =>
                    Provider.of<SignUpController>(context, listen: false)
                        .signUpPressed(),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                child: Provider.of<SignUpController>(context, listen: true)
                        .loggingIn
                    ? const CircularProgressIndicator()
                    : Text(
                        AppLocalizations.of(context)!.signUp,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        ),
      ),)
    );
  }
}
