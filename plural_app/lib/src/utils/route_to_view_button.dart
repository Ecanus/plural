import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class RouteToViewButton extends StatelessWidget {
  const RouteToViewButton({
    this.actionCallback,
    this.callback,
    required this.icon,
    required this.message,
  }) : assert(
    actionCallback == null || callback == null,
    "Cannot provide both actionCallback and callback"
  );

  final void Function(BuildContext)? actionCallback;
  final void Function()? callback;
  final IconData icon;
  final String message;

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
        onPressed: () {
          if (callback != null) callback!();
          if (actionCallback != null) actionCallback!(context);
        },
        child: Icon(icon)
      ),
    );
  }
}