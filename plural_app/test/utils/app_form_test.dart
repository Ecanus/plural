import 'package:test/test.dart';
import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';

// Utils
import 'package:plural_app/src/utils/app_form.dart';

void main() {
  group("AppForm test", () {
    var form1 = AppForm();

    var initialMap = {
      UserSettingsField.defaultCurrency: "HKD",
      UserSettingsField.defaultInstructions: "The default instructions!",
      GenericField.id: "USERSETTINGSID",
      UserSettingsField.user: "USERID",
    };
    var form2 = AppForm.fromMap(initialMap);

    test("constructor", () {
      // Form1
      expect(form1.fields.isEmpty, true);
      expect(form1.errors.isEmpty, true);

      // Form2
      var initialErrorsMap = {
        UserSettingsField.defaultCurrency: null,
        UserSettingsField.defaultInstructions: null,
        GenericField.id: null,
        UserSettingsField.user: null,
      };

      expect(form2.fields, initialMap);
      expect(form2.errors, initialErrorsMap);
    });

    test("getError,setError", () {
      var thisForm = AppForm.fromMap(initialMap);

      expect(thisForm.getError(fieldName: UserSettingsField.defaultCurrency), null);

      thisForm.setError(
        fieldName: UserSettingsField.defaultCurrency,
        errorMessage: "The value of currency is not valid"
      );

      expect(
        thisForm.getError(fieldName: UserSettingsField.defaultCurrency),
        "The value of currency is not valid"
      );

      expect(thisForm.getError(fieldName: "NonContainedField"), null);
    });

    test("getValue,setValue", () {
      var thisForm = AppForm.fromMap(initialMap);

      expect(thisForm.getValue(fieldName: UserSettingsField.defaultCurrency), "HKD");
      thisForm.setValue(fieldName: UserSettingsField.defaultCurrency, value: "GHS");
      expect(thisForm.getValue(fieldName: UserSettingsField.defaultCurrency), "GHS");
    });

    test("setErrors,clearErrors", () {
      var thisForm = AppForm.fromMap(initialMap);

      expect(thisForm.getError(fieldName: UserSettingsField.defaultCurrency), null);
      expect(thisForm.getError(fieldName: UserSettingsField.defaultInstructions), null);
      expect(thisForm.getError(fieldName: GenericField.id), null);

      var errorsMap = {
        UserSettingsField.defaultCurrency: "Error with currency",
        UserSettingsField.defaultInstructions: "Error with instructions",
        GenericField.id: "Error with id",
      };

      thisForm.setErrors(errorsMap: errorsMap);

      expect(
        thisForm.getError(fieldName: UserSettingsField.defaultCurrency),
        "Error with currency"
      );
      expect(
        thisForm.getError(fieldName: UserSettingsField.defaultInstructions),
        "Error with instructions"
      );
      expect(
        thisForm.getError(fieldName: GenericField.id),
        "Error with id"
      );

      thisForm.clearErrors();
      expect(thisForm.getError(fieldName: UserSettingsField.defaultCurrency), null);
      expect(thisForm.getError(fieldName: UserSettingsField.defaultInstructions), null);
      expect(thisForm.getError(fieldName: GenericField.id), null);
    });

    test("save", () {
      var thisForm = AppForm();
      thisForm.setValue(fieldName: "testCurrency", value: null);
      thisForm.setValue(fieldName: "testDateTime", value: null);
      thisForm.setValue(fieldName: "testNumber", value: null);
      thisForm.setValue(fieldName: "testString", value: null);

      // FormFieldType.currency
      expect(thisForm.getValue(fieldName: "testCurrency"), null);
      thisForm.save(
        fieldName: "testCurrency",
        value: "krw ",
        formFieldType: FormFieldType.currency
      );
      expect(thisForm.getValue(fieldName: "testCurrency"), "KRW");

      // FormFieldType.datetimeNow
      expect(thisForm.getValue(fieldName: "testDateTime"), null);
      thisForm.save(
        fieldName: "testDateTime",
        value: true,
        formFieldType: FormFieldType.datetimeNow
      );
      var date = DateFormat(Formats.dateYMMdd).format(DateTime.now());
      expect(thisForm.getValue(fieldName: "testDateTime"), date);

      // FormFieldType.digitsOnly
      expect(thisForm.getValue(fieldName: "testNumber"), null);
      thisForm.save(
        fieldName: "testNumber",
        value: "1966",
        formFieldType: FormFieldType.digitsOnly
      );
      expect(thisForm.getValue(fieldName: "testNumber"), 1966);

      // FormFieldType.text
      expect(thisForm.getValue(fieldName: "testString"), null);
      thisForm.save(
        fieldName: "testString",
        value: "pickles",
        formFieldType: FormFieldType.text
      );
      expect(thisForm.getValue(fieldName: "testString"), "pickles");
    });
  });
}