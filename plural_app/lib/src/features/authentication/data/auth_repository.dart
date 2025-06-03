import 'dart:developer' as developer;

import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/fields.dart';
import 'package:plural_app/src/constants/pocketbase.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_garden_record.dart';
import 'package:plural_app/src/features/authentication/domain/app_user_settings.dart';

// Gardens
import 'package:plural_app/src/features/gardens/data/gardens_repository.dart';
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';
import 'package:plural_app/src/utils/exceptions.dart';

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

  /// Deletes the [UserGardenRecord] record corresponding to [AppState].currentUser.id
  Future<void> deleteCurrentUserGardenRecords() async {
    final currentUser = GetIt.instance<AppState>().currentUser!;

    var result = await pb.collection(Collection.userGardenRecords).getList(
      filter: "${UserGardenRecordField.user} = '${currentUser.id}'",
    );

    for (var record in result.items) {
      await pb.collection(Collection.userGardenRecords).delete(record.id);
    }
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

    var records = result.toJson()[QueryKey.items];

    for (var record in records) {
      var userRecord = record[QueryKey.expand][UserGardenRecordField.user];

      var appUser = AppUser(
        id: record[UserGardenRecordField.user],
        email: userRecord[UserField.email],
        firstName: userRecord[UserField.firstName],
        lastName: userRecord[UserField.lastName],
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
      firstName: record[UserField.firstName],
      lastName: record[UserField.lastName],
      username: record[UserField.username],
    );
  }

  /// Deletes the [User] record corresponding to [AppState].currentUser
  Future<void> deleteCurrentUser() async {
    final currentUser = GetIt.instance<AppState>().currentUser!;
    await pb.collection(Collection.users).delete(currentUser.id);
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

  /// Deletes the [UserSettings] record corresponding to [AppState].currentUser.id
  Future<void> deleteCurrentUserSettings() async {
    final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;

    await pb.collection(Collection.userSettings).delete(currentUserSettings.id);
  }

  /// Subscribes to any changes made in the [User] collection for any [User] record
  /// associated with the given [gardenID].
  ///
  /// Calls the [callback] function whenever a change is made.
  Future<Function> subscribeToUsers(String gardenID, Function callback) async {
    // Always clear before setting new subscription
    await pb.collection(Collection.users).unsubscribe();

    var currentUser = GetIt.instance<AppState>().currentUser!;

    Future<Function> unsubscribeFunc = pb.collection(Collection.users)
      .subscribe(Subscribe.all, (e) async {
        var user = e.record!.toJson();
        var userID = user[GenericField.id];

        // Only respond to changes to users in the given gardenID
        var gardenRecord = await getUserGardenRecord(
          userID: userID,
          gardenID: gardenID,
        );

        if (gardenRecord == null) return;

        switch (e.action) {
          case EventAction.update:
            // Get new values from db, if it was currentUser that was updated
            if (userID == currentUser.id) {
              GetIt.instance<AppState>().currentUser = await getUserByID(userID);
            }
          case EventAction.create:
          case EventAction.delete:
            callback();
        }
      });

    return unsubscribeFunc;
  }

  /// Subscribes to any changes made in the [UserSettings] collection to the
  /// [UserSettings] record stored in [AppState].currentUserSettings.
  ///
  /// Updates the [AppState]'s currentUserSettings whenever a change is made.
  Future<Function> subscribeToUserSettings() async {
    // Always clear before setting new subscription
    await pb.collection(Collection.userSettings).unsubscribe();

    Future<Function> unsubscribeFunc = pb.collection(Collection.userSettings)
      .subscribe(Subscribe.all, (e) async { // can't subscribe directly on userSettings.id because of pocketbase bug. Use Subscribe.all instead
        final currentUserSettings = GetIt.instance<AppState>().currentUserSettings!;
        final idMatch = currentUserSettings.user.id == pb.authStore.record?.id;

        if (!idMatch) return;

        switch (e.action) {
          case EventAction.update:
            GetIt.instance<AppState>().currentUserSettings =
              await getCurrentUserSettings();
        }
      });

    return unsubscribeFunc;
  }
}