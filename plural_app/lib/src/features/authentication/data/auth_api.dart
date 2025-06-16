import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Common Widgets
import 'package:plural_app/src/common_widgets/app_snackbars.dart';

// Constants
import 'package:plural_app/src/constants/app_values.dart';
import 'package:plural_app/src/constants/environments.dart';
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Asks
import 'package:plural_app/src/features/asks/data/asks_api.dart';
import 'package:plural_app/src/features/asks/data/asks_repository.dart';

// Auth
import 'package:plural_app/src/features/authentication/data/user_garden_records_repository.dart';
import 'package:plural_app/src/features/authentication/data/user_settings_repository.dart';
import 'package:plural_app/src/features/authentication/data/users_repository.dart';
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_api.dart';
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';

// Localization
import 'package:plural_app/src/localization/lang_en.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';
import 'package:plural_app/src/utils/service_locator.dart';

/// Attempts to delete a [User] record, by first deleting all associated records
/// across all Collections, then deletes the [User] record itself.
///
/// Returns true if all deletions are successful. Else returns false.
Future<bool> deleteCurrentUserAccount({BuildContext? context}) async {
  try {
    // Delete Asks
    await deleteCurrentUserAsks();

    // Delete UserGardenRecords
    await deleteCurrentUserGardenRecords();

    // Delete UserSettings
    await deleteCurrentUserSettings();

    // Delete User
    await deleteCurrentUser();

    if (context != null && context.mounted) {
      // Route to Sign in Page
      GoRouter.of(context).go(Routes.signIn);

      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.deletedUserAccount,
        duration: AppDurations.s9,
        snackbarType: SnackbarType.success
      );

      // Display success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return true;
  } on ClientException catch (e) {
    // Log error
    developer.log(
      "auth_api.deleteCurrentUserAccount() error",
      error: e,
    );

    if (context != null && context.mounted) {
      var snackBar = AppSnackbars.getSnackbar(
        SnackbarText.deletedUserAccountFailed,
        duration: AppDurations.s9,
        snackbarType: SnackbarType.error
      );

      // Display error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }
}

/// Deletes the [UserGardenRecord] records corresponding to [AppState].currentUser.id
Future<void> deleteCurrentUserGardenRecords() async {
  final userGardenRecordsRepository = GetIt.instance<UserGardenRecordsRepository>();
  final currentUser = GetIt.instance<AppState>().currentUser!;

  final resultList = await userGardenRecordsRepository.getList(
    filter: "${UserGardenRecordField.user} = '${currentUser.id}'",
  );

  await userGardenRecordsRepository.bulkDelete(resultList: resultList);
}

/// Deletes the [User] record corresponding to [AppState].currentUser
Future<void> deleteCurrentUser() async {
  final currentUser = GetIt.instance<AppState>().currentUser!;
  await GetIt.instance<UsersRepository>().delete(id: currentUser.id);
}

/// Deletes the [UserSettings] record corresponding to [AppState].currentUser.id
Future<void> deleteCurrentUserSettings() async {
  final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;
  await GetIt.instance<UserSettingsRepository>().delete(id: currentUserSettings.id);
}

/// Queries on the [UserGardenRecord] collection to retrieve all [User]s
/// with the same [Garden] as the currentGarden.
///
/// Returns the list of retrieved [AppUser]s.
Future<List<AppUser>> getCurrentGardenUsers() async {
  String currentGardenID = GetIt.instance<AppState>().currentGarden!.id;
  List<AppUser> users = [];

  final resultList = await GetIt.instance<UserGardenRecordsRepository>().getList(
    expand: UserGardenRecordField.user,
    filter: "${UserGardenRecordField.garden} = '$currentGardenID'",
    sort: "${UserGardenRecordField.user}.${UserField.username}"
  );

  for (var record in resultList.items) {
    final userRecord = record.toJson()[QueryKey.expand][UserGardenRecordField.user];
    final user = AppUser.fromJson(userRecord);

    users.add(user);
  }

  return users;
}

/// Queries on the [UserSettings] collection to retrieve the record which
/// corresponds to the [currentUser].
///
/// Returns an [AppUserSettings] instance.
Future<AppUserSettings> getCurrentUserSettings() async {
  final currentUser = GetIt.instance<AppState>().currentUser!;

  var result = await GetIt.instance<UserSettingsRepository>().getFirstListItem(
    filter: "${UserSettingsField.user} = '${currentUser.id}'"
  );

  return AppUserSettings.fromJson(result.toJson(), currentUser);
}

/// Returns an instance of [AppUser] corresponding to the [User] record
/// from the database with the given [userID].
Future<AppUser> getUserByID(String userID) async {
  final query = await GetIt.instance<UsersRepository>().getFirstListItem(
    filter: "${GenericField.id} = '$userID'",
  );

  return AppUser.fromJson(query.toJson());
}

/// Queries on the [UserGardenRecord] collection, to retrieve a UserGardenRecord
/// corresponding to [userID] and [gardenID].
Future<AppUserGardenRecord?> getUserGardenRecord({
  required String userID,
  required String gardenID,
  sort = "-updated"
}) async {
  final resultList = await GetIt.instance<UserGardenRecordsRepository>().getList(
    filter: ""
      "${UserGardenRecordField.user} = '$userID' && "
      "${UserGardenRecordField.garden} = '$gardenID'",
    sort: sort,
  );

  // Return null if no UserGardenRecord record is found
  if (resultList.items.isEmpty) return null;

  final record = resultList.items.first.toJson();

  final garden = await getGardenByID(gardenID);
  final user = await getUserByID(userID);

  return AppUserGardenRecord(
    id: record[GenericField.id],
    garden: garden,
    user: user,
  );
}

/// Attempts to log in to the database with [usernameOrEmail]
/// and [password] parameters, and creates all necessary [GetIt] instances.
///
/// Returns true if log in is successful, else false.
Future<bool> login(
  String usernameOrEmail,
  String password, {
  PocketBase? database
}) async {
  try {
    final pb = database ?? PocketBase(Environments.pocketbaseUrl); // Must use pb because GetIt not yet initialised

    await pb.collection(Collection.users).authWithPassword(
      usernameOrEmail, password);

    await clearGetItInstance();
    await registerGetItInstances(pb);

    return true;
  } on ClientException catch (e) {
    // Log error
    developer.log(
      "auth_api.login() error",
      error: e,
    );
    return false;
  }
}

/// Logs out of the database and clears all [GetIt] instances.
Future<void> logout(
  context, {
  GoRouter? goRouter // primarily for testing
}) async {
  final usersRepository = GetIt.instance<UsersRepository>();

  // Clear all database subscriptions
  await usersRepository.unsubscribe();
  await GetIt.instance<AsksRepository>().unsubscribe();
  await GetIt.instance<GardensRepository>().unsubscribe();
  await GetIt.instance<UserSettingsRepository>().unsubscribe();

  // Clear logged in credentials and GetIt instance
  usersRepository.clearAuthStore();
  clearGetItInstance();

  if (context.mounted) {
    var router = goRouter ?? GoRouter.of(context);
    router.go(Routes.signIn);
  }
}

/// Attempts to send an email to [email] containing instructions
/// to reset the password corresponding to that account.
///
/// Returns true if the email is successfully sent, else false.
Future<bool> sendPasswordResetCode(
  String email, {
  PocketBase? database,
}) async {
  try {
    final pb = database ?? PocketBase(Environments.pocketbaseUrl); // Must use pb because GetIt not yet initialised

    // Send password reset email
    await pb.collection(Collection.users).requestPasswordReset(email);

    // Return
    return true;
  } on ClientException catch (e) {
    // Log error
    developer.log(
      "auth_api.sendPasswordResetCode() error",
      error: e,
    );

    return false;
  }
}

/// Attempts to create a new [User] record in the database with the
/// [map] parameter.
///
/// Returns (true, {}) if sign up is successful, else (false, errorsMap)
Future<(bool, Map)> signup(
  Map<String, dynamic> map, {
  PocketBase? database,
}) async {
  try {
    final pb = database ?? PocketBase(Environments.pocketbaseUrl); // Must use pb because GetIt not yet initialised

    // Create User
    map[UserField.emailVisibility] = false;
    final userRecord = await pb.collection(Collection.users).create(body: map);

    // Create UserSettings
    await pb.collection(Collection.userSettings).create(
      body: {
        UserSettingsField.defaultCurrency: "",
        UserSettingsField.defaultInstructions: "",
        UserSettingsField.user: userRecord.id
    });

    // Send verification email
    await pb.collection(Collection.users).requestVerification(map[UserField.email]);

    // Return
    return (true, {});
  } on ClientException catch (e) {
    var errorsMap = getErrorsMapFromClientException(e);

    // Log error
    developer.log(
      "auth_api.signup() error",
      error: e,
    );

    return (false, errorsMap);
  }
}

/// Subscribes to any changes made in the [User] collection for any [User] record
/// associated with the given [gardenID].
///
/// Calls the [callback] function whenever a change is made.
Future<Function> subscribeToUsers(String gardenID, Function callback) async {
  final usersRepository = GetIt.instance<UsersRepository>();

  // Always clear before setting new subscription
  await usersRepository.unsubscribe();

  return usersRepository.subscribe(gardenID, callback);
}

/// Subscribes to any changes made in the [UserSettings] collection to the
/// [UserSettings] record stored in [AppState].currentUserSettings.
///
/// Updates the [AppState]'s currentUserSettings whenever a change is made.
Future<Function> subscribeToUserSettings() async {
  final userSettingsRepository = GetIt.instance<UserSettingsRepository>();
  // Always clear before setting new subscription
  await userSettingsRepository.unsubscribe();

  Future<Function> unsubscribeFunc = userSettingsRepository.subscribe();
  return unsubscribeFunc;
}

/// Attempts to update the [User] record that matches the values passed
/// in the given [map] parameter.
///
/// Returns the updated [RecordModel] and an empty map if updated successfully,
/// else null and a map of the errors.
Future<(RecordModel?, Map)> updateUser(Map map) async {
  final (record, errorsMap) = await GetIt.instance<UsersRepository>().update(
    id: map[GenericField.id],
    body: {
      UserField.firstName: map[UserField.firstName],
      UserField.lastName: map[UserField.lastName],
  });

  return (record, errorsMap);
}

/// Attempts to update the [UserSettings] record that matches the values passed
/// in the given [map] parameter.
///
/// Returns the updated [RecordModel] and an empty map if updated successfully,
/// else null and a map of the errors.
Future<(RecordModel?, Map)> updateUserSettings(Map map) async {
  final (record, errorsMap) = await GetIt.instance<UserSettingsRepository>().update(
    id: map[GenericField.id],
    body: {
      UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
      UserSettingsField.defaultInstructions: map[UserSettingsField.defaultInstructions],
  });

  return (record, errorsMap);
}
