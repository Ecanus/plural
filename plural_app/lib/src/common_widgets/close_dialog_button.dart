import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class CloseDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: AppBorderRadii.r30,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.close,
          size: AppIconSizes.s30
        ),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}