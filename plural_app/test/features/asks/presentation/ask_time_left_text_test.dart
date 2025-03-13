import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("AskTimeLeftText test", () {
    testWidgets("initial values", (tester) async {
      final tc = TestContext()
                  ..ask.deadlineDate = DateTime.now().add(const Duration(days: 10));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AskTimeLeftText(
              ask: tc.ask,
              textColor: Colors.yellow,
            ),
          ),
        ));

      // Check text correctly rendered
      final askString = tc.ask.timeRemainingString;
      expect(find.text(
        "${AskDialogText.askTimeLeftBrace} $askString ${AskDialogText.askTimeLeftBrace}"
      ), findsOneWidget);
    });
  });
}