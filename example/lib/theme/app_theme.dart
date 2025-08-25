import 'package:flutter/material.dart';

class MyAppTheme {
  static const Color darkBackground = Color(0xFF1A1D1F);
  static const Color darkSurface = Color(0xFF2C2F33);
  static const Color appBarColor =
      Color(0xFF1E1E2D); // Default dark color for AppBar

  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    colorSchemeSeed: Colors.blue,
  );
  static final light2 = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor, // AppBar stays dark in light mode
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor:
          appBarColor, // Updated drawer background color for light theme
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.grey, // Cor para ícones não selecionados
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.blue, // Cor para ícones selecionados
      size: 24,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      bodyMedium: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      bodySmall: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.black12,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2C2F33),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF2C2F33),
      surfaceTintColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.blue, // Cor para ícones selecionados
      size: 24,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Color.fromARGB(255, 218, 214, 214),
      ),
      bodyMedium: TextStyle(
        color: Color.fromARGB(255, 218, 214, 214),
      ),
      bodySmall: TextStyle(
        color: Color.fromARGB(255, 218, 214, 214),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.white12,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
