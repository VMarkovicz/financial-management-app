import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool isEmail;
  final dynamic controller;
  final dynamic validator;
  final String? initialValue;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.isEmail = false,
    required this.controller,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        controller: controller,
        validator: validator,
        initialValue: initialValue,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigoAccent, width: 2.0),
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
