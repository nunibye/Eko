import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/presence_manager.dart';
import 'package:untitled_app/utilities/locator.dart';
import "../utilities/constants.dart" as c;

class InvalidSessionPage extends StatelessWidget {
  const InvalidSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = c.widthGetter(context);
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.8,
                child: Text(
                  AppLocalizations.of(context)!.invalidSession,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.45,
                height: width * 0.15,
                child: TextButton(
                  onPressed: () => locator<PresenceManager>().updateSessionId(),
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
      ),
    );
  }
}
