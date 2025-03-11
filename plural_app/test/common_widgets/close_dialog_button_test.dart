import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

void main() {
  group("CloseDialogButton test", () {
    testWidgets("onPressed", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (BuildContext context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: CloseDialogButton()
                          );
                        }
                      );
                    },
                    child: null)
                );
              }
            ),
          ),
        ));

      // Check dialog not dispalyed; close dialog button not displayed
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(CloseDialogButton), findsNothing);

      // Tap ElevatedButton
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check dialog dispalyed; close dialog button displayed
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(CloseDialogButton), findsOneWidget);

      // Tap CloseDialogButton
      await tester.tap(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();

      // Check dialog no longer dispalyed; close dialog button no longer displayed
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(CloseDialogButton), findsNothing);
    });
  });
}