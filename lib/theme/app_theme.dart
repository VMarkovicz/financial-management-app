import 'package:flutter/material.dart';

class AppTheme {
  static const success = Color(0xFF68E093);
  static const error = Color(0xFFE0686A);
  static const surfaceLight = Color(0xFFF8F8F8);
  static const textDark = Color(0xFF323232);
  static const defaultGrey = Color(0xFFDCDCDC);

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: success,
      primary: success,
      error: error,
      surface: surfaceLight,
      onSurface: textDark,
    ),
  );
}
