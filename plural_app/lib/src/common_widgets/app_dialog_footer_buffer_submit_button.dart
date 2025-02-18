import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/strings.dart';

class AppDialogFooterBufferSubmitButton extends StatelessWidget {
  AppDialogFooterBufferSubmitButton({
    required this.callback,
    this.namedArguments,
    this.positionalArguments,
  });

  final Function callback;
  final Map<Symbol, dynamic>? namedArguments;
  final List<dynamic>? positionalArguments;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppDialogTooltips.saveChanges,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.surface,
          shape: CircleBorder(),
        ),
        onPressed: () => Function.apply(callback, positionalArguments, namedArguments),
        child: Icon(Icons.save_alt)
      ),
    );
  }
}