import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/text_themes.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.callback,
    this.fontSize,
    this.fontWeight,
    required this.label,
    this.namedArguments,
    this.positionalArguments,
  });

  final Function callback;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String label;
  final Map<Symbol, dynamic>? namedArguments;
  final List<dynamic>? positionalArguments;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Function.apply(callback, positionalArguments, namedArguments),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        overlayColor: Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: fontSize ?? AppFontSizes.s13,
          fontWeight: fontWeight ?? fontWeightMedium,
          letterSpacing: AppFontLetterSpacing.s0pt5
        ),
      ),
    );
  }
}