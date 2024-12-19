import 'package:flutter/material.dart';
import 'package:plural_app/src/constants/themes.dart';

class AppIcons {
  static Icon isValid = Icon(
    Icons.check,
    color: AppThemes.successColor
  );

  static Icon isInvalid = Icon(
    Icons.close,
    color: AppThemes.colorScheme.onPrimary,
  );
}