import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Pocketbase
import 'package:pocketbase/pocketbase.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import "package:plural_app/src/features/authentication/domain/app_user.dart";
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
      uid: user[Field.id],
      email: user[UserField.email],
      firstName: user[UserField.firstName],
      lastName: user[UserField.lastName],
    );
  }

  final PocketBase pb;

  AppUser? currentUser;

  String getCurrentUserUID() {
    return currentUser!.uid;
  }

  Future<void> setCurrentUserLatestGardenRecord() async {
    var user = pb.authStore.model;
    user = user.toJson();

    var result = await pb.collection(Collection.userGardenRecords).getList(
      sort: "-updated",
      filter: "user = '${currentUser!.uid}'"
    );

    var record = result.toJson()[PBKey.items][0];
    String gardenUID = record[UserGardenRecordField.gardenUID];

    final gardensRepository = GetIt.instance<GardensRepository>();
    var garden = await gardensRepository.getGardenByUID(gardenUID);

    currentUser!.latestGardenRecord = AppUserGardenRecord(
      uid: record[Field.id],
      user: currentUser!,
      garden: garden
    );
  }

  Future<List<AppUser>> get({
    String sort = "${UserField.lastName}, ${UserField.firstName}",
  }) async {
    List<AppUser> instances = [];

    var result = await pb.collection(Collection.users).getList(
      sort: sort
    );
    var records = result.toJson()[PBKey.items];

    for (var record in records) {
      var newUser = AppUser(
        uid: record[PBKey.items],
        email: record[UserField.email],
        firstName: record[UserField.firstName],
        lastName: record[UserField.lastName]
      );

      instances.add(newUser);
    }

    return instances;
  }

  Future<List<AppUser>> getCurrentGardenUsers() async {
    String currentGardenUID = GetIt.instance<GardenManager>().currentGarden!.uid;
    List<AppUser> instances = [];

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.user,
      filter: "${UserGardenRecordField.garden} = '$currentGardenUID'",
      sort: "user.lastName, user.firstName"
    );

    // TODO: Raise error if result is empty
    var records = result.toJson()[PBKey.items];

    for (var record in records) {
      var recordUser = record[PBKey.expand][UserGardenRecordField.user];

      var newUser = AppUser(
        uid: record[UserGardenRecordField.userUID],
        email: recordUser[UserField.email],
        firstName: recordUser[UserField.firstName],
        lastName: recordUser[UserField.lastName]
      );

      instances.add(newUser);
    }

    return instances;
  }

  Future<AppUser> getUserByUID(String uid) async {
    var result = await pb.collection(Collection.users).getFirstListItem(
      "id = '$uid'"
    );

    // TODO: Raise error if result is empty

    var record = result.toJson();

    return AppUser(
      uid: record[Field.id],
      email: record[UserField.email],
      firstName: record[UserField.firstName],
      lastName: record[UserField.lastName]
    );
  }

  Future<void> updateUserGardenRecord(AppUser user, Garden garden) async {
    var result = await pb.collection(Collection.userGardenRecords).getFirstListItem(
      """
      ${UserGardenRecordField.userUID} = '${user.uid}' &&
      ${UserGardenRecordField.gardenUID} = '${garden.uid}'
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
}