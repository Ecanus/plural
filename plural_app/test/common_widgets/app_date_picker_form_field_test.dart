import '../tester_functions.dart' as funcs;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_date_picker_form_field.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Tests
import '../test_context.dart';

void main() {
  group("AppDatePickerFormField test", () {
    testWidgets("initialValue null", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        ));

      // Check text is empty
      expect(funcs.textFieldController(tester).value.text, "");
    });

    testWidgets("initialValue non-null", (tester) async {
      final tc = TestContext();
      final AppForm appForm = AppForm();

      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;
      final value = tc.ask.deadlineDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: value,
              label: label,
            ),
          ),
        ));

      // Check text is the formatted string of date
      expect(
        funcs.textFieldController(tester).value.text,
        DateFormat(Formats.dateYMMdd).format(value)
      );
    });

    testWidgets("onSaved", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final AppForm appForm = AppForm();

      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;

      appForm.setValue(fieldName: AskField.deadlineDate, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppDatePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: null,
                label: label,
              ),
            ),
          ),
        ));

      // Check appForm value null at first
      expect(appForm.getValue(fieldName: fieldName), null);

      // Set text to a value
      funcs.textFieldController(tester).text = "2074-31-08";
      formKey.currentState!.save();

      // Check value saved to appForm
      expect(appForm.getValue(fieldName: fieldName), "2074-31-08");
    });

    testWidgets("Invalid value", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final AppForm appForm = AppForm();

      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppDatePickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: null,
                label: label,
              ),
            ),
          ),
        ));

      // appForm value is null; no error message is shown
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to invalid value; validate
      funcs.textFieldController(tester).text = "???";
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Value not saved to appForm; error text now shown
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsOneWidget);
    });

    testWidgets("Label text", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = AskField.deadlineDate;
      const firstLabel = AskDialogText.deadlineDate;
      const secondLabel = "Hibiscus";

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: firstLabel,
            ),
          ),
        ));

      // Check firstLabel is used
      expect(find.text(firstLabel), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: secondLabel,
            ),
          ),
        ));

      // secondLabel is used
      expect(find.text(firstLabel), findsNothing);
      expect(find.text(secondLabel), findsOneWidget);
    });

    testWidgets("showDatePickerDialog select value", (tester) async {
      final AppForm appForm = AppForm();
      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        )
      );

      // Text empty at first
      expect(funcs.textFieldController(tester).value.text, "");

      // Open Dialog
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // Input text; click OK
      final days10 = DateTime.now().add(const Duration(days: 10));
      final days10InputFormat = DateFormat(Formats.dateInputMMddY).format(days10);
      final days10AppFormat = DateFormat(Formats.dateYMMdd).format(days10);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.enterText(find.byType(TextField), days10InputFormat);
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      // Check date string set; dialog closed
      expect(funcs.textFieldController(tester).value.text, days10AppFormat);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets("showDatePickerDialog dismiss", (tester) async {
      final AppForm appForm = AppForm();
      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        )
      );

      // Text empty at first
      expect(funcs.textFieldController(tester).value.text, "");

      // Open Dialog
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // Input text; click Cancel
      final days10 = DateTime.now().add(const Duration(days: 10));
      final days10InputFormat = DateFormat(Formats.dateInputMMddY).format(days10);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.enterText(find.byType(TextField), days10InputFormat);
      await tester.tap(find.text("Cancel"));
      await tester.pumpAndSettle();

      // Text not updated; Dialog closed
      expect(funcs.textFieldController(tester).value.text, "");
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets("Valid text entry out of range", (tester) async {
      final AppForm appForm = AppForm();
      const fieldName = AskField.deadlineDate;
      const label = AskDialogText.deadlineDate;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDatePickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        )
      );

      // Text empty at first; no error message
      expect(funcs.textFieldController(tester).value.text, "");
      expect(find.text('Out of range.'), findsNothing);

      // Open Dialog
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      // Input text (out of range); click OK
      final days500 = DateTime.now().add(const Duration(days: 500));
      final days500InputFormat = DateFormat(Formats.dateInputMMddY).format(days500);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.enterText(find.byType(TextField), days500InputFormat);
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      // Error message shown; Dialog still shows
      expect(find.text('Out of range.'), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}