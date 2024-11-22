import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF1A1D1F);
  static const Color darkSurface = Color(0xFF2C2F33);
  static const Color appBarColor = Color(0xFF1E1E2D);

  static ThemeData get light => _lightTheme;
  static ThemeData get dark => _darkTheme;

  static ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
  );
  static ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  // Setters for the themes
  static set lightTheme(ThemeData theme) => _lightTheme = theme;
  static set darkTheme(ThemeData theme) => _darkTheme = theme;

  // Setters for the themes
}
