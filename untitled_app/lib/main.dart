import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import 'utilities/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'utilities/constants.dart' as c;
import 'views/root_page.dart';
import 'utilities/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Untitled',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: c.lightThemeColors(context),
        useMaterial3: true,
        // Get rid of splash animation
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        // elevatedButtonTheme:
        //     ElevatedButtonThemeData(style: c.buttonStyle(context)),
        // textButtonTheme: TextButtonThemeData(style: c.buttonStyle(context)),
        // outlinedButtonTheme:
        //     OutlinedButtonThemeData(style: c.buttonStyle(context)),
        // iconButtonTheme: IconButtonThemeData(style: c.buttonStyle(context)),
      ),
      darkTheme: ThemeData(
        colorScheme: c.darkThemeColors(context),
        useMaterial3: true,
        // Get rid of splash animation
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        
        // Depends on if you want the button across the app to have splash or not
        // elevatedButtonTheme:
        //     ElevatedButtonThemeData(style: c.buttonStyle(context)),
        // textButtonTheme: TextButtonThemeData(style: c.buttonStyle(context)),
        // outlinedButtonTheme:
        //     OutlinedButtonThemeData(style: c.buttonStyle(context)),
        // iconButtonTheme: IconButtonThemeData(style: c.buttonStyle(context)),
      ),
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
      home: const RootPage(),
    );
  }
}
