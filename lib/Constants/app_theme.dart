import 'package:flutter/material.dart';

class AppTheme {
  static const Color green = Colors.green;
  static const Color darkBg = Color(0xFF18122B);
  static const Color darkCard = Color(0xFF23203B);
  static const Color darkAccent = Colors.green;
  static const Color darkText = Colors.white;
  static const Color darkHint = Colors.white54;
  static const Color darkDivider = Colors.white24;

  static const Color lightBg = Colors.white;
  static const Color lightCard = Color(0xFFF5F7FA);
  static const Color lightAccent = Colors.green;
  static const Color lightText = Colors.black;
  static const Color lightHint = Colors.black54;
  static const Color lightDivider = Colors.black12;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    cardColor: darkCard,
    primaryColor: darkAccent,
    colorScheme: const ColorScheme.dark(
      primary: darkAccent,
      background: darkBg,
      surface: darkCard,
      onPrimary: darkText,
      onBackground: darkText,
      onSurface: darkText,
      secondary: darkAccent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      hintStyle: const TextStyle(color: darkHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold),
    ),
    dividerColor: darkDivider,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: darkText,
      elevation: 0,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    cardColor: lightCard,
    primaryColor: lightAccent,
    colorScheme: const ColorScheme.light(
      primary: lightAccent,
      background: lightBg,
      surface: lightCard,
      onPrimary: lightText,
      onBackground: lightText,
      onSurface: lightText,
      secondary: lightAccent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightCard,
      hintStyle: TextStyle(color: lightHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      titleLarge: TextStyle(color: lightText, fontWeight: FontWeight.bold),
    ),
    dividerColor: lightDivider,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBg,
      foregroundColor: lightText,
      elevation: 0,
    ),
  );
}
