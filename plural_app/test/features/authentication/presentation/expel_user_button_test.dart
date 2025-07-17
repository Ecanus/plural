import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/expel_user_button.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Test
import '../../../test_context.dart';

void main() {
  group("ExpelUserButton", () {
    testWidgets("cancelConfirmExpelUserDialog", (tester) async {
      final tc = TestContext();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ExpelUserButton(userGardenRecord: tc.userGardenRecord);
              }
            )
          )
        )
      );

      // Check ConfirmExpelUserDialog not yet displayed
      expect(find.byType(ConfirmExpelUserDialog), findsNothing);

      // Tap ExpelUserButton (to open dialog)
      await tester.tap(find.byType(ExpelUserButton));
      await tester.pumpAndSettle();

      // Check ConfirmExpelUserDialog is displayed
      expect(find.byType(ConfirmExpelUserDialog), findsOneWidget);

      // Tap cancel button (to close dialog)
      await tester.tap(find.text(AdminListedUsersViewText.cancelConfirmExpelUser));
      await tester.pumpAndSettle();

      // Check Dialog no longer displayed
      expect(find.byType(ConfirmExpelUserDialog), findsNothing);
    });
  });
}