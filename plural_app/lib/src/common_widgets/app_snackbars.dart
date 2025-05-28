import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/themes.dart';

enum SnackbarType {
  error,
  success
}

typedef SnackbarValues = ({
  Color backgroundColor,
  Color closeIconColor,
  IconData icon,
  Color iconColor,
  Color textColor,
});
class AppSnackbars {

  static SnackbarValues _getValues(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return (
          backgroundColor: AppThemes.snackbarErrorBackgroundColor,
          closeIconColor: AppThemes.snackbarErrorCloseIconColor,
          icon: Icons.link_off,
          iconColor: AppThemes.snackbarErrorIconColor,
          textColor: AppThemes.snackbarErrorTextColor,
        );
      case SnackbarType.success:
        return (
          backgroundColor: AppThemes.snackbarSuccessBackgroundColor,
          closeIconColor: AppThemes.snackbarSuccessCloseIconColor,
          icon: Icons.check,
          iconColor: AppThemes.snackbarSuccessIconColor,
          textColor: AppThemes.snackbarSuccessTextColor,
        );
    }
  }

  static SnackBar getSnackbar(
    String mainMessage,
    {
      String boldMessage = "",
      Duration duration = AppDurations.s3,
      bool showCloseIcon = true,
      required SnackbarType snackbarType,
    }
  ) {
    var snackbarValues = _getValues(snackbarType);

    return SnackBar(
      backgroundColor: snackbarValues.backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            snackbarValues.icon,
            color: snackbarValues.iconColor,
          ),
          Expanded(
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: TextStyle(color: snackbarValues.textColor),
                children: [
                  TextSpan(text: "$mainMessage "), // note trailing space
                  TextSpan(
                    text: boldMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      duration: duration,
      showCloseIcon: showCloseIcon,
      closeIconColor: snackbarValues.closeIconColor,
      width: AppWidths.w600
    );
  }
}