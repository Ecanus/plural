import 'package:intl/intl.dart';

// Constants
import 'package:plural_app/src/constants/formats.dart';

// Keep naming consistent with TextFieldType, where possible
enum FormFieldType {
  currency,
  datetimeNow,
  digitsOnly,
  text,
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
      errors[key] = null;
    }
  }

  /// Retrieves the value in [errors] associated with the given
  /// [fieldName] if one exists.
  ///
  /// Returns the retrieved value if a matching key is found, else null.
  String? getError({required String fieldName}) {
    if (!errors.containsKey(fieldName)) return null;

    return errors[fieldName];
  }

  /// Retrieves the value in [fields] associated with the given
  /// [fieldName].
  dynamic getValue({required String fieldName}) {
    return fields[fieldName];
  }

  /// Creates a new key-value pairing in [errors] where [fieldName]
  /// is the new key, and [errorMessage] is the corresponding value.
  void setError({
    required String fieldName,
    required String? errorMessage,
  }) {
    errors[fieldName] = errorMessage;
  }

  /// Iterates over the given [errorsMap], where its keys are field names
  /// and its values are the corresponding error messages, and creates
  /// new key-value pairings within [errors].
  void setErrors({required Map errorsMap}) {
    for (var key in errorsMap.keys) {
      setError(fieldName: key, errorMessage: errorsMap[key]);
    }
  }

  /// Sets all values in [errors] to null.
  void clearErrors() {
    for (var key in errors.keys) {
      errors[key] = null;
    }
  }

  /// Assigns the given [value] to the value of the key-value pairing in [fields]
  /// with a key that matches [fieldName].
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
    FormFieldType formFieldType = FormFieldType.text,
  }) {
    dynamic newValue;

    switch (formFieldType) {
      case FormFieldType.currency:
        newValue = value.toString().trim().toUpperCase();
      case FormFieldType.datetimeNow:
        newValue = value == true ?
          DateFormat(Formats.dateYMMdd).format(DateTime.now()) : null;
      case FormFieldType.digitsOnly:
        newValue = int.parse(value);
      case FormFieldType.text:
        newValue = value.toString().trim();
    }

    fields[fieldName] = newValue;
  }
}