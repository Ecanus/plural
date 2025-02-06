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

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/service_locator.dart';

class AuthRepository {
  AuthRepository({
    required this.pb,
  });

  final PocketBase pb;

  /// Queries on the [UserGardenRecord] collection, sorted by the [sort] value,
  /// to retrieve a UserGardenRecord corresponding to the given [userID].
  ///
  /// Returns an [AppUserGardenRecord] instance corresponding to the retrieved
  /// UserGardenRecord if one is found. Else, returns null.
  Future<AppUserGardenRecord?> getUserGardenRecordByUserID({
    required String userID,
    sort = "-updated"
  }) async {
    var result = await pb.collection(Collection.userGardenRecords).getList(
      sort: sort,
      filter: "user = '$userID'"
    );

    // Return null if no UserGardenRecord is found
    var items = result.toJson()[PBKey.items];
    if (items.isEmpty) return null;

    var record = items[0];
    String gardenID = record[UserGardenRecordField.gardenID];

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
      textSize: record[UserSettingsField.textSize]
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
        UserSettingsField.textSize: map[UserSettingsField.textSize],
      }
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[GenericField.id],
      user: currentUser,
      textSize: record[UserSettingsField.textSize]
    );
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
  } on ClientException {
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
    var innerMap = e.response[ExceptionStrings.data];
    var errorsMap = {};

    // Create map of fields and corresponding error messages
    for (var key in e.response[ExceptionStrings.data].keys) {
      var fieldName = key;
      var errorMessage = innerMap[key][ExceptionStrings.message];

      // Remove trailing period
      errorMessage.replaceAll(
        RegExp(r'.'),
        "");

      errorsMap[fieldName] = errorMessage;
    }

    // Return
    print("Error Caught: $e");
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
    // await pb.collection(Collection.users).requestPasswordReset(email);

    // Return
    return true;
  } on ClientException catch(e) {
    print("Error Caught: $e");
    return false;
  }
}