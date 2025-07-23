import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class RouteToViewButton extends StatelessWidget {
  const RouteToViewButton({
    required this.icon,
    required this.message,
    required this.onPressed,
  });

  final IconData icon;
  final String message;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: AppElevations.e0,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
        ),
        onPressed: () => onPressed(),
        child: Icon(icon)
      ),
    );
  }
}