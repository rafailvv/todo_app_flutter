import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context, {required bool isDarkMode}) {
    return isDarkMode ? darkTheme(context) : lightTheme(context);
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      // Параметры светлой темы
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      // Параметры темной темы
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
