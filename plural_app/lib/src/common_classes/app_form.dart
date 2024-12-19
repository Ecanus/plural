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

  /// Retrieves the value in [errors] associated with the given
  /// [fieldName] if one exists.
  ///
  /// Returns the retrieved value is a matching key is found, else null.
  String? getError({
    required String fieldName
  }) {
    if (!errors.containsKey(fieldName)) return null;

    return errors[fieldName];
  }

  /// Retrieves the value in [fields] associated with the given
  /// [fieldName].
  dynamic getValue({
    required String fieldName
  }) {
    return fields[fieldName];
  }

  /// Creates a new key-value pairing in [errors] where [fieldName]
  /// is the new key, and [errorMessage] is the corresponding value.
  void setError({
    required String fieldName,
    required String errorMessage,
  }) {
    errors[fieldName] = errorMessage;
  }

  /// Iterates over the given [errorsMap], where its keys are field names
  /// and its values are the corresponding error messages, and creates
  /// new key-value pairings within [errors].
  void setErrors({
    required Map errorsMap
  }) {
    for (var key in errorsMap.keys) {
      setError(fieldName: key, errorMessage: errorsMap[key]);
    }
  }

  /// Clears all values in [errors].
  void clearErrors() {
    errors.clear();
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