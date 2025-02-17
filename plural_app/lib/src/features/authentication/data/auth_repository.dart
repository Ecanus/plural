import 'dart:developer' as developer;
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Common Methods
import 'package:plural_app/src/common_methods/errors.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/routes.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
import "package:plural_app/src/features/authentication/domain/app_user_settings.dart";
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import "package:plural_app/src/features/gardens/domain/garden.dart";

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/service_locator.dart';

class AuthRepository {
  AuthRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [UserGardenRecord] collection, sorted by the [sort] value,
  /// to retrieve a UserGardenRecord corresponding to the given [userID] and [gardenID].
  ///
  /// Returns an [AppUserGardenRecord] instance corresponding to the retrieved
  /// UserGardenRecord if one is found. Else, returns null.
  Future<AppUserGardenRecord?> getGardenRecord({
    required String userID,
    required String gardenID,
    sort = "-updated"
  }) async {
    var result = await pb.collection(Collection.userGardenRecords).getList(
      sort: sort,
      filter: "user = '$userID' && garden = '$gardenID'"
    );

    // Return null if no UserGardenRecord is found
    var items = result.toJson()[PBKey.items];
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

  /// Queries on the [UserGardenRecord] collection to retrieve the most recently
  /// updated UserGardenRecord corresponding to the given [userID].
  ///
  /// Returns an [AppUserGardenRecord] instance corresponding to the retrieved
  /// UserGardenRecord if one is found. Else, returns null.
  Future<AppUserGardenRecord?> getMostRecentGardenRecordByUserID({
    required String userID,
  }) async {
    var result = await pb.collection(Collection.userGardenRecords).getList(
      sort: "-updated",
      filter: "user = '$userID'"
    );

    // Return null if no UserGardenRecord is found
    var items = result.toJson()[PBKey.items];
    if (items.isEmpty) return null;

    var record = items[0];

    var gardenID = record[UserGardenRecordField.gardenID];
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
  /// Returns the list of retrieved [User]s.
  Future<List<AppUser>> getCurrentGardenUsers() async {
    String currentGardenID = GetIt.instance<AppState>().currentGarden!.id;
    List<AppUser> instances = [];

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.user,
      filter: "${UserGardenRecordField.garden} = '$currentGardenID'",
      sort: "user.username"
    );

    // TODO: Raise error if result is empty
    var records = result.toJson()[PBKey.items];

    for (var record in records) {
      var userRecord = record[PBKey.expand][UserGardenRecordField.user];

      var userInstance = AppUser(
        id: record[UserGardenRecordField.userID],
        email: userRecord[UserField.email],
        username: userRecord[UserField.username],
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
      "${GenericField.id} = '$id'",
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();

    return AppUser(
      id: record[GenericField.id],
      email: record[UserField.email],
      username: record[UserField.username],
    );
  }

  /// Queries on the [UserGardenRecord] collection to update the date of the
  /// the record which corresponds to the given [userID] and [gardenID] parameters.
  Future<void> updateUserGardenRecord(String userID, String gardenID) async {
    var result = await pb.collection(Collection.userGardenRecords).getFirstListItem(
      """
      ${UserGardenRecordField.userID} = '$userID' &&
      ${UserGardenRecordField.gardenID} = '$gardenID'
      """
    );

    var userGardenRecord = result.toJson();

    // Update
    await pb.collection(Collection.userGardenRecords).update(
      userGardenRecord[GenericField.id],
      body: {
        GenericField.updated: DateFormat(Strings.dateformatYMMdd).format(DateTime.now()),
      }
    );
  }

  /// Creates a new [UserGardenRecord] record using the given
  /// [userID] and [gardenID] parameters.
  Future<void> createUserGardenRecord(String userID, String gardenID) async {
    await pb.collection(Collection.userGardenRecords).create(
      body: {
        UserGardenRecordField.user: userID,
        UserGardenRecordField.gardenID: gardenID
      }
    );
  }

  /// Queries on the [UserSettings] collection to retrieve the record which
  /// corresponds to the [currentUser].
  ///
  /// Returns an [AppUserSettings] instance.
  Future<AppUserSettings> getCurrentUserSettings() async {
    final currentUser = GetIt.instance<AppState>().currentUser!;

    var result = await pb.collection(Collection.userSettings).getFirstListItem(
      "${UserSettingsField.userID} = '${currentUser.id}'"
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
  /// which corresponds to the [map] parameter.
  ///
  /// Returns an [AppUserSettings] instance.
  Future<AppUserSettings> updateUserSettings(Map map) async {
    final currentUser = GetIt.instance<AppState>().currentUser!;

    var result = await pb.collection(Collection.userSettings).update(
      map[GenericField.id],
      body: {
        UserSettingsField.userID: currentUser.id,
        UserSettingsField.defaultCurrency: map[UserSettingsField.defaultCurrency],
        UserSettingsField.defaultInstructions: map[UserSettingsField.defaultInstructions],
      }
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[GenericField.id],
      user: currentUser,
      defaultCurrency: record[UserSettingsField.defaultCurrency],
      defaultInstructions: record[UserSettingsField.defaultInstructions],
    );
  }

  /// Subscribes to any changes made in the [User] collection to any [User] record
  /// associated with the [Garden] with the given [gardenID].
  ///
  /// Calls the given [callback] method whenever a change is made.
  Future<Function> subscribeTo(String gardenID, Function callback) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.users)
      .subscribe(Subscribe.all, (e) async {
        var user = e.record!.toJson();

        // Only respond to changes to users in the given gardenID
        var gardenRecord = await getGardenRecord(
          userID: user[GenericField.id],
          gardenID: gardenID,
        );

        if (gardenRecord == null) return;

        switch (e.action) {
          case EventAction.create:
            callback();
          case EventAction.delete:
            callback();
          case EventAction.update:
            callback();
        }
      });

    return unsubscribeFunc;
  }
}

/// Attempts to log into the database with the given [usernameOrEmail]
/// and [password] parameters. And creates all necessary [GetIt] instances.
///
/// Returns true if log in is successful, else false.
Future<bool> login(String usernameOrEmail, String password) async {
  // TODO: Change url dynamically by env
  var pb = PocketBase("http://127.0.0.1:8090");

  try {
    await pb.collection(Collection.users).authWithPassword(
    usernameOrEmail, password);

    await clearGetItInstances();
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
Future<void> logout(context) async {
  clearGetItInstances(logout: true);

  if (context.mounted) GoRouter.of(context).go(Routes.signIn);
}

/// Attempts to create a new [User] record in the database with the given
/// [firstName], [lastName], [username], [email], and [password] parameters.
///
/// Returns a record of (true, {}) if sign up is successful, else (false, errorsMap)
Future<(bool, Map)> signup(
  String firstName,
  String lastName,
  String username,
  String email,
  String password,
  String passwordConfirm,
) async {
  // TODO: Change url dynamically by env
  var pb = PocketBase("http://127.0.0.1:8090");

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
    // await pb.collection(Collection.users).requestVerification(email);

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
Future<bool> sendPasswordResetCode(String email) async {
  // TODO: Change url dynamically by env
  var pb = PocketBase("http://127.0.0.1:8090");

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