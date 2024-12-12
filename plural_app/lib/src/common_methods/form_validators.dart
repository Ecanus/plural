import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Common Classes
import 'package:plural_app/src/common_classes/app_form.dart';

// Constants
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';

enum TextFieldType {
  text,
  digitsOnly
}

// TODO: Deprecate this (and use AppForm.save() instead)
void saveToMap(
  fieldName,
  modelMap,
  value,
  {FormFieldType formFieldType = FormFieldType.string}
  ) {
    switch (formFieldType) {
      case FormFieldType.datetimeNow:
        modelMap[fieldName] = value == true ?
          DateFormat(Strings.dateformatYMMdd).format(DateTime.now()) : null;
      case FormFieldType.int:
        modelMap[fieldName] = int.parse(value);
      case FormFieldType.string:
        modelMap[fieldName] = value.toString().trim();
    }
}

/// Checks on the given [fieldType] to determine which
/// [FilteringTextInputFormatter] to retrieve.
///
/// Returns a list with the correct [FilteringTextInputFormatter] if one is found,
/// or null if none is found/needed.
List<TextInputFormatter>? getInputFormatters(TextFieldType fieldType) {
  switch (fieldType) {
    case TextFieldType.text:
      return null;
    case TextFieldType.digitsOnly:
      return [FilteringTextInputFormatter.digitsOnly];
  }

}

/// Checks that the given [value] is valid for a CheckboxFormField.
///
/// Returns null if valid, else returns a String.
String? validateCheckboxFormField(bool? value) {
  if (value == null) return ErrorStrings.invalidValue;

  return null;
}

/// Checks that the given [value] matches the [compareValue].
///
/// Returns null if valid, else returns a String.
String? validateConfirmNewPassword(String? value, String? confirmValue) {
  if (value == null || value.isEmpty) return ErrorStrings.invalidValue;
  if (value != confirmValue) return ErrorStrings.passwordMismatch;

  return null;
}

/// Checks that the given [value] is valid for a DatePickerFormField.
///
/// Returns null if valid, else returns a String.
String? validateDatePickerFormField(String? value) {
  if (value == null) return ErrorStrings.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for an Email.
///
/// Returns null if valid, else returns a String.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return ErrorStrings.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for a New Password.
///
/// Returns null if valid, else returns a String.
String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) return ErrorStrings.invalidValue;

  var allChecks = [
    checkHasLowercase(value),
    checkHasNumber(value),
    checkHasSpecialCharacter(value),
    checkHasUppercase(value),
    checkPasswordLength(value)
  ];

  if (!allChecks.every((returnVal) => returnVal == true)) {
    return ErrorStrings.invalidPassword;
  }
  return null;
}

/// Checks that the given [value] is valid for a TextFormField.
///
/// Returns null if valid, else returns a String.
String? validateTextFormField(String? value) {
  if (value == null || value.isEmpty) return ErrorStrings.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for a Username or Email.
///
/// Returns null if valid, else returns a String.
String? validateUsernameOrEmail(String? value) {
  if (value == null || value.isEmpty) return ErrorStrings.invalidValue;

  return null;
}

/// Checks that the given [value] contains at least one lowercase character.
///
/// Returns true if valid, else false.
bool checkHasLowercase(String? value) {
  if (value == null || value.isEmpty) return false;

  return value.contains(RegExp(r'[a-z]'));
}

/// Checks that the given [value] contains at least one numeric character.
///
/// Returns true if valid, else false.
bool checkHasNumber(String? value) {
  if (value == null || value.isEmpty) return false;

  return value.contains(RegExp(r'[0-9]'));
}

/// Checks that the given [value] contains at least one special character.
///
/// Returns true if valid, else false.
bool checkHasSpecialCharacter(String? value) {
  if (value == null || value.isEmpty) return false;

  return value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

/// Checks that the given [value] contains at least one uppercase character.
///
/// Returns true if valid, else false.
bool checkHasUppercase(String? value) {
  if (value == null || value.isEmpty) return false;

  return value.contains(RegExp(r'[A-Z]'));
}

/// Checks that the given [valueA] is equivalent to [valueB].
///
/// Returns true if valid, else false.
bool checkPasswordsMatch(String? valueA, String? valueB) {
  if (valueA == null || valueB == null || valueA.isEmpty || valueB.isEmpty) {
    return false;
  }

  return valueA == valueB;
}

/// Checks that the given [value] has value within the minimum and maximum
/// length of an accepted password.
///
/// Returns true valid, else false.
bool checkPasswordLength(String? value) {
  if (value == null || value.isEmpty) return false;

  return (
    value.length >= FormValues.passwordMinLength &&
    value.length <= FormValues.passwordMaxLength);
}