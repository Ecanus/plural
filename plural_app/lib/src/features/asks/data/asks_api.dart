import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/exceptions.dart';

/// Iterates over the given [query] to generate a list of [Ask] instances.
///
/// Returns a list of the created [Ask] instances.
Future<List<Ask>> createAskInstancesFromQuery(
  query,
  { int? count }
) async {
    final authRepository = GetIt.instance<AuthRepository>();

    var records = query.toJson()[QueryKey.items];

    if (count != null && records.length >= count) {
      records = records.sublist(0, count);
    }

    List<Ask> instances = [];

    for (var record in records) {
      // Parse targetMetDate if non-null
      String targetMetDateString = record[AskField.targetMetDate];
      DateTime? parsedTargetMetDate = targetMetDateString.isNotEmpty ?
        DateTime.parse(targetMetDateString) : null;

      // Get AppUser that created the Ask
      var creatorID = record[AskField.creator];
      var creator = await authRepository.getUserByID(creatorID);

      // Get type enum from the record (a string)
      var askTypeFromString = AskType.values.firstWhere(
        (a) => a.name == "AskType.${record[AskField.type]}",
        orElse: () => AskType.monetary
      );

      var newAsk = Ask(
        id: record[GenericField.id],
        boon: record[AskField.boon],
        creator: creator,
        creationDate: DateTime.parse(record[GenericField.created]),
        currency: record[AskField.currency],
        description: record[AskField.description],
        deadlineDate: DateTime.parse(record[AskField.deadlineDate]),
        instructions: record[AskField.instructions],
        targetSum: record[AskField.targetSum],
        targetMetDate: parsedTargetMetDate,
        type: askTypeFromString
      );

      newAsk.sponsorIDS = List<String>.from(record[AskField.sponsors]);
      instances.add(newAsk);
    }

    return instances;
}

/// Queries on the [Ask] collection to create a list of all Asks
/// corresponding to the given [userID] and the current [Garden]
///
/// Returns the list of all related Asks.
Future<List<Ask>> getAsksForListedAsksDialog({
  required String userID,
  required String nowString,
}) async {
  // Target not met, deadline not passed
  final filterString = ""
    "&& ${AskField.targetMetDate} = null"
    "&& ${AskField.deadlineDate} > '$nowString'";
  final asks = await GetIt.instance<AsksRepository>().getAsksByUserID(
    filterString: filterString,
    sortString: GenericField.created,
    userID: userID,
  );

  // Target not met, deadline passed
  final deadlinePassedFilterString = ""
    "&& ${AskField.targetMetDate} = null"
    "&& ${AskField.deadlineDate} <= '$nowString'";
  final deadlinePassedAsks = await GetIt.instance<AsksRepository>().getAsksByUserID(
    filterString: deadlinePassedFilterString,
    sortString: GenericField.created,
    userID: userID,
  );

  // Target met
  final targetMetFilterString = "&& ${AskField.targetMetDate} != null";
  final targetMetAsks = await GetIt.instance<AsksRepository>().getAsksByUserID(
    filterString: targetMetFilterString,
    sortString: GenericField.created,
    userID: userID,
  );

  return asks + deadlinePassedAsks + targetMetAsks;
}

/// Checks if [boon] is strictly less than [targetSum].
/// Else, throws a [ClientException]
void checkBoonCeiling(int boon, int targetSum) {
  if (boon >= targetSum) {
    Map<String, dynamic> response = {
      dataKey: {
        AskField.boon: {
          messageKey: AppFormText.invalidBoonValue
        }
      },
    };

    throw ClientException(response: response);
  }
}