import 'package:flutter/material.dart';

//Light Mode setup
ColorScheme lightThemeColors(context) {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff000000),
    onPrimary: Color(0xFF505050),
    secondary: Color.fromARGB(255, 137, 136, 218),
    onSecondary: Color.fromARGB(255, 56, 34, 34),
    tertiary: Color.fromARGB(255, 0, 0, 0),
    error: Color(0xFFF32424),
    onError: Color(0xFFF32424),
    background: Color(0xFFFFFFFF),
    onBackground: Color.fromARGB(255, 200, 200, 243),
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 0, 0, 0),
  );
}

//Dark
ColorScheme darkThemeColors(context) {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFFFFF),
    onPrimary: Color.fromARGB(255, 139, 139, 139),
    secondary: Color(0xFF1F6C60),
    onSecondary: Color(0xFFEAEAEA),
    tertiary: Color(0xffffffff),
    error: Color(0xFFF32424),
    onError: Color(0xFFF32424),
    background: Color(0xFF01001A),
    onBackground: Color(0xFF202020),
    surface: Color.fromARGB(255, 0, 0, 0),
    onSurface: Color(0xFFFFFFFF),
  );
}

//Button Style
ButtonStyle buttonStyle(context) {
  return ButtonStyle(
    splashFactory: NoSplash.splashFactory,
    overlayColor: MaterialStateProperty.all(Colors.transparent),
    mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
  );
}

const double logoPaddingVert = 30;
const double logoPaddingHoriz = 0;
const double loginPadding = 0.006;
//profile pic
const int imageQuality = 85;
const double imageSize = 150;

const double postPaddingVert = 8;
const double postPaddingHoriz = 5;

const int signUpAnimationDuration = 300;
const int maxPostLines = 12;
const int maxPostChars = 160;
const int maxCommentChars = 160;
const int maxTittleChars = 60;
const int maxBioChars = 20;
const int maxBioLines = 3;
const int maxBioNameChars = 20;

const int postsOnRefresh = 10;

const double postIconSize = 17;
