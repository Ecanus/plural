import 'dart:developer' as developer;

import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Common Functions
import 'package:plural_app/src/common_functions/errors.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import "package:plural_app/src/features/authentication/domain/app_user_settings.dart";

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import "package:plural_app/src/features/gardens/domain/garden.dart";

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/service_locator.dart';

/// Attempts to log into the database with the given [usernameOrEmail]
/// and [password] parameters and create all necessary [GetIt] instances.
///
/// Returns true if log in is successful, else false.
Future<bool> login(
  String usernameOrEmail,
  String password,
  PocketBase pb
) async {
  try {
    await pb.collection(Collection.users).authWithPassword(
    usernameOrEmail, password);

    await clearGetItInstance();
    await registerGetItInstances(pb);

    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "AuthRepository login() error",
      error: e,
    );
    return false;
  }
}

/// Logs out of the database and clears all [GetIt] instances.
Future<void> logout(
  context, {
  // primarily for testing
  GoRouter? goRouter
  }) async {
  final pb = GetIt.instance<PocketBase>();

  // Clear all database subscriptions
  await pb.collection(Collection.asks).unsubscribe();
  await pb.collection(Collection.gardens).unsubscribe();
  await pb.collection(Collection.users).unsubscribe();
  await pb.collection(Collection.userSettings).unsubscribe();

  // Clear logged in credentials and GetIt instance
  pb.authStore.clear();
  clearGetItInstance();

  if (context.mounted) {
    var router = goRouter ?? GoRouter.of(context);
    router.go(Routes.signIn);
  }
}

/// Attempts to create a new [User] record in the database with the given
/// [firstName], [lastName], [username], [email], and [password] parameters.
///
/// Returns (true, {}) if sign up is successful, else (false, errorsMap)
Future<(bool, Map)> signup(
  String firstName,
  String lastName,
  String username,
  String email,
  String password,
  String passwordConfirm, {
  // primarily for testing
  PocketBase? database
}) async {
  // TODO: Change url dynamically by env
  var pb = database ?? PocketBase("http://127.0.0.1:8090");

  try {
    // Create User
    await pb.collection(Collection.users).create(
      body: {
        UserField.email: email,
        UserField.firstName: firstName,
        UserField.lastName: lastName,
        UserField.password: password,
        UserField.passwordConfirm: passwordConfirm,
        UserField.username: username
      }
    );

    // Send verification email
    await pb.collection(Collection.users).requestVerification(email);

    // Return
    return (true, {});
  } on ClientException catch(e) {
    var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
      "AuthRepository signup() error",
      error: e,
    );

      return (false, errorsMap);
  }
}

/// Attempts to send an email to the given [email] containing instructions
/// to reset the account password corresponding to [email].
///
/// Returns true if the email is successfully sent, else false.
Future<bool> sendPasswordResetCode(
  String email, {
  // primarily for testing
  PocketBase? database,
}) async {
  // TODO: Change url dynamically by env
  var pb = database ?? PocketBase("http://127.0.0.1:8090");

  try {
    // Send password reset email
    await pb.collection(Collection.users).requestPasswordReset(email);

    // Return
    return true;
  } on ClientException catch(e) {
    // Log error
    developer.log(
      "AuthRepository sendPasswordResetCode() error",
      error: e,
    );

    return false;
  }
}

class AuthRepository {
  AuthRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [UserGardenRecord] collection, to retrieve a UserGardenRecord
  /// corresponding to the given [userID] and [gardenID].
  ///
  /// Sorted on the [sort] value.
  ///
  /// Returns an [AppUserGardenRecord] instance corresponding to the retrieved
  /// UserGardenRecord if one is found. Else, returns null.
  Future<AppUserGardenRecord?> getUserGardenRecord({
    required String userID,
    required String gardenID,
    sort = "-updated"
  }) async {
    var result = await pb.collection(Collection.userGardenRecords).getList(
      filter: "user = '$userID' && garden = '$gardenID'",
      sort: sort,
    );

    // Return null if no UserGardenRecord is found
    var items = result.toJson()[QueryKey.items];
    if (items.isEmpty) return null;
    var record = items[0];

    var garden = await GetIt.instance<GardensRepository>().getGardenByID(gardenID);
    var user = await getUserByID(userID);

    return AppUserGardenRecord(
      id: record[GenericField.id],
      user: user,
      garden: garden
    );
  }

