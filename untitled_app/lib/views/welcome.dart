import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/welcome_controller.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => WelcomeController(context: context),
        builder: (context, child) {
          return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/welcome_backround.png'),
                      fit: BoxFit.cover)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Welcome to',
                          style: TextStyle(fontSize: 36, color: Colors.white)),
                      Image.asset('images/echo.png'),
                      OutlinedButton(
                        onPressed: () {
                          Provider.of<WelcomeController>(context, listen: false)
                              .onLoginButtonPressed();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(320, 60),
                        ),
                        child: const Text('Login',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      const Text(
                        '--or--',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Provider.of<WelcomeController>(context, listen: false)
                              .onCreateAccountButtonPressed();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(320, 60),
                        ),
                        child: const Text('Create Account',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
