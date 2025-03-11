import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

void main() {
  group("ShowHidePasswordButton test", () {
    testWidgets("isPasswordVisible", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShowHidePasswordButton(
              callback: () {},
              isPasswordVisible: () => false,
            ),
          ),
        ));

      // Check Icons.visibility_off_rounded shows if isPasswordVisible returns false
      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShowHidePasswordButton(
              callback: () {},
              isPasswordVisible: () => true,
            ),
          ),
        ));

      // Check Icons.visibility shows if isPasswordVisible returns true
      expect(find.byIcon(Icons.visibility_off_rounded), findsNothing);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets("callback", (tester) async {
      final testList = ["a", "b"];

      void testFunc() {
        testList.clear();
      }

      // Check testList has values
      expect(testList.isNotEmpty, true);
      expect(testList.length, 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShowHidePasswordButton(
              callback: testFunc,
              isPasswordVisible: () => true,
            ),
          ),
        ));

      // Press button (to call the callback)
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Check testList is now empty
      expect(testList.isEmpty, true);
    });
  });
}