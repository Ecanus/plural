import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_tooltip_icon.dart';

// Constants
import 'package:plural_app/src/constants/themes.dart';

// Tests
import '../tester_functions.dart';

void main() {
  group("AppTooltipIcon test", () {
    testWidgets("dark", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: AppTooltipIcon(
              isDark: true
            ),
          ),
        ));

      // Check primary color used when dark == true
      final icon1 = get<Icon>(tester);
      expect(icon1.color, equals(AppThemes.colorScheme.primary));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: AppTooltipIcon(
              isDark: false
            ),
          ),
        ));

      // Check onSecondary color used when dark == false
      final icon2 = get<Icon>(tester);
      expect(icon2.color, equals(AppThemes.colorScheme.onSecondary));
    });
  });
}