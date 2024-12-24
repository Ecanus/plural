import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';


class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    required this.callback,
    this.icon,
    required this.label,
    this.namedArguments,
    this.positionalArguments,
  });

  final Function callback;
  final IconData? icon;
  final String label;
  final Map<Symbol, dynamic>? namedArguments;
  final List<dynamic>? positionalArguments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppButtonSizes.s50,
      child: ElevatedButton.icon(
        onPressed: () => Function.apply(callback, positionalArguments, namedArguments),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadii.r5),
          )
        ),
        icon: icon != null ?
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          )
          : null,
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}