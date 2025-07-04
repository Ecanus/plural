import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_checkbox_list_tile_form_field.dart';
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_dialog_footer_buffer_submit_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Asks
import 'package:plural_app/src/features/asks/presentation/edit_ask_view.dart';

// Utils
import 'package:plural_app/src/utils/app_dialog_view_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("EditAskView test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState();

      // GetIt
      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);
      getIt.registerLazySingleton<AppDialogViewRouter>(() => AppDialogViewRouter());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () => createEditAskDialog(context: context, ask: tc.ask),
                  child: Text("The ElevatedButton")
                );
              }
            )
          ),
        )
      );

      // Check AskDialogEditForm not yet displayed
      expect(find.byType(EditAskView), findsNothing);

      // Tap ElevatedButton (to open dialog)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check expected values are found
      expect(find.byType(EditAskView), findsOneWidget);
      expect(find.byType(EditAskHeader), findsOneWidget);
      expect(find.byType(AppDatePickerFormField), findsOneWidget);
      expect(find.byType(AppTextFormField), findsNWidgets(5));
      expect(find.byType(AppCurrencyPickerFormField), findsOneWidget);
      expect(find.byType(AppCheckboxListTileFormField), findsOneWidget);
      expect(find.byType(DeleteAskButton), findsOneWidget);
      expect(find.byType(AppDialogFooterBufferSubmitButton), findsOneWidget);

      // Tap DeleteAskButton (to open another dialog)
      await tester.ensureVisible(find.byType(DeleteAskButton));
      await tester.pumpAndSettle();
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

    tearDown(() => GetIt.instance.reset());
  });
}