import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: AppColors.darkGrey1,
        shape: CircleBorder()
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.close),
        color: AppColors.secondaryColor,
      ),
    );
  }
}