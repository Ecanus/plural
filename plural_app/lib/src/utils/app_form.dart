import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

enum FormFieldType {
  currency,
  datetimeNow,
  int,
  string,
}

enum TextFieldType {
  text,
  digitsOnly
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
    required String errorMessage,
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
      case FormFieldType.currency:
        newValue = value.toString().trim().toUpperCase();
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

/// Checks on the given [fieldType] to determine which
/// [FilteringTextInputFormatter] to retrieve.
///
/// Returns a list with the correct [TextInputFormatter] values if one is found,
/// or null if none is found/needed.
List<TextInputFormatter>? getInputFormatters(TextFieldType fieldType, int maxLength) {
  switch (fieldType) {
    case TextFieldType.text:
      return [LengthLimitingTextInputFormatter(maxLength)];
    case TextFieldType.digitsOnly:
      return [
        LengthLimitingTextInputFormatter(maxLength),
        FilteringTextInputFormatter.digitsOnly];
  }

}