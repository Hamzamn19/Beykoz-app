import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;

  // Light theme colors
  static const Color lightPrimaryColor = Color(0xFF802629);
  static const Color lightSecondaryColor = Color(0xFFB85A5E);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightSurfaceColor = Colors.white;
  static const Color lightCardColor = Colors.white;
  static const Color lightTextPrimaryColor = Color(0xFF1A1A1A);
  static const Color lightTextSecondaryColor = Color(0xFF666666);
  static const Color lightDividerColor = Color(0xFFE0E0E0);

  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFFB85A5E);
  static const Color darkSecondaryColor = Color(0xFF802629);
  static const Color darkBackgroundColor = Color(0xFF2C2C2C); // More grayish
  static const Color darkSurfaceColor = Color(0xFF3A3A3A); // Lighter gray
  static const Color darkCardColor = Color(0xFF424242); // Medium gray
  static const Color darkTextPrimaryColor = Color(0xFFE0E0E0);
  static const Color darkTextSecondaryColor = Color(0xFFB0B0B0);
  static const Color darkDividerColor = Color(0xFF555555); // Lighter divider

  ThemeService() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      cardColor: lightCardColor,
      dividerColor: lightDividerColor,
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        surface: lightSurfaceColor,
        background: lightBackgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimaryColor,
        onBackground: lightTextPrimaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightPrimaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: lightTextPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: lightTextPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: lightTextPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: lightTextPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: lightTextPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: lightTextPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: lightTextPrimaryColor),
        bodyMedium: TextStyle(color: lightTextPrimaryColor),
        bodySmall: TextStyle(color: lightTextSecondaryColor),
      ),
      iconTheme: const IconThemeData(
        color: lightTextPrimaryColor,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      dividerColor: darkDividerColor,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimaryColor,
        onBackground: darkTextPrimaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkPrimaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkTextPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkTextPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: darkTextPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: darkTextPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: darkTextPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: darkTextPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: darkTextPrimaryColor),
        bodyMedium: TextStyle(color: darkTextPrimaryColor),
        bodySmall: TextStyle(color: darkTextSecondaryColor),
      ),
      iconTheme: const IconThemeData(
        color: darkTextPrimaryColor,
      ),
    );
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;
} 