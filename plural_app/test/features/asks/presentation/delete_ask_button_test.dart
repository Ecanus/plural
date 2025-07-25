import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plural_app/src/features/asks/presentation/delete_ask_button.dart';

import '../../../test_context.dart';

void main() {
  group("DeleteAskButton", () {
    testWidgets("dialog", (tester) async {
      final tc = TestContext();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return DeleteAskButton(askID: tc.ask.id);
              }
            )
          ),
        )
      );

      await tester.tap(find.byType(DeleteAskButton));
      await tester.pumpAndSettle();

      // Check ConfirmDeleteAskDialog has been created
      expect(find.byType(ConfirmDeleteAskDialog), findsOneWidget);

      // Tap OutlinedButton (to close ConfirmDeleteAskDialog)
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Check ConfirmDeleteAskDialog has removed
      expect(find.byType(ConfirmDeleteAskDialog), findsNothing);
    });
  });
}