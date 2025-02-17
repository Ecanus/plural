import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
      ),
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