import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label; 
  final bool isPassword;
  final bool isEmail;
  final dynamic controller;
  final dynamic validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.isEmail = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
          ),
        ),
      ),
    );
  }
}