import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

/// Queries on the [Garden] collection to retrieve the record corresponding to
/// [gardenID].
///
/// Returns a [Garden] instance.
Future<Garden> getGardenByID(String gardenID) async {
  final record = await GetIt.instance<GardensRepository>().getFirstListItem(
    filter: "${GenericField.id} = '$gardenID'"
  );

  final recordJson = record.toJson();
  final creator = await getUserByID(recordJson[GardenField.creator]);

  return Garden.fromJson(recordJson, creator);
}

/// Returns a list of [Garden] instances corresponding to [Garden] records from the
/// database that [userID] belongs to.
///
/// If [excludesCurrentGarden] is true, the [Garden] corresponding
/// to [AppState].currentGarden will be excluded from the list of results.
Future<List<Garden>> getGardensByUserID(
  String userID, {
  bool excludesCurrentGarden = true,
}) async {
  List<Garden> gardens = [];
  var filter = "${UserGardenRecordField.user} = '$userID'";

  // excludesCurrentGarden
  if (excludesCurrentGarden) {
    final currentGardenID = GetIt.instance<AppState>().currentGarden!.id;
    filter = ""
      "${UserGardenRecordField.garden}.${GenericField.id} != '$currentGardenID' && "
      "$filter";
  }

  final resultList = await GetIt.instance<UserGardenRecordsRepository>().getList(
    expand: UserGardenRecordField.garden,
    filter: filter,
    sort: "garden.name",
  );

  for (final record in resultList.items) {
    final creator = await getUserByID(userID);
    final gardenRecord =
      record.toJson()[QueryKey.expand][UserGardenRecordField.garden];
    final garden = Garden.fromJson(gardenRecord, creator);

    gardens.add(garden);
  }

  return gardens;
}

/// Deletes the [UserGardenRecord] record corresponding to the
/// [User] with [userID] and Garden with [exitedGardenID].
///
/// Also deletes all Asks corresponding to the [User] record with the given [userID],
/// and calls the given [callback] once all database functionality is done.
Future<void> removeUserFromGarden(
  String userID,
  String exitedGardenID,
  void Function() callback,
) async {
  final asksRepository = GetIt.instance<AsksRepository>();
  final userGardenRecordsRepository = GetIt.instance<UserGardenRecordsRepository>();

  // Delete all Asks corresponding to exitedGardenID
  final askRecords = await asksRepository.getList(
    filter: ""
    "${AskField.creator} = '$userID'"
    "&& ${AskField.garden} = '$exitedGardenID'"
  );
  await asksRepository.bulkDelete(resultList: askRecords);

  // Delete UserGardenRecord corresponding to userID and exitedGardenID
  final userGardenRecord = await userGardenRecordsRepository.getFirstListItem(
    filter: ""
      "${UserGardenRecordField.user} = '$userID' "
      "&& ${UserGardenRecordField.garden} = '$exitedGardenID'"
  );

  await userGardenRecordsRepository.delete(id: userGardenRecord.id);

  callback();
}

/// Reroutes to the Landing page, with a non-null [exitedGardenID] value.
///
/// The value of [exitedGardenID] is the id of the [Garden] that
/// the current [User] has just exited.
Future<void> rerouteToLandingPageWithExitedGardenID(BuildContext context) async {
  final appState = GetIt.instance<AppState>();
  final exitedGardenID = appState.currentGarden!.id;

  // Reroute
  if (context.mounted) {
    GoRouter.of(context).go(
      Uri(
        path: Routes.landing,
        queryParameters: {
          QueryParameters.exitedGardenID: exitedGardenID}
      ).toString()
    );
  }
}

/// Subscribes to any changes made in the [Garden] collection for
/// the [Garden] record with the corresponding [gardenID].
///
/// Updates the value of [AppState] currentGarden whenever a change is made.
Future<Function> subscribeTo(String gardenID) async {
  // Always clear before setting new subscription
  await GetIt.instance<GardensRepository>().unsubscribe();

  return GetIt.instance<GardensRepository>().subscribe(gardenID);
}