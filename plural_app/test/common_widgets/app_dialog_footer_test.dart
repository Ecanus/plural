import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_nav_button.dart';

// Tests
import '../tester_functions.dart';

void main() {
  group("AppDialogFooterBuffer", () {
    testWidgets("buttons", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogFooterBuffer(
              buttons: [],
            ),
          ),
        ));

      // Check if buttons == [], a SizedBox is rendered
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Container), findsNothing);

      final button1 = ElevatedButton(onPressed: () {}, child: Text("button1"));
      final button2 = ElevatedButton(onPressed: () {}, child: Text("button2"));
      final button3 = ElevatedButton(onPressed: () {}, child: Text("button3"));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogFooterBuffer(
              buttons: [button1, button2, button3],
            ),
          ),
        ));

      // Check list of buttons is rendered
      expect(find.text("button1"), findsOneWidget);
      expect(find.text("button2"), findsOneWidget);
      expect(find.text("button3"), findsOneWidget);
    });
  });

  group("AppDialogNavFooter", () {
    testWidgets("initial values", (tester) async {
      void leftFunc() => {};
      void rightFunc() => {};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogNavFooter(
              leftDialogIcon: Icons.back_hand,
              leftNavCallback: leftFunc,
              leftTooltipMessage: "Benkum",
              rightDialogIcon: Icons.front_hand,
              rightNavCallback: rightFunc,
              rightTooltipMessage: "Nifa",
              title: "Le Titre",
            ),
          ),
        ));

      // Check leftNavButton values
      final leftNavButton = get<AppDialogFooterNavButton>(tester);
      expect(leftNavButton.dialogIcon, Icons.back_hand);
      expect(leftNavButton.callback, leftFunc);
      expect(leftNavButton.tooltipMessage, "Benkum");

      // Check rightNavButton values
      final rightNavButton = getLast<AppDialogFooterNavButton>(tester);
      expect(rightNavButton.dialogIcon, Icons.front_hand);
      expect(rightNavButton.callback, rightFunc);
      expect(rightNavButton.tooltipMessage, "Nifa");

      // Check title is rendered
      expect(find.text("Le Titre"), findsOneWidget);
    });

    testWidgets("navActionCallback asserts", (tester) async {
      void leftFunc() => {};
      void leftAction(BuildContext context) => {};
      void rightFunc() => {};
      void rightAction(BuildContext context) => {};

      // AssertionError if both leftNavActionCallback and leftNavCallback
      expect(
        () async =>
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppDialogNavFooter(
                leftDialogIcon: Icons.back_hand,
                leftNavActionCallback: leftAction,
                leftNavCallback: leftFunc,
                leftTooltipMessage: "Benkum",
                rightDialogIcon: Icons.front_hand,
                rightNavActionCallback: rightAction,
                rightTooltipMessage: "Nifa",
                title: "Le Titre",
              ),
            ),
          )
        ),
        throwsA(predicate((e) => e is AssertionError))
      );

      // AssertionError if both rightNavActionCallback and rightNavCallback
      expect(() async => await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogNavFooter(
              leftDialogIcon: Icons.back_hand,
              leftNavActionCallback: leftAction,
              leftTooltipMessage: "Benkum",
              rightDialogIcon: Icons.front_hand,
              rightNavCallback: rightFunc,
              rightNavActionCallback: rightAction,
              rightTooltipMessage: "Nifa",
              title: "Le Titre",
            ),
          ),
        )
      ), throwsA(predicate((e) => e is AssertionError)));
    });
  });

  group("AppDialogFooter", () {
    testWidgets("initial values", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialogFooter(
              title: "Me din de",
            ),
          ),
        ));

      // Check title is rendered
      expect(find.text("Me din de"), findsOneWidget);
    });
  });
}