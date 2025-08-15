import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_checkbox_list_tile_form_field.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Tests
import '../test_factories.dart';
import '../tester_functions.dart';

void main() {
  group("AppCheckboxListTileFormField test", () {
    testWidgets("_onChanged", (tester) async {
      final ask = AskFactory(targetMetDate: DateTime.now());
      final AppForm appForm = AppForm();

      await tester.pumpWidget(
        MaterialApp(
          home: AppCheckboxListTileFormField(
            appForm: appForm,
            fieldName: AskField.targetMetDate,
            formFieldType: FormFieldType.datetimeNow,
            text: AskViewText.targetMet,
            value: ask.isTargetMet
          ),
      ));

      // Check checkbox value matches initial value
      var checkbox = get<Checkbox>(tester);
      expect(checkbox.value, ask.isTargetMet);

      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Check that checkbox value has toggled
      checkbox = get<Checkbox>(tester);
      expect(checkbox.value, !ask.isTargetMet);
    });

    testWidgets("onSaved", (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final AppForm appForm = AppForm();

      // Set value of field in appForm to null
      appForm.setValue(fieldName: AskField.targetMetDate, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppCheckboxListTileFormField(
                appForm: appForm,
                fieldName: AskField.targetMetDate,
                formFieldType: FormFieldType.datetimeNow,
                text: AskViewText.targetMet,
                value: true
              ),
            ),
          ),
        ));

      // Check value of field in appForm is null; save appForm
      expect(appForm.getValue(fieldName: AskField.targetMetDate), null);
      formKey.currentState!.save();

      // Check that value of field set to string of current date
      expect(
        appForm.getValue(fieldName: AskField.targetMetDate),
        DateFormat(Formats.dateYMMdd).format(DateTime.now())
      );
    });
  });
}