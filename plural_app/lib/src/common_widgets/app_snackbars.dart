import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/constants/app_values.dart';

class AppSnackbars {
  static SnackBar successSnackbar(String mainMessage, String boldMessage) {
    return SnackBar(
      backgroundColor: Colors.green[400],
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.check,
            color: Colors.green[900],
          ),
          Expanded(
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: mainMessage),
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
      duration: Duration(seconds: SnackBarDurations.s9),
      showCloseIcon: true,
      closeIconColor: Colors.black,
      width: AppWidths.w600
    );
  }
}