import 'package:flutter/material.dart';

class AppTheme {
  // Define the primary color as seen in the image
  static const Color primaryColor = Color(0xFFa3c1e3); // Light blue color

  // Assuming you want a similar color for the floating action button
  static const Color floatingActionButtonColor = Colors.white;

  // If the text color is not provided, we're defaulting to dark grey
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
    fontFamily: 'Montserrat', // Make sure you've added this font in your pubspec.yaml

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor), // replaces bodyText1
      bodyMedium: TextStyle(color: textColor), // replaces bodyText2
      titleLarge: TextStyle(color: textColor, fontSize: 20.0), // replaces headline6
      // Add other TextStyle objects as needed
    ),

    // Define the default IconTheme. Use this to specify the default
    // color and size for icons.
    iconTheme: const IconThemeData(
      color: textColor,
    ),

    // Define the default AppBarTheme. Use this to specify the default
    // AppBar properties.
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20.0,
      ),
    ),

    // Add other theme customizations as needed
    // You can also define custom colors and use them throughout the theme
  );

// If you need a dark theme, you can also define it here.
}