import 'package:flutter/material.dart';
import 'package:testik2/core/theme/colors.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final iconColor = isDarkTheme ? Palete.primary : Palete.primary; // Можно использовать разные цвета для тем

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: Icon(Icons.chevron_right, color: textColor),
      onTap: onTap ?? () {
        Navigator.pushNamed(context, route);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 24,
    );
  }
}