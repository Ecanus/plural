import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

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

class AuthRepository {
  AuthRepository({
    required this.pb,
  }) {
    var user = pb.authStore.model;
    user = user.toJson();

    currentUser = AppUser(
      id: user[Field.id],
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
      id: record[Field.id],
      user: currentUser!,
      garden: garden
    );
  }

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
      var recordUser = record[PBKey.expand][UserGardenRecordField.user];

      var newUser = AppUser(
        id: record[UserGardenRecordField.userID],
        email: recordUser[UserField.email],
        firstName: recordUser[UserField.firstName],
        lastName: recordUser[UserField.lastName]
      );

      instances.add(newUser);
    }

    return instances;
  }

  Future<AppUser> getUserByID(String id) async {
    var result = await pb.collection(Collection.users).getFirstListItem(
      "${Field.id} = '$id'"
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();

    return AppUser(
      id: record[Field.id],
      email: record[UserField.email],
      firstName: record[UserField.firstName],
      lastName: record[UserField.lastName]
    );
  }

  Future<void> updateUserGardenRecord(AppUser user, Garden garden) async {
    var result = await pb.collection(Collection.userGardenRecords).getFirstListItem(
      """
      ${UserGardenRecordField.userID} = '${user.id}' &&
      ${UserGardenRecordField.gardenID} = '${garden.id}'
      """
    );

    var userGardenRecord = result.toJson();

    await pb.collection(Collection.userGardenRecords).update(
      userGardenRecord[Field.id],
      body: {
        Field.updated: DateFormat(Strings.dateformatYMMdd).format(DateTime.now()),
      }
    );
  }

  Future<AppUserSettings> getCurrentUserSettings() async {
    var result = await pb.collection(Collection.userSettings).getFirstListItem(
      "${UserSettingsField.userID} = '${currentUser!.id}'"
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[Field.id],
      user: currentUser!,
      textSize: record[UserSettingsField.textSize]
    );
  }

  Future<AppUserSettings> updateUserSettings(Map map) async {
    var result = await pb.collection(Collection.userSettings).update(
      map[Field.id],
      body: {
        UserSettingsField.userID: getCurrentUserID(),
        UserSettingsField.textSize: map[UserSettingsField.textSize],
      }
    );

    var record = result.toJson();

    return AppUserSettings(
      id: record[Field.id],
      user: currentUser!,
      textSize: record[UserSettingsField.textSize]
    );
  }
}