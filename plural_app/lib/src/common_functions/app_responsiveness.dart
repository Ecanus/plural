import 'package:flutter/material.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';
import 'package:plural_app/src/localization/lang_en.dart';

class ResponsiveUiKeys {
  // AppDialogFooter
  static const appDialogFooterBorderRadiusBottom = "appDialogFooterBorderRadiusBottom";
  static const appDialogFooterFontSize = "appDialogFooterFontSize";
  // AppDialogNavFooter
  static const appDialogNavFooterBorderRadiusBottom = "appDialogNavFooterBorderRadiusBottom";
  static const appDialogNavFooterFontSize = "appDialogNavFooterFontSize";
  static const appDialogNavFooterHorizontalPadding = "appDialogNavFooterHorizontalPadding";
  // AppSnackBars
  static const appSnackBarsWidth = "appSnackBarsWidth";
  // CurrentGardenSettingsView
  static const currentGardenSettingsViewDividerIndent = "currentGardenSettingsViewDividerIndent";
  // DeleteAccountButton
  static const deleteAccountButtonDialogMaxHeight = "deleteAccountButtonDialogMaxHeight";
  static const deleteAccountButtonText = "deleteAccountButtonText";
  // GardenPage
  static const gardenPageVerticalGap = "gardenPageVerticalGap";
  // GardenTimelineTile
  static const gardenTimelineTileContentsTimeLeftTextFontSize = "gardenTimelineTileContentsTimeLeftTextFontSize";
  static const gardenTimelineTileContentsTruncatedDescriptionFontSize = "gardenTimelineTileContentsTruncatedDescriptionFontSize";
  // SponsoredAsksView
  static const sponsoredAsksViewNavFooterTitle = "sponsoredAsksViewNavFooterTitle";
}

/// Map of responsive values used throughout the app.
/// First value is for small screens. Second value is for all other screen sizes.
Map<dynamic, dynamic> responsiveUiValuesMap = {
  // AppDialogFooter
  ResponsiveUiKeys.appDialogFooterBorderRadiusBottom:
    (Radius.zero, Radius.circular(AppBorderRadii.r15)),
  ResponsiveUiKeys.appDialogFooterFontSize:
    (AppFontSizes.s20, AppFontSizes.s25),
  // AppDialogNavFooter
  ResponsiveUiKeys.appDialogNavFooterBorderRadiusBottom:
    (Radius.zero, Radius.circular(AppBorderRadii.r15)),
  ResponsiveUiKeys.appDialogNavFooterFontSize:
    (AppFontSizes.s20, AppFontSizes.s25),
  ResponsiveUiKeys.appDialogNavFooterHorizontalPadding:
    (AppPaddings.p10, AppPaddings.p35),
  // AppSnackBars
  ResponsiveUiKeys.appSnackBarsWidth:
    (null, AppWidths.w600),
  // CurrentGardenSettingsView
  ResponsiveUiKeys.currentGardenSettingsViewDividerIndent:
    (AppIndents.i100, AppIndents.i200),
  // DeleteAccountButton
  ResponsiveUiKeys.deleteAccountButtonDialogMaxHeight:
    (AppConstraints.c450, AppConstraints.c350),
  ResponsiveUiKeys.deleteAccountButtonText:
    (Text(LandingPageText.deleteAccountShorthand), Text(LandingPageText.deleteAccount)),
  // GardenPage
  ResponsiveUiKeys.gardenPageVerticalGap:
    (gapH10, gapH30),
  // GardenTimelineTile
  ResponsiveUiKeys.gardenTimelineTileContentsTimeLeftTextFontSize:
    (AppFontSizes.s10, null),
  ResponsiveUiKeys.gardenTimelineTileContentsTruncatedDescriptionFontSize:
    (AppFontSizes.s12, null),
  // SponsoredAsksView
  ResponsiveUiKeys.sponsoredAsksViewNavFooterTitle:
    (AppDialogFooterText.sponsoredAsksShorthand, AppDialogFooterText.sponsoredAsks),
};

bool isOnSmallScreen(BuildContext context) {
  return MediaQuery.sizeOf(context).shortestSide < AppMediaQuery.mobileSize;
}

/// Returns the responsive value corresponding to the given uiKey,
/// for the widget to correctly display on the current screen size.
dynamic getResponsiveUiValue(BuildContext context, String uiKey) {

  final responsiveValues = responsiveUiValuesMap[uiKey];

  return isOnSmallScreen(context) ? responsiveValues.$1 : responsiveValues.$2;
}