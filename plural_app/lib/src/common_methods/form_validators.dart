import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Constants
import 'package:plural_app/src/constants/form_values.dart';
import 'package:plural_app/src/constants/strings.dart';

enum FormFieldType {
  datetimeNow,
  int,
  string,
}

enum TextFieldType {
  text,
  digitsOnly
}

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
  if (value == null) return ErrorString.invalidValue;

  return null;
}

/// Checks that the given [value] matches the [compareValue].
///
/// Returns null if valid, else returns a String.
String? validateConfirmNewPassword(String? value, String? confirmValue) {
  if (value == null || value.isEmpty) return ErrorString.invalidValue;
  if (value != confirmValue) return ErrorString.passwordMismatch;

  return null;
}

/// Checks that the given [value] is valid for a DatePickerFormField.
///
/// Returns null if valid, else returns a String.
String? validateDatePickerFormField(String? value) {
  if (value == null) return ErrorString.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for an Email.
///
/// Returns null if valid, else returns a String.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return ErrorString.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for a New Password.
///
/// Returns null if valid, else returns a String.
String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) return ErrorString.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for a TextFormField.
///
/// Returns null if valid, else returns a String.
String? validateTextFormField(String? value) {
  if (value == null || value.isEmpty) return ErrorString.invalidValue;

  return null;
}

/// Checks that the given [value] is valid for a Username or Email.
///
/// Returns null if valid, else returns a String.
String? validateUsernameOrEmail(String? value) {
  if (value == null || value.isEmpty) return ErrorString.invalidValue;

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

/// Checks that the given [value] has value within the minimum and maximum
/// length of an accepted password.
///
/// Returns true valid, else false.
bool checkPasswordLength(String? value) {
  if (value == null || value.isEmpty) return false;

  return (
    value.length >= SignInPage.passwordMinLength &&
    value.length <= SignInPage.passwordMaxLength);
}