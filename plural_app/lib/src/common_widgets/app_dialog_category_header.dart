import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppDialogCategoryHeader extends StatelessWidget {
  const AppDialogCategoryHeader({
    this.color,
    this.fontSize = AppFontSizes.s16,
    this.fontWeight = FontWeight.w400,
    required this.text,
  });

  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: color ?? Theme.of(context).colorScheme.primary,
            fontSize: fontSize,
            fontWeight: fontWeight,
          )
        ),
      ],
    );
  }
}