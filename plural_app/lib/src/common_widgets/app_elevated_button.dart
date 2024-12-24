import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';


class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
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
    return SizedBox(
      width: double.infinity,
      height: AppButtonSizes.s50,
      child: ElevatedButton(
        onPressed: () => Function.apply(callback, positionalArguments, namedArguments),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadii.r5),
          )
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}