import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/query_parameters.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/auth_api.dart';
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

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

/// An action. Updates the name of the [Garden] record corresponding to the values in
/// [map].
Future<(RecordModel?, Map?)> updateGardenName(
  BuildContext context,
  Map map,
) async {
  try {
    // Check permissions first
    await GetIt.instance<AppState>().verify(
      [AppUserGardenPermission.changeGardenName]);

    final (record, errorsMap) = await GetIt.instance<GardensRepository>().update(
      id: map[GenericField.id],
      body: {
        GardenField.name: map[GardenField.name]
      }
    );

    return (record, errorsMap);
  } on PermissionException {
    if (context.mounted) {
      // Redirect to UnauthorizedPage
      GoRouter.of(context).go(
        Uri(
          path: Routes.unauthorized,
          queryParameters: { QueryParameters.previousRoute: Routes.garden }
        ).toString()
      );
    }

    return (null, null);
  }
}