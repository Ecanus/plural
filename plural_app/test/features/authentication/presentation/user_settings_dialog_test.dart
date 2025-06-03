import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/user_settings_dialog.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("UserSettingsDialog test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUser = tc.user
                        ..currentUserSettings = tc.userSettings;

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogRouter>(() => AppDialogRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createUserSettingsDialog(context),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check UserSettingsList not yet displayed
      expect(find.byType(UserSettingsList), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(UserSettingsList), findsOneWidget);
      expect(find.byType(AppCurrencyPickerFormField), findsOneWidget);
      expect(find.byType(AppTextFormField), findsNWidgets(3));
      expect(find.byType(LogOutButton), findsOneWidget);
      expect(find.byType(AppDialogFooterBuffer), findsOneWidget);
      expect(find.byType(AppDialogNavFooter), findsOneWidget);

      // Tap ExitGardenButton (to open another dialog)
      await tester.ensureVisible(find.byType(ExitGardenButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ExitGardenButton));
      await tester.pumpAndSettle();

      // Check ConfirmExitGardenDialog has been created
      expect(find.byType(ConfirmExitGardenDialog), findsOneWidget);

      // Tap close dialog button
      await tester.tap(find.text(UserSettingsDialogText.cancelConfirmExitGarden));
      await tester.pumpAndSettle();

      // Check ConfirmExitGardenDialog has been removed
      expect(find.byType(ConfirmExitGardenDialog), findsNothing);
    });

    tearDown(() => GetIt.instance.reset());
  });
}