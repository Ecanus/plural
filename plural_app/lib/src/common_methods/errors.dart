import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/strings.dart';

Map<String, String> getErrorsMapFromClientException(ClientException e) {
  Map<String, String> errorsMap = {};
  var innerMap = e.response[ExceptionStrings.data];

  // Create map of fields and corresponding error messages
  for (var key in e.response[ExceptionStrings.data].keys) {
    var fieldName = key;
    var errorMessage = innerMap[key][ExceptionStrings.message];

    // Remove trailing period
    errorMessage.replaceAll(
      RegExp(r'.'),
      ""
    );

    errorsMap[fieldName] = errorMessage;
  }

  return errorsMap;
}