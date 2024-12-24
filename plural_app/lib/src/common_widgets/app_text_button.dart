import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/text_themes.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.callback,
    required this.label,
    this.positionalArguments,
    this.namedArguments,
  });

  final Function callback;
  final String label;
  final List<dynamic>? positionalArguments;
  final Map<Symbol, dynamic>? namedArguments;

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
          fontSize: AppFontSizes.s13,
          fontWeight: fontWeightRegular,
          letterSpacing: AppFontLetterSpacing.s0p5
        ),
      ),
    );
  }
}