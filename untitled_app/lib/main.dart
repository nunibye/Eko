import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_app/models/firebase_helper.dart';
import 'package:untitled_app/models/notification_service.dart';
import 'utilities/themes/dark_theme_provider.dart';
import 'utilities/themes/dark_theme_styles.dart';
import 'utilities/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'utilities/router.dart';
import 'utilities/locator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHelper.setupFirebase();
  // await NotificationService.initializeNotification();
  // Handle foreground messages.
 FirebaseMessaging.onMessage.listen((RemoteMessage message) {
 print('Message received: ${message.notification?.body}');
 });


  setupLocator();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        return ChangeNotifierProvider(
          // is this okay that i changed it so that it can rebuild it? or should it be changed

          create: (_) => DarkThemeProvider(),
          builder: (context, child) {
            final themeChangeProvider = Provider.of<DarkThemeProvider>(context);
            return SafeArea(
              child: MaterialApp.router(
                title: 'Untitled',
                debugShowCheckedModeBanner: false,
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                themeMode: ThemeMode.dark,
                
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'), // English
                  Locale('es'), // Spanish
                ],
                routerConfig: goRouter,
              ),
            );
          },
        );
      },
    );
  }
}
