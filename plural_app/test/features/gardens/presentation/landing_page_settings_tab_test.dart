import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/delete_account_button.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Gardens
import 'package:plural_app/src/features/gardens/presentation/landing_page_settings_tab.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_context.dart';

void main() {
  group("LandingPageSettingsTab test", () {
    testWidgets("widgets", (tester) async {
      final tc = TestContext();
      final appState = AppState()
                        ..currentUserSettings = tc.userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageSettingsTab(),
          ),
        ));

      // Check widgets are rendered
      expect(find.byType(AppCurrencyPickerFormField), findsOneWidget);
      expect(find.byType(AppTextFormField), findsOneWidget);
      expect(find.byType(AppElevatedButton), findsOneWidget);
      expect(find.byType(DeleteAccountButton), findsOneWidget);
      expect(find.byType(LogOutButton), findsOneWidget);
    });
  });
}