import 'package:flutter/material.dart';

class PaperContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final Widget? child;
  final Color? backgroundColor;

  const PaperContainer({
    super.key,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
