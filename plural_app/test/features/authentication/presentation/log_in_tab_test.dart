import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';
import 'package:plural_app/src/features/authentication/presentation/log_in_tab.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

void main() {
  group("LogInTab test", () {
    testWidgets("widgets", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LogInTab(
              appForm: appForm,
              formKey: formKey,
            ),
          ),
        )
      );

      expect(find.byType(AppTextFormField), findsOneWidget);
      expect(find.byType(LogInPasswordFormField), findsOneWidget);
      expect(find.byType(AppElevatedButton), findsOneWidget);
    });
  });
}