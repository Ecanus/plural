import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Functions
import 'package:plural_app/src/common_functions/app_responsiveness.dart';

// Constants
import 'package:plural_app/src/constants/app_sizes.dart';

void main() {
  group("AppResponsiveness", () {
    testWidgets("isOnSmallScreen", (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = Size(1200, AppMediaQuery.mobileSize + 1);

      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (BuildContext context) {
                return isOnSmallScreen(context) ? Text("On Small Screen") : Text("On Large Screen");
              }
            ),
          ),
        )
      );

      // Check isOnSmallScreen() returns false (i.e. shortest side > AppMediaQuery.mobileSize)
      expect(find.text("On Large Screen"), findsOneWidget);

      tester.view.physicalSize = Size(1200, AppMediaQuery.mobileSize - 1);
      await tester.pumpAndSettle();

      // Now, check isOnSmallScreen() returns true (i.e. shortest side < AppMediaQuery.mobileSize)
      expect(find.text("On Small Screen"), findsOneWidget);
    });

    testWidgets("getResponsiveUiValue", (tester) async {
      dynamic valueToTest;
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);

      Future<void> testWidget(String uiKey, int size) async {
        tester.view.physicalSize = Size(1200, AppMediaQuery.mobileSize + size);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Builder(
                builder: (BuildContext context) {
                  valueToTest = getResponsiveUiValue(context, uiKey);

                  return SizedBox();
                }
              ),
            ),
          )
        );
      }

      // Check against some values to ensure they respond to screen size.

      // appDialogFooterBorderRadiusBottom
      await testWidget(ResponsiveUiKeys.appDialogFooterBorderRadiusBottom, -1);
      await tester.pumpAndSettle();
      expect(valueToTest, Radius.zero);

      await testWidget(ResponsiveUiKeys.appDialogFooterBorderRadiusBottom, 1);
      await tester.pumpAndSettle();
      expect(valueToTest, Radius.circular(AppBorderRadii.r15));

      // deleteAccountButtonDialogMaxHeight
      await testWidget(ResponsiveUiKeys.deleteAccountButtonDialogMaxHeight, -1);
      await tester.pumpAndSettle();
      expect(valueToTest, AppConstraints.c450);

      await testWidget(ResponsiveUiKeys.deleteAccountButtonDialogMaxHeight, 1);
      await tester.pumpAndSettle();
      expect(valueToTest, AppConstraints.c350);

      // gardenTimelineTileContentsTimeLeftTextFontSize
      await testWidget(ResponsiveUiKeys.gardenTimelineTileContentsTimeLeftTextFontSize, -1);
      await tester.pumpAndSettle();
      expect(valueToTest, AppFontSizes.s10);

      await testWidget(ResponsiveUiKeys.gardenTimelineTileContentsTimeLeftTextFontSize, 1);
      await tester.pumpAndSettle();
      expect(valueToTest, null);
    });
  });
}