import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

enum FormFieldType {
  datetimeNow,
  int,
  string,
}

class AppForm {
  Map fields = {};
  Map errors = {};

  // Constructors
  AppForm();

  AppForm.fromMap(Map initialMap) {
    fields = initialMap;
    errors = {};

    for (var key in initialMap.keys) {
      errors[key] = "";
    }
  }

  String? getError({
    required String fieldName
  }) {
    if (!errors.containsValue(fieldName)) return null;

    return errors[fieldName];
  }

  dynamic getValue({
    required String fieldName
  }) {
    return fields[fieldName];
  }

  void setError({
    required String fieldName,
    required String error,
  }) {
    errors[fieldName] = error;
  }

  void setValue({
    required String fieldName,
    required dynamic value,
  }) {
    fields[fieldName] = value;
  }

  /// Saves the given [value] into this AppForm instance's [fields]
  /// using the given [FormFieldType] to properly format.
  void save({
    required String fieldName,
    required dynamic value,
    FormFieldType formFieldType = FormFieldType.string,
  }) {
    dynamic newValue;

    switch (formFieldType) {
      case FormFieldType.datetimeNow:
        newValue = value == true ?
          DateFormat(Strings.dateformatYMMdd).format(DateTime.now()) : null;
      case FormFieldType.int:
        newValue = int.parse(value);
      case FormFieldType.string:
        newValue = value.toString().trim();
    }

    fields[fieldName] = newValue;
  }
}