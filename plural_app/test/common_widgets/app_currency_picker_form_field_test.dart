import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_currency_picker_form_field.dart';

// Constants
import 'package:plural_app/src/constants/currencies.dart';
import 'package:plural_app/src/constants/fields.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

// Tests
import '../test_factories.dart';
import '../tester_functions.dart';

void main() {
  group("AppCurrencyPickerFormField test", () {
    testWidgets("default values", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = AskField.currency;
      const label = AskViewText.currency;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCurrencyPickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        ));

      // Check default value of initialValue is ""
      expect(textFieldController(tester).value.text, "");
    });

    testWidgets("initial values", (tester) async {
      final ask = AskFactory(currency: "GHS");
      final AppForm appForm = AppForm();

      const fieldName = AskField.currency;
      const label = AskViewText.currency;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCurrencyPickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: ask.currency,
              label: label,
            ),
          ),
        ));

      // Check text is the currency
      expect(textFieldController(tester).value.text, ask.currency);
    });

    testWidgets("onSaved", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = AskField.currency;
      const label = AskViewText.currency;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppCurrencyPickerFormField(
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

      // Set text to new value; save form
      textFieldController(tester).text = "HKD";
      formKey.currentState!.save();

      // Check appForm value now new value
      expect(appForm.getValue(fieldName: fieldName), "HKD");
    });

    testWidgets("Invalid value", (tester) async {
      final AppForm appForm = AppForm();
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      const fieldName = AskField.currency;
      const label = AskViewText.currency;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppCurrencyPickerFormField(
                appForm: appForm,
                fieldName: fieldName,
                initialValue: null,
                label: label,
              ),
            ),
          ),
        ));

      // Check appForm value null at first; no error text displayed
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsNothing);

      // Set text to invalid value; validate form
      textFieldController(tester).text = "???";
      expect(formKey.currentState!.validate(), false);
      await tester.pumpAndSettle();

      // Check appForm value did not update; error text now displayed
      expect(appForm.getValue(fieldName: fieldName), null);
      expect(find.text(AppFormText.invalidValue), findsOneWidget);
    });

    testWidgets("Label text", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = AskField.currency;
      const firstLabel = AskViewText.currency;
      const secondLabel = "Pickles";

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCurrencyPickerFormField(
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
            body: AppCurrencyPickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: secondLabel,
            ),
          ),
        ));

      // Check secondLabel is used; firstLabel no longer used
      expect(find.text(firstLabel), findsNothing);
      expect(find.text(secondLabel), findsOneWidget);
    });

    testWidgets("showCurrencyPicker select value", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = AskField.currency;
      const label = AskViewText.currency;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCurrencyPickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        )
      );

      // Check text empty at first
      expect(textFieldController(tester).value.text, "");

      // Open Dialog; check number of CurrencyCards is correct
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(CurrencyCard), findsNWidgets(Currencies.all.length));

      // Select a currency
      await tester.tap(find.byType(CurrencyCard).first);
      await tester.pumpAndSettle();

      // Check text is first currency (values in AppCurrencyPickerFormField are sorted)
      final sortedCurrencies = Currencies.all.keys.toList()..sort();
      expect(textFieldController(tester).value.text, sortedCurrencies.first);

      // Dialog closed
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets("showCurrencyPicker dismiss", (tester) async {
      final AppForm appForm = AppForm();

      const fieldName = AskField.currency;
      const label = AskViewText.currency;

      appForm.setValue(fieldName: fieldName, value: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCurrencyPickerFormField(
              appForm: appForm,
              fieldName: fieldName,
              initialValue: null,
              label: label,
            ),
          ),
        )
      );

      // Check text empty at first
      expect(textFieldController(tester).value.text, "");

      // Open Dialog
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(CurrencyCard), findsNWidgets(Currencies.all.length));

      // Dismiss dialog (by tapping on background)
      await tester.tapAt(const Offset(10.0, 10.0));
      await tester.pumpAndSettle();

      // Check text still empty; dialog closed
      expect(textFieldController(tester).value.text, "");
      expect(find.byType(Dialog), findsNothing);
    });
  });
}