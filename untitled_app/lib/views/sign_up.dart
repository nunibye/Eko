import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/sign_up_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/login_text_feild.dart';
import '../constants.dart' as c;

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final temp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignUpController(),
        builder: (context, child) {
          return Scaffold(
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
          );
        });
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
              label: AppLocalizations.of(context)!.firstName,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller1,
              inputType: TextInputType.text,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * c.loginPadding),
            CustomInputFeild(
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
      body: Center(
        child: Column(
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
              label: AppLocalizations.of(context)!.password,
              focus:
                  Provider.of<SignUpController>(context, listen: false).focus2,
              controller: Provider.of<SignUpController>(context, listen: false)
                  .controller2,
              inputType: TextInputType.visiblePassword,
              obscure: true,
            ),
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
          ],
        ),
      ),
    );
  }
}
