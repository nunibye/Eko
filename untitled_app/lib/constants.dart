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
    secondary: Color(0xff1ce0d1),
    onSecondary: Color(0xFFEAEAEA),
    tertiary: Color(0xffffffff),
    error: Color(0xFFF32424),
    onError: Color(0xFFF32424),
    background: Color(0xFF101010),
    onBackground: Color(0xFF202020),
    surface: Color.fromARGB(255, 0, 0, 0),
    onSurface: Color(0xFFFFFFFF),
  );
}