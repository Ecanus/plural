import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/features/asks/presentation/ask_time_left_text.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("AskTimeLeftText test", () {
    testWidgets("initial values", (tester) async {
      final ask = AskFactory(
        deadlineDate: DateTime.now().add(Duration(days: 10))
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AskTimeLeftText(
              ask: ask,
              textColor: Colors.yellow,
            ),
          ),
        ));

      // Check text correctly rendered
      final askString = ask.timeRemainingString;
      expect(find.text(
        "${AskViewText.askTimeLeftBrace} $askString ${AskViewText.askTimeLeftBrace}"
      ), findsOneWidget);
    });
  });
}