  /// Queries on the [UserGardenRecord] collection to retrieve all [User]s
  /// with the same [Garden] as the currentGarden.
  ///
  /// Returns the list of retrieved [AppUser]s.
  Future<List<AppUser>> getCurrentGardenUsers() async {
    String currentGardenID = GetIt.instance<AppState>().currentGarden!.id;
    List<AppUser> instances = [];

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.user,
      filter: "${UserGardenRecordField.garden} = '$currentGardenID'",
      sort: "user.username"
    );

    // TODO: Return empty list if result is empty
    var records = result.toJson()[QueryKey.items];

    for (var record in records) {
      var userRecord = record[QueryKey.expand][UserGardenRecordField.user];

      var appUser = AppUser(
        id: record[UserGardenRecordField.user],
        email: userRecord[UserField.email],
        username: userRecord[UserField.username],
      );

      instances.add(appUser);
    }

    return instances;
  }

  /// Queries on the [User] collection to retrieve the [User] with
  /// an ID matching the given [userID] parameter.
  ///
  /// Returns an [AppUser] instance.
  Future<AppUser> getUserByID(String userID) async {
    var result = await pb.collection(Collection.users).getFirstListItem(
      "${GenericField.id} = '$userID'",
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();

    return AppUser(
      id: record[GenericField.id],
      email: record[UserField.email],
      username: record[UserField.username],
    );
  }

  /// Queries on the [UserSettings] collection to retrieve the record which
  /// corresponds to the [currentUser].
  ///
  /// Returns an [AppUserSettings] instance.
  Future<AppUserSettings> getCurrentUserSettings() async {
    final currentUser = GetIt.instance<AppState>().currentUser!;

    var result = await pb.collection(Collection.userSettings).getFirstListItem(
      "${UserSettingsField.user} = '${currentUser.id}'"
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[GenericField.id],
      user: currentUser,
      defaultCurrency: record[UserSettingsField.defaultCurrency],
      defaultInstructions: record[UserSettingsField.defaultInstructions],
    );
  }

  /// Queries on the [UserSettings] collection to update the record
  /// with values in the given [map] parameter.
  ///
  /// Returns true and an empty map if created successfully, else false
  /// and a map of the errors.
  Future<(bool, Map)> updateUserSettings(Map map) async {
    try {
      // Update User Settings
      await pb.collection(Collection.userSettings).update(
        map[GenericField.id],
        body: {
          UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
          UserSettingsField.defaultInstructions: map[UserSettingsField.defaultInstructions],
        }
      );

      // Return
      return (true, {});
    } on ClientException catch(e) {
      var errorsMap = getErrorsMapFromClientException(e);

      // Log error
      developer.log(
        "AuthRespository updateUserSettings() error",
        error: e,
      );

      return (false, errorsMap);
    }
  }

  /// Subscribes to any changes made in the [User] collection for any [User] record
  /// associated with the given [gardenID].
  ///
  /// Calls the [callback] function whenever a change is made.
  Future<Function> subscribeToUsers(String gardenID, Function callback) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.users)
      .subscribe(Subscribe.all, (e) async {
        var user = e.record!.toJson();

        // Only respond to changes to users in the given gardenID
        var gardenRecord = await getUserGardenRecord(
          userID: user[GenericField.id],
          gardenID: gardenID,
        );

        if (gardenRecord == null) return;

        switch (e.action) {
          case EventAction.create:
          case EventAction.delete:
          case EventAction.update:
            callback();
        }
      });

    return unsubscribeFunc;
  }

  /// Subscribes to any changes made in the [UserSettings] collection to the
  /// [UserSettings] record stored in [AppState].currentUserSettings.
  ///
  /// Updates the [AppState]'s currentUserSettings whenever a change is made.
  Future<Function> subscribeToUserSettings() {
    final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;

    Future<Function> unsubscribeFunc = pb.collection(Collection.userSettings)
      .subscribe(currentUserSettings.id, (e) async {
        switch (e.action) {
          case EventAction.update:
            GetIt.instance<AppState>().currentUserSettings =
              await getCurrentUserSettings();
        }
      });

    return unsubscribeFunc;
  }
}