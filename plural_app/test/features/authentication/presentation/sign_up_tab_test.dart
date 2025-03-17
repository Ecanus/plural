import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plural_app/src/common_widgets/app_elevated_button.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';
import 'package:plural_app/src/features/authentication/presentation/create_password_form_field.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/sign_up_tab.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

void main() {
  group("SignUpTab test", () {
    testWidgets("widgets", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignUpTab(
              appForm: appForm,
              formKey: formKey,
            ),
          ),
        )
      );

      expect(find.byType(AppTextFormField), findsNWidgets(4));
      expect(find.byType(CreatePasswordFormField), findsOneWidget);
      expect(find.byType(AppElevatedButton), findsOneWidget);
    });
  });
}