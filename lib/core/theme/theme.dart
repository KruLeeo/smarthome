
import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Palete.primary,
    scaffoldBackgroundColor: Palete.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Palete.darkSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palete.darkBackground,
      selectedItemColor: Palete.primary,
      unselectedItemColor: Palete.lightText,
    ),
  );
}