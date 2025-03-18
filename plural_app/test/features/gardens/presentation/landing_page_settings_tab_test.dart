import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_button.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/landing_page_settings_tab.dart';

void main() {
  group("LandingPageSettingsTab test", () {
    testWidgets("widgets", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageSettingsTab(),
          ),
        ));

      // Check text widget is rendered
      expect(find.byType(AppElevatedButton), findsOneWidget);
      expect(find.byType(AppTextButton), findsOneWidget);
    });
  });
}