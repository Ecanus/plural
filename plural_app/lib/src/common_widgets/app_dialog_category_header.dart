import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppDialogCategoryHeader extends StatelessWidget {
  const AppDialogCategoryHeader({
    this.color,
    required this.text,
  });

  final Color? color;
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
            fontSize: AppFontSizes.s16,
            fontWeight: FontWeight.w400,
          )
        ),
      ],
    );
  }
}