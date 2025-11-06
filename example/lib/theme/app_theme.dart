import 'package:flutter/material.dart';

class MyAppTheme {
  // ========== TEMA LIGHT ==========
  // Background: #F0F0F0
  static const Color lightBackground = Color(0xFFF0F0F0);

  // Card: #FEFEFE
  static const Color lightCard = Color(0xFFFEFEFE);

  // Títulos de texto: #0C0C0C
  static const Color lightTitleText = Color(0xFF0C0C0C);

  // Cor primária: #411E5A
  static const Color lightPrimary = Color(0xFF411E5A);

  // Cor secundária: #FFB200
  static const Color lightSecondary = Color(0xFFFFB200);

  // Cores auxiliares para bordas e textos secundários
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightTextSecondary = Color(0xFF757575);

  // ========== TEMA DARK ==========
  // Background: #0C0C0C
  static const Color darkBackground = Color(0xFF0C0C0C);

  // Card: #4F4F4F
  static const Color darkCard = Color(0xFF4F4F4F);

  // Títulos de texto: #E0E0E0
  static const Color darkTitleText = Color(0xFFE0E0E0);

  // Cor primária: #FFB200
  static const Color darkPrimary = Color(0xFFFFB200);

  // Cor secundária: #411E5A
  static const Color darkSecondary = Color(0xFF411E5A);

  // Cores auxiliares para bordas e textos secundários
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);

  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      onPrimary: Colors.white, // Texto sobre a cor primária
      secondary: lightSecondary,
      onSecondary: lightTitleText, // Texto sobre a cor secundária
      surface: lightCard,
      onSurface: lightTitleText,
      background: lightBackground,
      onBackground: lightTitleText,
      error: const Color(0xFFD32F2F),
      onError: Colors.white,
      outline: lightBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: lightCard,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: lightCard,
      elevation: 2,
      shadowColor: lightBorder,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimary,
        side: const BorderSide(color: lightPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: lightTextSecondary,
      size: 20,
    ),
    primaryIconTheme: const IconThemeData(
      color: lightPrimary,
      size: 20,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: lightTitleText, fontWeight: FontWeight.w700, fontSize: 32),
      headlineMedium: TextStyle(color: lightTitleText, fontWeight: FontWeight.w700, fontSize: 28),
      headlineSmall: TextStyle(color: lightTitleText, fontWeight: FontWeight.w600, fontSize: 24),
      titleLarge: TextStyle(color: lightTitleText, fontWeight: FontWeight.w600, fontSize: 22),
      titleMedium: TextStyle(color: lightTitleText, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: TextStyle(color: lightTitleText, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: TextStyle(color: lightTitleText, fontSize: 16),
      bodyMedium: TextStyle(color: lightTitleText, fontSize: 14),
      bodySmall: TextStyle(color: lightTextSecondary, fontSize: 12),
      labelLarge: TextStyle(color: lightTitleText, fontWeight: FontWeight.w500, fontSize: 14),
      labelMedium: TextStyle(color: lightTextSecondary, fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall: TextStyle(color: lightTextSecondary, fontSize: 11),
    ),
    dividerTheme: const DividerThemeData(
      color: lightBorder,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: darkTitleText, // Texto sobre a cor primária
      secondary: darkSecondary,
      onSecondary: Colors.white, // Texto sobre a cor secundária
      surface: darkCard,
      onSurface: darkTitleText,
      background: darkBackground,
      onBackground: darkTitleText,
      error: const Color(0xFFEF5350),
      onError: Colors.white,
      outline: darkBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimary,
      foregroundColor: darkTitleText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: darkTitleText),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: darkCard,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 2,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkTitleText,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimary,
        side: const BorderSide(color: darkPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: darkTextSecondary,
      size: 20,
    ),
    primaryIconTheme: const IconThemeData(
      color: darkPrimary,
      size: 20,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: darkTitleText, fontWeight: FontWeight.w700, fontSize: 32),
      headlineMedium: TextStyle(color: darkTitleText, fontWeight: FontWeight.w700, fontSize: 28),
      headlineSmall: TextStyle(color: darkTitleText, fontWeight: FontWeight.w600, fontSize: 24),
      titleLarge: TextStyle(color: darkTitleText, fontWeight: FontWeight.w600, fontSize: 22),
      titleMedium: TextStyle(color: darkTitleText, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: TextStyle(color: darkTitleText, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: TextStyle(color: darkTitleText, fontSize: 16),
      bodyMedium: TextStyle(color: darkTitleText, fontSize: 14),
      bodySmall: TextStyle(color: darkTextSecondary, fontSize: 12),
      labelLarge: TextStyle(color: darkTitleText, fontWeight: FontWeight.w500, fontSize: 14),
      labelMedium: TextStyle(color: darkTextSecondary, fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall: TextStyle(color: darkTextSecondary, fontSize: 11),
    ),
    dividerTheme: const DividerThemeData(
      color: darkBorder,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
      filled: true,
      fillColor: darkCard,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCard,
      selectedItemColor: darkPrimary,
      unselectedItemColor: darkTextSecondary,
      selectedIconTheme: IconThemeData(size: 20),
      unselectedIconTheme: IconThemeData(size: 20),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
