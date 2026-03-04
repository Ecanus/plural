import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_close_confirm_dialog_button.dart';

void main() {
  group("AppCloseConfirmDialogButton", () {
    testWidgets("initial values", (tester) async {
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
                            child: AppCloseConfirmDialogButton()
                          );
                        }
                      );
                    },
                    child: null
                  )
                );
              }
            )
          )
        )
      );

      // Check dialog not displayed; AppCloseConfirmDialogButton not displayed
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(AppCloseConfirmDialogButton), findsNothing);

      // Tap ElevatedButton (to open Dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check dialog displayed; AppCloseConfirmDialogButton displayed
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(AppCloseConfirmDialogButton), findsOneWidget);

      // Tap AppCloseConfirmDialogButton
      await tester.tap(find.byType(AppCloseConfirmDialogButton));
      await tester.pumpAndSettle();

      // Check dialog no longer displayed; AppCloseConfirmDialogButton no longer displayed
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(AppCloseConfirmDialogButton), findsNothing);
    });
  });
}