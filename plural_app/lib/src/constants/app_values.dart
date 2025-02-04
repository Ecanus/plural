import "package:flutter/material.dart";

class AppColors {
  static const primaryColor = Colors.grey; // Use theme finally
  static const secondaryColor = Colors.white;
  static const onPrimaryColor = Colors.black;
  static const darkGrey1 = Color.fromARGB(255, 51, 51, 51);
  static const darkGrey2 = Color.fromARGB(255, 29, 29, 29);
  static const lightGrey = Colors.grey;
  static const lightShadow = Color.fromARGB(255, 92, 92, 92);
}

class AppDateValues {
  static const datePickerThreshold = Duration(days: 365);
}

class AppDialogValues {
  static const blurRadius = 5.0;
  static const spreadRadius = 1.0;
  static const offset = Offset(0, -1.0); // Top
}

class AppDialogNavBarValues {
  static const blurRadius = 6.0;
  static const spreadRadius = 1.0;
  static const offset = Offset(0, -1.0); // Top
}

class AppMaxLengthValues {
  static const max1 = 1;
  static const max4 = 4;
  static const max20 = 20;
  static const max30 = 30;
  static const max50 = 50;
  static const max75 = 75;
  static const max250 = 250;
}

class AppMaxLinesValues {
  static const max1 = 1;
}

class AppOpacities {
  static const point3 = 0.3;
}

class GardenValues {
  static const numTimelineAsks = 3;
  static const clockRefreshRate = 60;
}

class SnackBarDurations {
  static const s9 = 9;
}

class UserSettingsValues {
  static const textSizeMin = 1;
  static const textSizeMax = 5;
}