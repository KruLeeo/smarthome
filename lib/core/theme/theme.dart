import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Palete.primary,
    scaffoldBackgroundColor: Palete.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Palete.darkSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Palete.lightText),
      titleTextStyle: TextStyle(
        color: Palete.lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: Palete.lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      buttonColor: Palete.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Palete.primary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palete.lightBackground,
      selectedItemColor: Palete.primary,
      unselectedItemColor: Palete.lightText.withOpacity(0.6),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Palete.lightText),
      bodyMedium: TextStyle(color: Palete.lightText),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Palete.primary,
    scaffoldBackgroundColor: Palete.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Palete.darkSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Palete.darkText),
      titleTextStyle: TextStyle(
        color: Palete.darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: Palete.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      buttonColor: Palete.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Palete.primary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palete.darkBackground,
      selectedItemColor: Palete.primary,
      unselectedItemColor: Palete.darkText.withOpacity(0.6),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Palete.darkText),
      bodyMedium: TextStyle(color: Palete.darkText),
    ),
  );
}