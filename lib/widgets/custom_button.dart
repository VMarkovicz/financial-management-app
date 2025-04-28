import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, ghost }

enum FontWeightType { thin, normal, bold, extraBold }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final ButtonType backgroundColor;
  final double? fontSize;
  final FontWeightType fontWeightType;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor = ButtonType.primary,
    this.fontSize,
    this.fontWeightType = FontWeightType.normal,
  });

  _getBackgoundColor() {
    switch (backgroundColor) {
      case ButtonType.primary:
        return const Color(0xFF68E093);
      case ButtonType.secondary:
        return Colors.red;
      case ButtonType.ghost:
        return Colors.transparent;
    }
  }

  _getFontWeight() {
    switch (fontWeightType) {
      case FontWeightType.thin:
        return FontWeight.w200;
      case FontWeightType.normal:
        return FontWeight.normal;
      case FontWeightType.bold:
        return FontWeight.bold;
      case FontWeightType.extraBold:
        return FontWeight.w800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgoundColor(),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 18,
            fontWeight: _getFontWeight(),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
