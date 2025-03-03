import 'package:pocketbase/pocketbase.dart';

const dataKey = "data";
const messageKey = "message";

Map<String, String> getErrorsMapFromClientException(ClientException e) {
  Map<String, String> errorsMap = {};
  var innerMap = e.response[dataKey];

  // Create map of fields and corresponding error messages
  for (var key in innerMap.keys) {
    var fieldName = key;
    var errorMessage = innerMap[key][messageKey];

    // Remove trailing period
    errorMessage.replaceAll(
      RegExp(r'.'),
      ""
    );

    errorsMap[fieldName] = errorMessage;
  }

  return errorsMap;
}