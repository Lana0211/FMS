import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFa3c1e3); // Light blue color

  static const Color floatingActionButtonColor = Colors.white;

  static const Color listBackgroundColor = Colors.white70;

  static const Color textColor = Colors.black87;

  // Define the light theme colors
  static final ThemeData lightTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: floatingActionButtonColor,
    ),

    // Define the default font family.
    fontFamily: 'Montserrat',

    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor), // replaces bodyText1
      bodyMedium: TextStyle(color: textColor), // replaces bodyText2
      titleLarge: TextStyle(color: textColor, fontSize: 20.0), // replaces headline6
    ),

    // color and size for icons.
    iconTheme: const IconThemeData(
      color: textColor,
    ),

    // AppBar properties.
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20.0,
      ),
    ),

  );

}