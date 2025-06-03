import 'package:flutter/services.dart';

enum TextFieldType {
  text,
  digitsOnly
}

/// Checks [fieldType] to determine which
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
        FilteringTextInputFormatter.digitsOnly
      ];
  }
}