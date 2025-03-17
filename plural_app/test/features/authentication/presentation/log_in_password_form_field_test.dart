import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/log_in_password_form_field.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Tests
import '../../../tester_functions.dart';

void main() {
  group("LogInPasswordFormField test", () {
    testWidgets("default values", (tester) async {
      final AppForm appForm = AppForm();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LogInPasswordFormField(
              appForm: appForm,
            ),
          ),
        ));

      // Check default values are set
      // NOTE: Can't check on maxLength due to inputFormatters
      final firstText = get<TextField>(tester);
      final firstContainer = get<Container>(tester);
      expect(firstText.maxLines!, 1);
      expect(firstContainer.padding, equals(EdgeInsets.only(top: 20)));
    });

    testWidgets("initial values", (tester) async {
      final AppForm appForm = AppForm();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LogInPasswordFormField(
              appForm: appForm,
              paddingTop: 11,
            ),
          ),
        ));

      // Check default values are set
      // NOTE: Cannot check maxLines, because obscureText == true
      // NOTE: Can't check on maxLength due to inputFormatters
      final firstContainer = get<Container>(tester);
      expect(firstContainer.padding, equals(EdgeInsets.only(top: 11)));
    });

    testWidgets("errorText", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: LogInPasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        ));

      // Check appForm value null at first; no invalidValue text
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to invalid value; validate
      textFieldController(tester).text = "";
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Check error text now shown
      final decoration = get<TextField>(tester).decoration!;

      expect(find.text(AppFormText.invalidValue), findsOneWidget);
      expect(decoration.errorText, AppFormText.invalidValue);
    });

    testWidgets("suffixIcon", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: LogInPasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      var text = get<TextField>(tester);
      expect(text.obscureText, true);

      // Tap showHidePasswordButton
      await tester.tap(find.byType(ShowHidePasswordButton));
      await tester.pumpAndSettle();

      // Check text obscureText now false
      text = get<TextField>(tester);
      expect(text.obscureText, false);
    });

    testWidgets("onSaved", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: LogInPasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      // Set text for textfield
      textFieldController(tester).text = "pa55AllChecks!";

      // Check that value in appForm is null
      expect(appForm.getValue(fieldName: UserField.password), null);

      formKey.currentState!.save();

      // Check values correctly saved
      expect(appForm.getValue(fieldName: UserField.password), "pa55AllChecks!");
    });
  });
}