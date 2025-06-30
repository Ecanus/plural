import 'dart:math';

import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

/// Appends the [User] record that corresponds to [userID] to the list
/// of sponsors of the [Ask] record which corresponds to [askID].
Future<void> addSponsor(String askID, String userID) async {
  final resultList = await GetIt.instance<AsksRepository>().getList(
    filter: "${GenericField.id} = '$askID'"
  );

  // If ask already contains sponsor, return
  final askSponsorsString = resultList.items.first.toJson()[AskField.sponsors];
  var currentSponsors = List<String>.from(askSponsorsString);
  if (currentSponsors.contains(userID)) return;

  // Else, update
  currentSponsors.add(userID);
  final body = { AskField.sponsors: currentSponsors};

  await GetIt.instance<AsksRepository>().update(
    id: askID,
    body: body,
  );
}

/// Checks if [boon] is strictly less than [targetSum].
///
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

/// Deletes all [Ask] records associated with the currentUser.
Future<void> deleteCurrentUserAsks() async {
  final currentUser = GetIt.instance<AppState>().currentUser!;

  final resultList = await GetIt.instance<AsksRepository>().getList(
    filter: "${AskField.creator} = '${currentUser.id}'"
  );

  await GetIt.instance<AsksRepository>().bulkDelete(resultList: resultList);
}

/// Queries on the [Ask] collection to retrieve records corresponding to [gardenID],
/// [filter] and [sort].
///
/// Returns the list of retrieved [Ask]s up to [count], if count is non-null,
/// else returns all retrieved Asks.
Future<List<Ask>> getAsksByGardenID({
  required String gardenID,
  int? count,
  String filter = "",
  String sort = "${AskField.deadlineDate},${GenericField.created}",
  }) async {
    List<Ask> asks = [];

    var finalFilter = "${AskField.garden} = '$gardenID' $filter".trim();

    // Query
    var resultList = await GetIt.instance<AsksRepository>().getList(
      filter: finalFilter,
      sort: sort
    );

    // Create instances
    for (var record in resultList.items) {
      final recordJson = record.toJson();
      final creator = await getUserByID(recordJson[AskField.creator]);
      final ask = Ask.fromJson(recordJson, creator);

      asks.add(ask);
    }

    // If count is non-null, return a sublist up to the lesser of count or asks.length
    final limit = count != null ? min(count, asks.length) : asks.length;
    return asks.sublist(0, limit);
}

/// Queries on the [Ask] collection to retrieve all records corresponding
/// to [userID], [filter], [sort], and the current [Garden].
///
/// Returns the list of retrieved [Ask]s.
Future<List<Ask>> getAsksByUserID({
  required String userID,
  String filter = "",
  String sort = "",
}) async {
  List<Ask> asks = [];

  final currentGarden = GetIt.instance<AppState>().currentGarden!;
  final finalFilter = """
        ${AskField.creator} = '$userID' &&
        ${AskField.garden} = '${currentGarden.id}' $filter
        """.trim();

  // Query
  var resultList = await GetIt.instance<AsksRepository>().getList(
    filter: finalFilter,
    sort: sort,
  );

  // Create instances
  for (var record in resultList.items) {
    final creator = await getUserByID(userID);
    final ask = Ask.fromJson(record.toJson(), creator);

    asks.add(ask);
  }

  return asks;
}

/// Queries on the [Ask] collection to create a list of all Asks
/// corresponding to [userID] and the current [Garden].
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
  final asks = await getAsksByUserID(
    filter: filterString,
    sort: GenericField.created,
    userID: userID,
  );

  // Target not met, deadline passed
  final deadlinePassedFilterString = ""
    "&& ${AskField.targetMetDate} = null"
    "&& ${AskField.deadlineDate} <= '$nowString'";
  final deadlinePassedAsks = await getAsksByUserID(
    filter: deadlinePassedFilterString,
    sort: GenericField.created,
    userID: userID,
  );

  // Target met
  final targetMetFilterString = "&& ${AskField.targetMetDate} != null";
  final targetMetAsks = await getAsksByUserID(
    filter: targetMetFilterString,
    sort: GenericField.created,
    userID: userID,
  );

  return asks + deadlinePassedAsks + targetMetAsks;
}

/// Returns the [AskType] enum that corresponds to [askTypeString].
AskType getAskTypeFromString(String askTypeString) {
  return AskType.values.firstWhere(
    (a) => a.name == askTypeString,
    orElse: () => AskType.monetary
  );
}

/// Checks if [targetMetDateString] is non-empty, and returns a DateTime
/// of the parsed string if true, else returns null.
DateTime? getParsedTargetMetDate(String targetMetDateString) {
  return targetMetDateString.isNotEmpty ?
    DateTime.parse(targetMetDateString) : null;
}

/// Removes the [User] record which corresponds to [userID] from the list
/// of sponsors of the [Ask] record which corresponds to [askID].
Future<void> removeSponsor(String askID, String userID) async {
  var resultList = await GetIt.instance<AsksRepository>().getList(
    filter: "${GenericField.id} = '$askID'"
  );

  // If ask does not contain sponsor, return
  final askSponsorsString = resultList.items.first.toJson()[AskField.sponsors];
  var currentSponsors = List<String>.from(askSponsorsString);
  if (!currentSponsors.contains(userID)) return;

  // Else, update
  currentSponsors.remove(userID);
  final body = { AskField.sponsors: currentSponsors};

  await GetIt.instance<AsksRepository>().update(
    id: askID,
    body: body,
  );
}

/// Subscribes to any changes made in the [Ask] collection for any [Ask] record
/// associated with [gardenID].
///
/// Calls the given [callback] method whenever a change is made.
Future<Function> subscribeTo(
  String gardenID,
  Function callback
  ) async {
    await GetIt.instance<AsksRepository>().unsubscribe();
    Future<Function> unsubscribeFunc = GetIt.instance<AsksRepository>().subscribe(
      gardenID, callback);

    return unsubscribeFunc;
}