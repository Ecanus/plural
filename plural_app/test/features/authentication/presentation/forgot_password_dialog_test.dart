import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/close_dialog_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/forgot_password_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

void main() {
  group("ForgotPasswordDialog test", () {
    testWidgets("widgets", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createForgotPasswordDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          )
        )
      );

      // Check no dialog displayed
      expect(find.byType(Dialog), findsNothing);

      // Tap button (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check dialog displayed now
      expect(find.byType(Dialog), findsOneWidget);

      // Check widgets all rendered correctly
      expect(find.text(ForgotPasswordDialogText.enterEmail), findsOneWidget);
      expect(
        find.text(ForgotPasswordDialogText.enterEmailToSendInstructions),
        findsOneWidget
      );
      expect(find.byType(AppTextFormField), findsOneWidget);
      expect(find.byType(AppElevatedButton), findsOneWidget);
      expect(find.byType(CloseDialogButton), findsOneWidget);

      // Tap CloseDialogButton
      await tester.tap(find.byType(CloseDialogButton));
      await tester.pumpAndSettle();

      // Check no dialog displayed
      expect(find.byType(Dialog), findsNothing);
    });
  });
}