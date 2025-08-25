import 'package:flutter/material.dart';

class MyAppTheme {
  // Cor primária customizada
  static const Color primaryColor = Color.fromARGB(255, 1, 79, 203);
  
  // Cores do VS Code Light Theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF3F3F3);
  static const Color lightSidebar = Color(0xFFF3F3F3);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightText = Color(0xFF24292F);
  static const Color lightTextSecondary = Color(0xFF656D76);
  
  // Cores do VS Code Dark Theme
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2D2D30);
  static const Color darkSidebar = Color(0xFF252526);
  static const Color darkBorder = Color(0xFF3E3E42);
  static const Color darkText = Color(0xFFCCCCCC);
  static const Color darkTextSecondary = Color(0xFF969696);

  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      surface: lightSurface,
      onSurface: lightText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightText,
      elevation: 1,
      shadowColor: lightBorder,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: lightSidebar,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: lightBackground,
      elevation: 1,
      shadowColor: lightBorder,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: lightBorder, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightText,
        side: BorderSide(color: lightBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      color: primaryColor,
      size: 20,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: lightText, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: lightText, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: lightText, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: lightText, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: lightText, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: lightText, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      bodySmall: TextStyle(color: lightTextSecondary),
      labelLarge: TextStyle(color: lightText, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: lightText, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(color: lightTextSecondary),
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
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: lightBackground,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: darkSurface,
      onSurface: darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkText,
      elevation: 1,
      shadowColor: darkBorder,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: darkSidebar,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: darkBorder, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkText,
        side: BorderSide(color: darkBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      color: primaryColor,
      size: 20,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: darkText, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: darkText, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: darkText, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: darkText, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: darkText, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      bodySmall: TextStyle(color: darkTextSecondary),
      labelLarge: TextStyle(color: darkText, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: darkText, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(color: darkTextSecondary),
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
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: darkSurface,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryColor,
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
