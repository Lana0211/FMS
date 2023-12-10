import 'package:flutter/material.dart';
import 'home.dart' as Home; // Import home.dart with a prefix
import 'total.dart';

import 'src/theme.dart'; // Import the theme file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme, // Use the light theme
      home: Home.HomeScreen(), // Use the HomeScreen from home.dart
    );
  }
}

// Remote