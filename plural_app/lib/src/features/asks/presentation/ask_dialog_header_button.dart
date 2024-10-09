import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

class AskDialogHeaderButton extends StatelessWidget {
  const AskDialogHeaderButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final Function onPressed;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppWidths.w150,
      height: AppHeights.h40,
      child: ElevatedButton.icon(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.secondaryColor,
          backgroundColor: AppColors.onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppBorderRadii.r10)),
          ),
        ),
        icon: icon,
        label: Text(label)
      ),
    );
  }
}