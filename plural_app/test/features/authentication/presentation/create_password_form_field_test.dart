import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/show_hide_password_button.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/themes.dart';

// Auth
import 'package:plural_app/src/features/authentication/presentation/create_password_form_field.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

import '../../../tester_functions.dart';

void main() {
  group("CreatePasswordFormField test", () {
    testWidgets("default values", (tester) async {
      final AppForm appForm = AppForm();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreatePasswordFormField(
              appForm: appForm,
            ),
          ),
        )
      );

      // Check default values are set
      final firstText = get<TextField>(tester);
      final lastText = getLast<TextField>(tester);
      final firstContainer = get<Container>(tester);
      expect(firstText.maxLines!, 1);
      expect(lastText.maxLines!, 1);
      expect(firstContainer.padding, equals(EdgeInsets.only(top: 20)));
    });

    testWidgets("initial values", (tester) async {
      final AppForm appForm = AppForm();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreatePasswordFormField(
              appForm: appForm,
              paddingTop: 15,
            ),
          ),
        )
      );

      // Check default values are set
      // NOTE: Cannot check maxLines, because obscureText == true
      final firstContainer = get<Container>(tester);
      expect(firstContainer.padding, equals(EdgeInsets.only(top: 15)));
    });

    testWidgets("errorText", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CreatePasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      // Check no invalidValue text
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to invalid value; validate
      textFieldController(tester).text = "";
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Check error text now shown for both fields
      final firstDecoration = get<TextField>(tester).decoration!;
      final lastDecoration = getLast<TextField>(tester).decoration!;

      expect(find.text(AppFormText.invalidValue), findsNWidgets(2));
      expect(firstDecoration.errorText, AppFormText.invalidValue);
      expect(lastDecoration.errorText, AppFormText.invalidValue);
    });

    testWidgets("passwordsMatch", (tester) async {
      void checkText(text, color) {
        // Check text is rendered
        expect(find.text(text), findsOneWidget);

        final widget = get<Text>(
          tester,
          getBy: GetBy.text,
          text: text
        );

        // Check text has correct color
        expect(widget.style!.color, color);
      }

      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CreatePasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      // Check no invalidValue text
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to valid values; validate
      textFieldController(tester).text = "pa55AllChecks!";
      getLast<TextField>(tester).controller!.text = "pa55AllChecks!";

      // Check validation returns true
      expect(formKey.currentState!.validate(), true);
      await tester.pumpAndSettle();

      // Check still no invalidValue text; check still no mismatch text
      expect(find.text(AppFormText.invalidValue), findsNothing);
      expect(find.text(SignInPageText.passwordMismatch), findsNothing);

      checkText(SignInPageText.passwordLength, AppThemes.successColor);
      checkText(SignInPageText.passwordLowercase, AppThemes.successColor);
      checkText(SignInPageText.passwordUppercase, AppThemes.successColor);
      checkText(SignInPageText.passwordNumber, AppThemes.successColor);
      checkText(SignInPageText.passwordSpecial, AppThemes.successColor);
      checkText(SignInPageText.passwordMatch, AppThemes.successColor);
    });

    testWidgets("passwordsMismatch", (tester) async {
      void checkText(text, color) {
        // Check text is rendered
        expect(find.text(text), findsOneWidget);

        final widget = get<Text>(
          tester,
          getBy: GetBy.text,
          text: text
        );

        // Check text has correct color
        expect(widget.style!.color, color);
      }

      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CreatePasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      // Check no invalidValue text; check no mismatch text
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // NOTE: Should default to this text if both passwords are empty
      expect(find.text(SignInPageText.passwordMismatch), findsOneWidget);

      // Set text to invalid value; validate
      textFieldController(tester).text = "";
      getLast<TextField>(tester).controller!.text = "pa55AllChecks!";

      // Check validation returns false
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Check for invalidValue text; check for mismatch text
      expect(find.text(AppFormText.invalidValue), findsOneWidget);

      // Both errorText and PasswordTextRow text should render
      expect(find.text(SignInPageText.passwordMismatch), findsNWidgets(2));

      checkText(SignInPageText.passwordLength, AppThemes.colorScheme.onPrimary);
      checkText(SignInPageText.passwordLowercase, AppThemes.colorScheme.onPrimary);
      checkText(SignInPageText.passwordUppercase, AppThemes.colorScheme.onPrimary);
      checkText(SignInPageText.passwordNumber, AppThemes.colorScheme.onPrimary);
      checkText(SignInPageText.passwordSpecial, AppThemes.colorScheme.onPrimary);
    });

    testWidgets("suffixIcon", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CreatePasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      var firstText = get<TextField>(tester);
      var lastText = getLast<TextField>(tester);
      expect(firstText.obscureText, true);
      expect(lastText.obscureText, true);

      // Tap first showHidePasswordButton
      await tester.tap(find.byType(ShowHidePasswordButton).first);
      await tester.pumpAndSettle();

      // Check firstText obscureText now false
      firstText = get<TextField>(tester);
      expect(firstText.obscureText, false);

      // Tap last showHidePasswordButton
      await tester.tap(find.byType(ShowHidePasswordButton).last);
      await tester.pumpAndSettle();

      // Check lastText obscureText now false
      lastText = get<TextField>(tester);
      expect(lastText.obscureText, false);
    });

    testWidgets("onSaved", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.standard,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CreatePasswordFormField(
                appForm: appForm,
              ),
            ),
          ),
        )
      );

      // Set text for both textfields
      textFieldController(tester).text = "pa55AllChecks!";
      getLast<TextField>(tester).controller!.text = "pa55AllChecks!";

      // Check that values in appForm are null
      expect(appForm.getValue(fieldName: UserField.password), null);
      expect(appForm.getValue(fieldName: UserField.passwordConfirm), null);

      formKey.currentState!.save();

      // Check values correctly saved
      expect(appForm.getValue(fieldName: UserField.password), "pa55AllChecks!");
      expect(appForm.getValue(fieldName: UserField.passwordConfirm), "pa55AllChecks!");
    });
  });
}