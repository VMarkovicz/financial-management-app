import 'package:flutter/material.dart';
import 'package:financial_management_app/theme/app_theme.dart';

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
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor = ButtonType.primary,
    this.fontSize,
    this.fontWeightType = FontWeightType.normal,
    this.isLoading = false,
  });

  _getBackgoundColor() {
    switch (backgroundColor) {
      case ButtonType.primary:
        return AppTheme.success;
      case ButtonType.secondary:
        return AppTheme.error;
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
          foregroundColor:
              backgroundColor == ButtonType.ghost
                  ? AppTheme.textDark
                  : Colors.white,
          elevation: 0,
          surfaceTintColor:
              backgroundColor == ButtonType.ghost ? Colors.transparent : null,
          shadowColor:
              backgroundColor == ButtonType.ghost ? Colors.transparent : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side:
                backgroundColor == ButtonType.ghost
                    ? BorderSide(color: AppTheme.defaultGrey, width: 1.0)
                    : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize ?? 18,
                    fontWeight: _getFontWeight(),
                    color:
                        backgroundColor == ButtonType.ghost
                            ? AppTheme.textDark
                            : Colors.white,
                  ),
                ),
      ),
    );
  }
}
