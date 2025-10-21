// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? titleText;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.hintText,
    this.titleText,
    this.backgroundColor,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: titleText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: backgroundColor != null, // Só preenche se uma cor for especificada
        fillColor: backgroundColor,
      ),
    );
  }
}
