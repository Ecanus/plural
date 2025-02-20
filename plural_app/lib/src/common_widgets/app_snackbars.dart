import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/themes.dart';

class AppSnackbars {
  static SnackBar getSuccessSnackbar(
    String mainMessage,
    {
      String boldMessage = "",
      Duration duration = AppDurations.s3,
      showCloseIcon = true,
    }
  ) {
    return SnackBar(
      backgroundColor: AppThemes.snackbarBackgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.check,
            color: AppThemes.snackbarIconColor,
          ),
          Expanded(
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: TextStyle(color: AppThemes.snackbarTextColor),
                children: [
                  TextSpan(text: "$mainMessage "),
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
      closeIconColor: AppThemes.snackbarCloseIconColor,
      width: AppWidths.w600
    );
  }
}