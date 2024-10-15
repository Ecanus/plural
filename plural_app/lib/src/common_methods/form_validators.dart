import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Constants
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

String? validateTextFormField(String? value) {
  if (value == null || value.isEmpty) return ErrorString.invalidValue;

  return null;
}

String? validateDatePickerFormField(String? value) {
  if (value == null) return ErrorString.invalidValue;

  return null;
}

String? validateCheckboxFormField(bool? value) {
  if (value == null) return ErrorString.invalidValue;

  return null;
}