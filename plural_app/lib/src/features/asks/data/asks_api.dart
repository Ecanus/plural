import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/formats.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';
import 'package:plural_app/src/features/asks/domain/ask.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

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
  final currentSponsors = List<String>.from(askSponsorsString);
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

/// An action. Deletes the [Ask] corresponding to the given [askID].
Future<void> deleteAsk(
  BuildContext context,
  String askID, {
  bool isAdminPage = false,
}) async {
  try {
    // Check permissions
    if (isAdminPage) {
      await GetIt.instance<AppState>().verify(
        [AppUserGardenPermission.deleteMemberAsks]);
    } else {
      await GetIt.instance<AppState>().verify(
        [AppUserGardenPermission.createAndEditAsks]);
    }

    // Deletion should also rebuild Garden Timeline via SubscribeTo
    await GetIt.instance<AsksRepository>().delete(id: askID);

    if (context.mounted) {
      var snackBar = AppSnackBars.getSnackBar(
        SnackBarText.deleteAskSuccess,
        showCloseIcon: false,
        snackbarType: SnackbarType.success
      );

      // Display Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } on PermissionException {
    if (context.mounted) {
      final newRoute = isAdminPage ? Routes.garden : Routes.landing;

      // Redirect to UnauthorizedPage
      GoRouter.of(context).go(
        Uri(
          path: Routes.unauthorized,
          queryParameters: { QueryParameters.previousRoute: newRoute }
        ).toString()
      );
    }

    return;
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

    final filterString = "${AskField.garden} = '$gardenID' $filter".trim();

    // Query
    var resultList = await GetIt.instance<AsksRepository>().getList(
      filter: filterString,
      sort: sort
    );

    // Create instances
    for (var record in resultList.items) {
      final recordJson = record.toJson();
      final creator = await getUserByID(recordJson[AskField.creator]);
      final ask = Ask.fromJson(recordJson, creator);

      asks.add(ask);
    }

    if (count == null) {
      return asks;
    } else {
      // Return a sublist up to the lesser of count or asks.length
      return asks.sublist(0, min(count, asks.length));
    }
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
  final finalFilter = ""
    "${AskField.creator} = '$userID' && "
    "${AskField.garden} = '${currentGarden.id}' $filter".trim();

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
Future<List<Ask>> getAsksForListedAsksView({
  required String userID,
  required DateTime now,
}) async {
  final List<Ask> displayableAsks = [];
  final List<Ask> deadlinePassedAsks = [];
  final List<Ask> targetMetAsks = [];

  final asks = await getAsksByUserID(
    sort: GenericField.created,
    userID: userID,
  );

  for (Ask ask in asks) {
    if (ask.targetMetDate == null) {
      final deadlineDate = DateTime.parse(
        DateFormat(Formats.dateYMMddHHms).format(ask.deadlineDate)).toLocal();

      // Target not met, deadline not passed
      if (deadlineDate.isAfter(now)) {
        displayableAsks.add(ask);
      }

      // Target not met, deadline passed
      if (deadlineDate.isAtSameMomentAs(now) || deadlineDate.isBefore(now)) {
        deadlinePassedAsks.add(ask);
      }
    } else {
      // Target met
      targetMetAsks.add(ask);
    }
  }

  return displayableAsks + deadlinePassedAsks + targetMetAsks;
}

/// Queries on the [Ask] collection to create a list of all Asks
/// in the current Garden that the current User has already sponsored.
///
/// Returns the list of all related Asks.
Future<List<Ask>> getAsksForSponsoredAsksView({
  required DateTime now,
}) async {
  final currentUser = GetIt.instance<AppState>().currentUser!;
  final nowString = DateFormat(Formats.dateYMMddHHms).format(now);

  final filter = ""
    "&& ${AskField.targetMetDate} = null"
    "&& ${AskField.deadlineDate} > '$nowString'"
    "&& ${AskField.creator} != '${currentUser.id}'"
    "&& ${AskField.sponsors} ~ '${currentUser.id}'";

  List<Ask> asks = await getAsksByGardenID(
    gardenID: GetIt.instance<AppState>().currentGarden!.id,
    filter: filter
  );

  return asks;
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

/// Adds or removes the currentUser as a sponsor to the [Ask] corresponding to [askID].
Future<void> isSponsoredToggle(
  BuildContext context,
  String askID,
  Function(bool) callback, {
  required bool value,
}) async {
  var currentUserID = GetIt.instance<AppState>().currentUserID!;

  if (value) {
    await addSponsor(askID, currentUserID);

    final snackBar = AppSnackBars.getSnackBar(
      SnackBarText.askSponsored,
      showCloseIcon: false,
      snackbarType: SnackbarType.success
    );

    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    await removeSponsor(askID, currentUserID);
  }

  callback(value);
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