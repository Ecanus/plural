import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer_nav_button.dart';

// Tests
import '../tester_functions.dart';

void main() {
  group("AppDialogFooterNavButton test", () {
    testWidgets("callback", (tester) async {
      final testList = ["stringA", "stringB"];

      void testFunc() {
        testList.clear();
      }

      // Check testList is empty
      expect(testList.isNotEmpty, true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: testFunc,
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Press button (to call the callback)
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Check testList has been cleared
      expect(testList.isEmpty, true);
    });

    testWidgets("actionCallback", (tester) async {
      final testList = ["stringA", "stringB"];

      void testActionFunc(BuildContext context) {
        testList.add("stringC");
      }

      // Check testList is empty
      expect(testList.isNotEmpty, true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  actionCallback: testActionFunc,
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Press button (to call the callback)
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Check testList has "stringC" added
      expect(testList.last, "stringC");
    });

    testWidgets("NavButtonDirection", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check values dependent on NavButtonDirection.left properly set
      expect(find.byIcon(Icons.keyboard_arrow_left_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_right_rounded), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.right,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check values dependent on NavButtonDirection.right properly set
      expect(find.byIcon(Icons.keyboard_arrow_right_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_left_rounded), findsNothing);
    });

    testWidgets("isMouseHovered", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: false,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check opacity is 0.0 when isMouseHovered is false
      expect(get<AnimatedOpacity>(tester).opacity, 0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check opacity is 1.0 when isMouseHovered is true
      expect(get<AnimatedOpacity>(tester).opacity, 1.0);
    });

    testWidgets("tooltipMessage", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "",
                ),
              ],
            ),
          ),
        ));

      // Check tooltip message is empty string
      expect(get<Tooltip>(tester).message, "");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check tooltip message is "message"
      expect(get<Tooltip>(tester).message, "message");
    });

    testWidgets("dialogIcon", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.local_florist,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check dialogIcon value exists in widget
      expect(find.byIcon(Icons.local_florist), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                AppDialogFooterNavButton(
                  callback: () {},
                  dialogIcon: Icons.door_sliding,
                  direction: NavButtonDirection.left,
                  isMouseHovered: true,
                  tooltipMessage: "message",
                ),
              ],
            ),
          ),
        ));

      // Check dialogIcon value changes
      expect(find.byIcon(Icons.local_florist), findsNothing);
      expect(find.byIcon(Icons.door_sliding), findsOneWidget);
    });
  });
}