import '../constants.dart' as c;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    final theme = ThemeData(
      colorScheme: isDarkTheme
          ? c.darkThemeColors(context)
          : c.lightThemeColors(context),
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
    );
    return theme.copyWith(
      textTheme: GoogleFonts.notoSansTextTheme(theme.textTheme),
    );
  }
}
