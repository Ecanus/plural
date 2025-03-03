import 'package:plural_app/src/common_functions/errors.dart' as errors;

import 'package:pocketbase/pocketbase.dart';
import 'package:test/test.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

void main() {
  group("Errors test", () {
    test("getErrorsMapFromClientException", () {
      var exception = ClientException(
        url: Uri(),
        originalError: "This is the original error",
        response: {
          errors.dataKey: {
            GenericField.id: {
              errors.messageKey: "This id is invalid"
            },
            AskField.currency: {
              errors.messageKey: "This currency is invalid"
            },
            AskField.instructions: {
              errors.messageKey: "These instructions are invalid"
            },
            AskField.sponsors: {
              errors.messageKey: "These sponsors are invalid"
            }
          }
        },
      );

      var errorMap = {
        "id": "This id is invalid",
        "currency": "This currency is invalid",
        "instructions": "These instructions are invalid",
        "sponsors": "These sponsors are invalid",
      };

      expect(errors.getErrorsMapFromClientException(exception), errorMap);
    });
  });
}