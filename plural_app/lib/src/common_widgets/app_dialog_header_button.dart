import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/values.dart';

class AppDialogHeaderButton extends StatelessWidget {
  const AppDialogHeaderButton({
    super.key,
    required this.buttonNotifier,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.width,
  });

  // Used by forms that dynamically disable this button
  final ValueNotifier<bool> buttonNotifier;

  final Icon icon;
  final String label;
  final Function onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppWidths.w150,
      height: AppHeights.h40,
      child: ValueListenableBuilder(
        valueListenable: buttonNotifier,
        builder: (BuildContext context, bool value, Widget? _) {
          return ElevatedButton.icon(
            onPressed: value ? () => onPressed() : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.secondaryColor,
              backgroundColor: AppColors.onPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppBorderRadii.r10)),
              ),
            ),
            icon: icon,
            label: Text(label)
          );
        }
      ),
    );
  }
}