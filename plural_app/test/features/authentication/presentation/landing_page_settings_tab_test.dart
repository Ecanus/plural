import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/common_widgets/log_out_button.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/delete_account_button.dart';
import 'package:plural_app/src/features/authentication/presentation/landing_page_settings_tab.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

// Tests
import '../../../test_factories.dart';

void main() {
  group("LandingPageSettingsTab", () {
    testWidgets("widgets", (tester) async {
      final user = AppUserFactory();
      final userSettings = AppUserSettingsFactory(user: user);

      final appState = AppState()
        ..currentUser = user
        ..currentUserSettings = userSettings;

      final getIt = GetIt.instance;
      getIt.registerLazySingleton<AppState>(() => appState);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LandingPageSettingsTab(),
          ),
        )
      );

      // Check widgets are rendered
      expect(find.byType(AppCurrencyPickerFormField), findsOneWidget);
      expect(find.byType(AppTextFormField), findsNWidgets(3));
      expect(find.byType(AppElevatedButton), findsOneWidget);
      expect(find.byType(DeleteAccountButton), findsOneWidget);
      expect(find.byType(LogOutButton), findsOneWidget);
    });

    tearDown(() => GetIt.instance.reset());
  });
}