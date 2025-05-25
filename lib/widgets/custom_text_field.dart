import 'package:financial_management_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool isEmail;
  final dynamic controller;
  final dynamic validator;
  final String? initialValue;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.isEmail = false,
    required this.controller,
    this.validator,
    this.initialValue,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        controller: controller,
        validator: validator,
        initialValue: initialValue,
        keyboardType:
            keyboardType ??
            (isEmail ? TextInputType.emailAddress : TextInputType.text),
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.success, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 178, 178, 178),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
