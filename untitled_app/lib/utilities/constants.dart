import 'package:flutter/material.dart';

ColorScheme lightThemeColors(context) {
  return const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF5056A9),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE0E0FF),
  onPrimaryContainer: Color(0xFF050865),
  secondary: Color(0xFF5C5D72),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE1E0F9),
  onSecondaryContainer: Color(0xFF191A2C),
  tertiary: Color(0xFF4758A9),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFDDE1FF),
  onTertiaryContainer: Color(0xFF001257),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF1B1B1F),
  surfaceVariant: Color(0xFFE3E1EC),
  onSurfaceVariant: Color(0xFF46464F),
  outline: Color(0xFF777680),
  onInverseSurface: Color(0xFFF3EFF4),
  inverseSurface: Color(0xFF303034),
  inversePrimary: Color(0xFFBEC2FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF5056A9),
  outlineVariant: Color(0xFFC7C5D0),
  scrim: Color(0xFF000000),
);
}

ColorScheme darkThemeColors(context) {
  return const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFBEC2FF),
  onPrimary: Color(0xFF202578),
  primaryContainer: Color(0xFF383E8F),
  onPrimaryContainer: Color(0xFFE0E0FF),
  secondary: Color(0xFFC5C4DD),
  onSecondary: Color(0xFF2E2F42),
  secondaryContainer: Color(0xFF444559),
  onSecondaryContainer: Color(0xFFE1E0F9),
  tertiary: Color(0xFFB9C3FF),
  onTertiary: Color(0xFF132778),
  tertiaryContainer: Color(0xFF2E4090),
  onTertiaryContainer: Color(0xFFDDE1FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF000000), //0xFF191C1B
  onBackground: Color(0xFFE5E1E6),
  surface: Color(0xFF1B1B1F),
  onSurface: Color(0xFFE5E1E6),
  surfaceVariant: Color(0xFF46464F),
  onSurfaceVariant: Color(0xFFC7C5D0),
  outline: Color(0xFF91909A),
  onInverseSurface: Color(0xFF1B1B1F),
  inverseSurface: Color(0xFFE5E1E6),
  inversePrimary: Color(0xFF5056A9),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFBEC2FF),
  outlineVariant: Color(0xFF46464F),
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
const int maxPostChars = 300;
const int maxCommentChars = 160;
const int maxTitleChars = 100;
const int maxBioChars = 20;
const int maxBioLines = 3;
const int maxNameChars = 20;
const int maxUsernameChars = 12;
const int searchPageDebounce = 1500;
const int postsOnRefresh = 10;
const int activitiesPerRequest = 15;
const double navBarIconSize = 27;
const double navBarIconSizeAdder = 4;
const double navBarHeight = navBarIconSize + 20;
const double postIconSize = 17;
const int maxGroupName = 50;
const int minGroupName = 3;
const int maxGroupDesc = 300;
const String userNameReqs = r'^[a-z0-9._]{3,12}$';
const double dividerWidth = 0.5;
