import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black), // Цвет вводимого текста (чёрный)
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Palete.lightText), // Цвет подсказки
      ),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
