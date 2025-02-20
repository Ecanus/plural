import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/themes.dart';

class AppStyles {
  static OutlineInputBorder textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadii.r5),
    borderSide: BorderSide(
      color: AppThemes.colorScheme.onPrimary,
      width: AppWidths.w1pt5,
    )
  );

  static OutlineInputBorder textFieldFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadii.r50),
    borderSide: BorderSide(
      color: AppThemes.colorScheme.onPrimary,
      width: AppWidths.w3
    ),
  );

  static OutlineInputBorder textFieldFocusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadii.r50),
    borderSide: BorderSide(
      color: AppThemes.colorScheme.error,
      width: AppWidths.w3
    ),
  );

  static WidgetStateTextStyle floatingLabelStyle = WidgetStateTextStyle.resolveWith(
    (Set<WidgetState> states) {
      final Color color = states.contains(WidgetState.error) ?
        AppThemes.colorScheme.error
        : AppThemes.colorScheme.onPrimary;

      return TextStyle(color: color);
    }
  );
}