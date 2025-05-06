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
    return ListTile(
      leading: Icon(icon, color: Palete.primary),
      title: Text(
        title,
        style: const TextStyle(color: Palete.lightText),
      ),
      trailing: const Icon(Icons.chevron_right, color: Palete.lightText),
      onTap: onTap ?? () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}