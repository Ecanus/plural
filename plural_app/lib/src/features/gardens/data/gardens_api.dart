import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:plural_app/src/utils/app_state.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

/// Returns a list of [Garden] instances corresponding to [Garden] records from the
/// database that the given [userID] belongs to.
///
/// If [excludeCurrentGarden] is true, the [Garden] corresponding
/// to [AppState].currentGarden will be excluded from the list of results.
Future<List<Garden>> getGardensByUser(
  String userID, {
  bool excludeCurrentGarden = true,
}) async {
  List<Garden> gardens = [];
  var filter = "${UserGardenRecordField.user} = '$userID'";

  // excludeCurrentGarden
  if (excludeCurrentGarden) {
    final currentGardenID = GetIt.instance<AppState>().currentGarden!.id;
    filter = ""
      "${UserGardenRecordField.garden}.${GenericField.id} != '$currentGardenID' && "
      "$filter";
  }

  final query = await GetIt.instance<UserGardenRecordsRepository>().getList(
    expand: UserGardenRecordField.garden,
    filter: filter,
    sort: "garden.name",
  );

  for (final record in query.items) {
    final creator = await getUserByID(userID);
    final userGardenRecordJson =
      record.toJson()[QueryKey.expand][UserGardenRecordField.garden];

    final garden = Garden.fromJson(userGardenRecordJson, creator);
    gardens.add(garden);
  }

  return gardens;
}

/// Reroutes to the Landing page, and populates the [exitedGardenID] parameter
/// of the Landing page widget with the id of the [Garden] that
/// the current [User] has just exited.
Future<void> rerouteToLandingAndPrepareGardenExit(BuildContext context) async {
  final appState = GetIt.instance<AppState>();
  final exitedGardenID = appState.currentGarden!.id;

  // Reroute
  if (context.mounted) {
    GoRouter.of(context).go(
      Uri(
        path: Routes.landing,
        queryParameters: {
          "exitedGardenID": exitedGardenID}
      ).toString()
    );
  }
}

/// Deletes all Asks corresponding to the [User] record with the given [userID],
/// and deletes the [UserGardenRecord] record corresponding to the
/// User with [userID] and Garden with [exitedGardenID].
///
/// Calls the given [callback] once all database calls are done.
Future<void> removeUserFromGarden(
  String userID,
  String exitedGardenID,
  Function callback,
) async {
  final asksRepository = GetIt.instance<AsksRepository>();
  final userGardenRecordsRepository = GetIt.instance<UserGardenRecordsRepository>();

  // Delete all Asks corresponding to exitedGardenID
  final askRecords = await asksRepository.getList(
    filter: ""
    "${AskField.creator} = '$userID'"
    "&& ${AskField.garden} = '$exitedGardenID'"
  );
  await asksRepository.bulkDelete(records: askRecords);

  // Delete UserGardenRecord corresponding to userID and exitedGardenID
  final userGardenRecord = await userGardenRecordsRepository.getFirstListItem(
    filter: ""
      "${UserGardenRecordField.user} = '$userID' "
      "&& ${UserGardenRecordField.garden} = '$exitedGardenID'"
  );

  await GetIt.instance<UserGardenRecordsRepository>().delete(id: userGardenRecord!.id);

  callback();
}