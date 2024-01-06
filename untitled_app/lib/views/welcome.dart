import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/welcome_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/get_app_fab.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = c.widthGetter(context);
    final height = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
      create: (context) => WelcomeController(context: context),
      builder: (context, child) {
        return Scaffold(
          floatingActionButton: getAppFabBuilder(),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/fog1.gif'), fit: BoxFit.cover)),
              child: Column(
                //physics: NeverScrollableScrollPhysics(),
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * .12,
                  ),
                  SizedBox(
                      height: height * .1,
                      child: Align(
                        child: Text(AppLocalizations.of(context)!.welcomeTo,
                            style: TextStyle(
                                fontSize: 45,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                      )),
                  SizedBox(
                    height: height * .35,
                    width: width,
                    child: Image.asset('images/echo.png'),
                  ),
                  SizedBox(
                    height: height * .12,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Provider.of<WelcomeController>(context, listen: false)
                          .goToLogin();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                      backgroundColor: Colors.transparent,
                      minimumSize: Size(width * .8, height * .07),
                    ),
                    child: Text(AppLocalizations.of(context)!.logIn,
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Provider.of<WelcomeController>(context, listen: false)
                          .goToSignUp();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                      backgroundColor: Colors.transparent,
                      minimumSize: Size(width * .8, height * .07),
                    ),
                    child: Text(AppLocalizations.of(context)!.createAccount,
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.onBackground)),
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
