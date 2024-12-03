import 'package:go_router/go_router.dart';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:plural_app/src/constants/routes.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import "package:plural_app/src/features/authentication/domain/app_user_settings.dart";
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import "package:plural_app/src/features/gardens/domain/garden.dart";
import 'package:plural_app/src/features/gardens/domain/garden_manager.dart';

// Service Locator
import 'package:plural_app/src/utils/service_locator.dart';

class AuthRepository {
  AuthRepository({
    required this.pb,
  }) {
    var user = pb.authStore.model;
    user = user.toJson();

    currentUser = AppUser(
      id: user[GenericField.id],
      email: user[UserField.email],
      firstName: user[UserField.firstName],
      lastName: user[UserField.lastName],
    );
  }

  final PocketBase pb;

  AppUser? currentUser;

  String getCurrentUserID() {
    return currentUser!.id;
  }

  /// Sets the [currentUser]'s [latestGardenRecord] to their most recently
  /// updated [UserGardenRecord].
  Future<void> setCurrentUserLatestGardenRecord() async {
    var user = pb.authStore.model;
    user = user.toJson();

    var result = await pb.collection(Collection.userGardenRecords).getList(
      sort: "-updated",
      filter: "user = '${currentUser!.id}'"
    );

    var record = result.toJson()[PBKey.items][0];
    String gardenID = record[UserGardenRecordField.gardenID];

    final gardensRepository = GetIt.instance<GardensRepository>();
    var garden = await gardensRepository.getGardenByID(gardenID);

    currentUser!.latestGardenRecord = AppUserGardenRecord(
      id: record[GenericField.id],
      user: currentUser!,
      garden: garden
    );
  }

  /// Queries on the [UserGardenRecord] collection to retrieve all [User]s
  /// with the same [Garden] as the current [Garden].
  ///
  /// Returns the list of retrieved [User]s.
  Future<List<AppUser>> getCurrentGardenUsers() async {
    String currentGardenID = GetIt.instance<GardenManager>().currentGarden!.id;
    List<AppUser> instances = [];

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.user,
      filter: "${UserGardenRecordField.garden} = '$currentGardenID'",
      sort: "user.lastName, user.firstName"
    );

    // TODO: Raise error if result is empty
    var records = result.toJson()[PBKey.items];

    for (var record in records) {
      var userRecord = record[PBKey.expand][UserGardenRecordField.user];

      var userInstance = AppUser(
        id: record[UserGardenRecordField.userID],
        email: userRecord[UserField.email],
        firstName: userRecord[UserField.firstName],
        lastName: userRecord[UserField.lastName]
      );

      instances.add(userInstance);
    }

    return instances;
  }

  /// Queries on the [User] collection to retrieve the [User] with
  /// an ID matching the given [id] parameter.
  ///
  /// Returns an [AppUser] instance.
  Future<AppUser> getUserByID(String id) async {
    var result = await pb.collection(Collection.users).getFirstListItem(
      "${GenericField.id} = '$id'"
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();

    return AppUser(
      id: record[GenericField.id],
      email: record[UserField.email],
      firstName: record[UserField.firstName],
      lastName: record[UserField.lastName]
    );
  }

  /// Queries on the [UserGardenRecord] collection to update the date of the
  /// the record which corresponds to the given [user] and [garden] parameters.
  Future<void> updateUserGardenRecord(AppUser user, Garden garden) async {
    var result = await pb.collection(Collection.userGardenRecords).getFirstListItem(
      """
      ${UserGardenRecordField.userID} = '${user.id}' &&
      ${UserGardenRecordField.gardenID} = '${garden.id}'
      """
    );

    var userGardenRecord = result.toJson();

    await pb.collection(Collection.userGardenRecords).update(
      userGardenRecord[GenericField.id],
      body: {
        GenericField.updated: DateFormat(Strings.dateformatYMMdd).format(DateTime.now()),
      }
    );
  }

  /// Queries on the [UserSettings] collection to retrieve the record which
  /// corresponds to the [currentUser].
  ///
  /// Returns an [AppUserSettings] instance.
  Future<AppUserSettings> getCurrentUserSettings() async {
    var result = await pb.collection(Collection.userSettings).getFirstListItem(
      "${UserSettingsField.userID} = '${currentUser!.id}'"
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[GenericField.id],
      user: currentUser!,
      textSize: record[UserSettingsField.textSize]
    );
  }

  /// Queries on the [UserSettings] collection to update the record
  /// which corresponds to the [map] parameter.
  ///
  /// Returns an [AppUserSettings] instance.
  Future<AppUserSettings> updateUserSettings(Map map) async {
    var result = await pb.collection(Collection.userSettings).update(
      map[GenericField.id],
      body: {
        UserSettingsField.userID: getCurrentUserID(),
        UserSettingsField.textSize: map[UserSettingsField.textSize],
      }
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[GenericField.id],
      user: currentUser!,
      textSize: record[UserSettingsField.textSize]
    );
  }
}

/// Attempts to log into the database with the given [usernameOrEmail]
/// and [password] parameters. And creates all necessary [GetIt] instances.
///
/// Returns true if log in is successful, else false.
Future<bool> login(String usernameOrEmail, String password) async {
  var pb = PocketBase("http://127.0.0.1:8090"); // TODO: Change url dynamically by env

  try {
    await pb.collection(Collection.users).authWithPassword(
    usernameOrEmail, password);

    await registerGetItInstances(pb);
    return true;
  } on ClientException {
    return false;
  }
}

/// Logs out of the database and clears all [GetIt] instances.
Future<void> logout(context) async {
  final getIt = GetIt.instance;

  getIt<PocketBase>().authStore.clear();
  await getIt.reset();

  if (context.mounted) GoRouter.of(context).go(Routes.signIn);
}