import 'package:flutter/material.dart';
import 'package:testik2/core/theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route route() => MaterialPageRoute(builder: (_) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final surfaceColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: surfaceColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          'Основные настройки приложения',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}