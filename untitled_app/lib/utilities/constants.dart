import 'package:flutter/material.dart';

ColorScheme lightThemeColors(context) {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF006B5E),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF76F8E1),
    onPrimaryContainer: Color(0xFF00201B),
    secondary: Color(0xFF4A635E),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFCDE8E1),
    onSecondaryContainer: Color(0xFF06201B),
    tertiary: Color(0xFF446279),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFCAE6FF),
    onTertiaryContainer: Color(0xFF001E30),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFAFDFA),
    onBackground: Color(0xFF191C1B),
    surface: Color(0xFFFAFDFA),
    onSurface: Color(0xFF191C1B),
    surfaceVariant: Color(0xFFDAE5E1),
    onSurfaceVariant: Color(0xFF3F4946),
    outline: Color(0xFF6F7976),
    onInverseSurface: Color(0xFFEFF1EF),
    inverseSurface: Color(0xFF2D3130),
    inversePrimary: Color(0xFF56DBC5),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF006B5E),
    outlineVariant: Color(0xFFBEC9C5),
    scrim: Color(0xFF000000),
  );
}

ColorScheme darkThemeColors(context) {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF56DBC5),
    onPrimary: Color(0xFF003730),
    primaryContainer: Color(0xFF005046),
    onPrimaryContainer: Color(0xFF76F8E1),
    secondary: Color(0xFFB1CCC5),
    onSecondary: Color(0xFF1C3530),
    secondaryContainer: Color(0xFF334B46),
    onSecondaryContainer: Color(0xFFCDE8E1),
    tertiary: Color(0xFFACCAE5),
    onTertiary: Color(0xFF133348),
    tertiaryContainer: Color(0xFF2C4A60),
    onTertiaryContainer: Color(0xFFCAE6FF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF191C1B),
    onBackground: Color(0xFFE0E3E1),
    surface: Color(0xFF191C1B),
    onSurface: Color(0xFFE0E3E1),
    surfaceVariant: Color(0xFF3F4946),
    onSurfaceVariant: Color(0xFFBEC9C5),
    outline: Color(0xFF899390),
    onInverseSurface: Color(0xFF191C1B),
    inverseSurface: Color(0xFFE0E3E1),
    inversePrimary: Color(0xFF006B5E),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF56DBC5),
    outlineVariant: Color(0xFF3F4946),
    scrim: Color(0xFF000000),
  );
}

// //Light Mode setup
// ColorScheme lightThemeColors(context) {
//   return const ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xff000000),
//     onPrimary: Color(0xFF505050),
//     secondary: Color.fromARGB(255, 137, 136, 218),
//     onSecondary: Color.fromARGB(255, 56, 34, 34),
//     tertiary: Color.fromARGB(255, 0, 0, 0),
//     error: Color(0xFFF32424),
//     onError: Color(0xFFF32424),
//     background: Color(0xFFFFFFFF),
//     onBackground: Color.fromARGB(255, 200, 200, 243),
//     surface: Color.fromARGB(255, 255, 255, 255),
//     onSurface: Color.fromARGB(255, 0, 0, 0),
//   );
// }

// //Dark
// ColorScheme darkThemeColors(context) {
//   return const ColorScheme(
//     brightness: Brightness.dark,
//     primary: Color(0xFFFFFFFF),
//     onPrimary: Color.fromARGB(255, 139, 139, 139),
//     secondary: Color(0xFF1F6C60),
//     onSecondary: Color(0xFFEAEAEA),
//     tertiary: Color(0xffffffff),
//     error: Color(0xFFF32424),
//     onError: Color(0xFFF32424),
//     background: Color.fromARGB(255, 12, 12, 12),
//     onBackground: Color(0xFF202020),
//     surface: Color.fromARGB(255, 0, 0, 0),
//     onSurface: Color(0xFFFFFFFF),
//   );
// }

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
const int searchPageDebounce = 1500;
const int postsOnRefresh = 10;

const double postIconSize = 17;
