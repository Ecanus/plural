import "package:flutter/material.dart";
import "package:timeline_tile/timeline_tile.dart";

import 'package:plural_app/src/constants/app_sizes.dart';

class AppColors {
  static const primaryColor = Colors.grey; // Use theme finally
  static const secondaryColor = Colors.white;
  static const onPrimaryColor = Colors.black;
  static const darkGrey1 = Color.fromARGB(255, 51, 51, 51);
  static const darkGrey2 = Color.fromARGB(255, 29, 29, 29);
  static const lightGrey = Colors.grey;
  static const lightShadow = Color.fromARGB(255, 92, 92, 92);
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

const appIndicatorStyle = IndicatorStyle(
  width: AppTimelineSizes.indicatorWidth,
  color: AppColors.primaryColor,
);

const appLineStyle = LineStyle(
  color: AppColors.primaryColor,
  thickness: AppTimelineSizes.timelineThickness,
);

const numDaysAskDuration = 30;