import 'package:flutter/services.dart';
import 'package:test/test.dart';

// Common Functions
import 'package:plural_app/src/common_functions/input_formatters.dart';

void main() {
  group("Input formatters test", () {
    test("getInputFormatters", () {
      // TextFieldType.text
      var textFormatter = getInputFormatters(TextFieldType.text, 10);
      expect(textFormatter != null && textFormatter.length == 1, true);
      expect(
        textFormatter!.any((e) => e.runtimeType == LengthLimitingTextInputFormatter),
        true
      );

      // TextFieldType.digitsOnly
      var digitsFormatter = getInputFormatters(TextFieldType.digitsOnly, 10);
      expect(digitsFormatter != null && digitsFormatter.length == 2, true);
      expect(
        digitsFormatter!.any((e) => e.runtimeType == LengthLimitingTextInputFormatter),
        true
      );
      expect(
        digitsFormatter.any((e) => e.runtimeType == FilteringTextInputFormatter),
        true
      );

    });
  });
}