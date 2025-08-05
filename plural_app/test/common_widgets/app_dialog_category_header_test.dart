import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_category_header.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Tests
import '../tester_functions.dart';

void main() {
  group("AppDialogCategoryHeader", () {
    testWidgets("initial values", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: AppDialogCategoryHeader(text: "TestAppDialogCategoryHeaderText")
          ),
        )
      );

      expect(
        get<Text>(tester).style!.color,
        AppThemes.standard.colorScheme.primary
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: AppDialogCategoryHeader(
              color: Colors.amber,
              text: "TestAppDialogCategoryHeaderText"
            )
          ),
        )
      );

      expect(
        get<Text>(tester).style!.color,
        Colors.amber
      );
    });
  });
}