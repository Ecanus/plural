import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Functions
import 'package:plural_app/src/common_functions/input_formatters.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_text_form_field.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Tests
import '../tester_functions.dart';

void main() {
  group("AppTextFormField test", () {
    testWidgets("default values", (tester) async {
      final AppForm appForm = AppForm();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              appForm: appForm,
              fieldName: "Le Field Name",
            ),
          ),
        ));

      // Check default values
      final container = get<Container>(tester);
      final textField = get<TextField>(tester);
      final decoration = textField.decoration!;
      final label = decoration.label as Text;

      expect(container.padding, equals(EdgeInsets.only(top: 20, bottom: 20)));
      expect(textFieldController(tester).value.text, "");
      expect(decoration.errorText, null);
      expect(decoration.hintText, "");
      expect(label.data, "");
      expect(decoration.suffixIcon, null);
      expect(textField.maxLines, 1);

      // Check inputFormatter has maxLength == 20
      expect(textField.inputFormatters!.isEmpty, false);
      final inputFormatter =
        textField.inputFormatters!.first as LengthLimitingTextInputFormatter;
      expect(inputFormatter.maxLength, 20);
    });

    testWidgets("initial values", (tester) async {
      final AppForm appForm = AppForm();
      final suffixIcon = IconButton(
        onPressed: () {},
        icon: Icon(Icons.breakfast_dining)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              appForm: appForm,
              fieldName: "Dos",
              formFieldType: FormFieldType.digitsOnly,
              hintText: "Boa me",
              initialValue: "5",
              label: "The Value of Time",
              maxLength: 15,
              maxLines: 2,
              paddingBottom: 11.0,
              paddingTop: 33.0,
              suffixIcon: suffixIcon,
              textFieldType: TextFieldType.digitsOnly,
            ),
          ),
        ));

      // Check initial values
      final container = get<Container>(tester);
      final textField = get<TextField>(tester);
      final decoration = textField.decoration!;
      final label = decoration.label as Text;

      expect(container.padding, equals(EdgeInsets.only(top: 33.0, bottom: 11.0)));
      expect(textFieldController(tester).value.text, "5");
      expect(decoration.errorText, null);
      expect(decoration.hintText, "Boa me");
      expect(label.data, "The Value of Time");
      expect(decoration.suffixIcon, suffixIcon);
      expect(textField.maxLines, 2);

      // Check inputFormatter has correct maxLength
      expect(textField.inputFormatters!.isEmpty, false);
      final inputFormatter =
        textField.inputFormatters!.first as LengthLimitingTextInputFormatter;
      expect(inputFormatter.maxLength, 15);
    });

    testWidgets("onSaved", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = "Text Form Field Name";
      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppTextFormField(
                appForm: appForm,
                fieldName: fieldName,
              ),
            ),
          ),
        ));

      // Check appForm value null at first
      expect(appForm.getValue(fieldName: fieldName), null);

      // Set text to value; save
      textFieldController(tester).text = "Pickles";
      formKey.currentState!.save();

      // Check value saved to appForm
      expect(appForm.getValue(fieldName: fieldName), "Pickles");
    });

    testWidgets("errorText", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = "Text Form Field Name";
      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppTextFormField(
                appForm: appForm,
                fieldName: fieldName,
              ),
            ),
          ),
        ));

      // Check appForm value null at first; no invalidValue text
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to invalid value; validate
      textFieldController(tester).text = "";
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Value not saved to appForm; error text now shown
      final textField = get<TextField>(tester);
      final decoration = textField.decoration!;

      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsOneWidget);
      expect(decoration.errorText, AppFormText.invalidValue);
    });
  });
}