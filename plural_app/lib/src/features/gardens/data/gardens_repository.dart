import 'package:pocketbase/pocketbase.dart';
import 'package:get_it/get_it.dart';

// Constants
import 'package:plural_app/src/constants/pocketbase.dart';
import 'package:plural_app/src/constants/strings.dart';

// Auth
import 'package:plural_app/src/features/authentication/domain/app_user.dart';
import 'package:plural_app/src/features/authentication/data/auth_repository.dart';

// Gardens
import 'package:plural_app/src/features/gardens/domain/garden.dart';

// Utils
import 'package:plural_app/src/utils/app_state.dart';

class GardensRepository {
  GardensRepository({
    required this.pb,
  });

  final PocketBase pb;

  Future<Garden> getGardenByID(String id) async {
    final authRepository = GetIt.instance<AuthRepository>();

    var result = await pb.collection(Collection.gardens).getFirstListItem(
      "${GenericField.id} = '$id'"
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();
    var creator = await authRepository.getUserByID(record[GardenField.creator]);

    return Garden(
      id: record[GenericField.id],
      creator: creator,
      name: record[GardenField.name]
    );
  }

  Future<List<Garden>> getGardensByUser({required AppUser user}) async {
    final authRepository = GetIt.instance<AuthRepository>();
    List<Garden> instances = [];

    var result = await pb.collection(Collection.userGardenRecords).getList(
      expand: UserGardenRecordField.garden,
      filter: "${UserGardenRecordField.user} = '${user.id}'",
      sort: "garden.name",
    );

    // TODO: Raise error if result is empty
    var records = result.toJson()[PBKey.items];

    for (var record in records) {
      var recordGarden = record[PBKey.expand][UserGardenRecordField.garden];
      var creator = await authRepository.getUserByID(recordGarden[GardenField.creator]);

      var garden = Garden(
        id: record[UserGardenRecordField.gardenID],
        creator: creator,
        name: recordGarden[GardenField.name],
      );

      instances.add(garden);
    }

    return instances;
  }

  /// Uses the given [map] value to create a corresponding [Garden]
  /// record in the database.
  ///
  /// Creates a corresponding [UserGardenRecord] record that points to both
  /// the current user and the newly created [Garden].
  Future<void> create(Map map) async {
    final authRepository = GetIt.instance<AuthRepository>();
    final currentUser = GetIt.instance<AppState>().currentUser;

    // Create Garden
    var createdGarden = await pb.collection(Collection.gardens).create(
      body: {
        GardenField.creator: currentUser!.id,
        GardenField.name: map[GardenField.name],
      }
    );

    // Create User Garden Record
    authRepository.createUserGardenRecord(
      currentUser.id,
      createdGarden.toJson()[GenericField.id]);
  }

  /// Uses the given [map] value to update a [Garden] record with the corresponding
  /// map.id value.
  ///
  /// Returns a [Garden] instance with the updated values.
  Future<Garden> update(Map map) async {
    var result = await pb.collection(Collection.gardens).update(
      map[GenericField.id],
      body: {
        GardenField.name: map[GardenField.name],
      }
    );

    var record = result.toJson();
    var creator = await GetIt.instance<AuthRepository>().getUserByID(
      record[GardenField.creator]);

    return Garden(
      id: record[GenericField.id],
      creator: creator,
      name: record[GardenField.name]
    );
  }

  /// Subscribes to any changes made in the [Garden] collection to the [Garden] record
  /// with the corresponding [gardenID].
  ///
  /// Updates the value of [AppState].currentGarden whenever a change is made.
  Future<Function> subscribeTo(String gardenID) {
    Future<Function> unsubscribeFunc = pb.collection(Collection.gardens)
      .subscribe(gardenID, (e) async {
        if (e.action == EventAction.update) {
          GetIt.instance<AppState>().currentGarden = await getGardenByID(gardenID);
        }
      });

    return unsubscribeFunc;
  }
}