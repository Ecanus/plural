import 'package:validators/validators.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/currencies.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

/// Validates that the given [value] is valid for a CheckboxFormField.
///
/// Returns null if valid, else returns a String.
String? validateCheckboxFormField(bool? value) {
  if (value == null) return AppFormText.invalidValue;

  return null;
}

/// Validates that the given [value] matches the [compareValue].
///
/// Returns null if valid, else returns a String.
String? validateConfirmNewPassword(String? value, String? confirmValue) {
  if (value == null || value.isEmpty) return AppFormText.invalidValue;
  if (value != confirmValue) return SignInPageText.passwordMismatch;

  return null;
}

/// Validates that the given [value] is a valid currency code contained in Currencies.
///
/// Returns null if valid, else returns a String.
String? validateCurrency(String? value) {
  if (value == null || value.isEmpty || !Currencies.all.containsKey(value)) {
    return AppFormText.invalidValue;
  }

  return null;
}

/// Checks that the given [value] is valid for a DatePickerFormField.
///
/// Returns null if valid, else returns a String.
String? validateDatePickerFormField(String? value) {
  if (value == null || value.isEmpty || !isDate(value)) return AppFormText.invalidValue;

  return null;
}

/// Validates that the given [value] is valid for a TextFormField of
/// TextFieldType.digitsOnly.
///
/// Returns null if valid, else returns a String.
String? validateDigitsOnly(String? value) {
  if (value == null || value.isEmpty || !isNumeric(value)) {
    return AppFormText.invalidValue;
  }

  return null;
}

/// Validates that the given [value] is valid for an Email.
///
/// Returns null if valid, else returns a String.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty || !isEmail(value)) return AppFormText.invalidValue;

  return null;
}

/// Validates that the given [value] is valid for a New Password.
///
/// Returns null if valid, else returns a String.
String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) return AppFormText.invalidValue;

  var allChecks = [
    checkHasLowercase(value),
    checkHasNumber(value),
    checkHasSpecialCharacter(value),
    checkHasUppercase(value),
    checkPasswordLength(value)
  ];

  if (!allChecks.every((returnVal) => returnVal == true)) {
    return AppFormText.invalidPassword;
  }
  return null;
}

/// Validates that the given [value] is valid for a TextFormField of
/// TextFieldType.text.
///
/// Returns null if valid, else returns a String.
String? validateText(String? value) {
  if (value == null || value.isEmpty) return AppFormText.invalidValue;

  return null;
}

/// Validates that the given [value] is valid for a Username or Email.
///
/// Returns null if valid, else returns a String.
String? validateUsernameOrEmail(String? value) {
  if (value == null || value.isEmpty) return AppFormText.invalidValue;

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
    value.length >= AppMaxLengths.max9 &&
    value.length <= AppMaxLengths.max64
  );
}