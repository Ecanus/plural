import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

class AppCloseConfirmDialogButton extends StatelessWidget {
  const AppCloseConfirmDialogButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: AppWidths.w40,
        minHeight: AppHeights.h40,
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadii.r5)
            )
        ),
        icon: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.secondary,
        )
      ),
    );
  }
}