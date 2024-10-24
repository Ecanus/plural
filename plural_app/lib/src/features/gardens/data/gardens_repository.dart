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

class GardensRepository {
  GardensRepository({
    required this.pb,
  });

  final PocketBase pb;

  Future<Garden> getGardenByID(String id) async {
    final authRepository = GetIt.instance<AuthRepository>();

    var result = await pb.collection(Collection.gardens).getFirstListItem(
      "${Field.id} = '$id'"
    );

    // TODO: Raise error if result is empty
    var record = result.toJson();
    var creator = await authRepository.getUserByID(record[GardenField.creator]);

    return Garden(
      id: record[Field.id],
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

  /// Uses the given [map] parameter to create a corresponding Garden
  /// record in the database.
  Future<void> create(Map map) async {
    var currentUserID = GetIt.instance<AuthRepository>().getCurrentUserID();

    // Create Garden
    var createdGarden = await pb.collection(Collection.gardens).create(
      body: {
        GardenField.creator: currentUserID,
        GardenField.name: map[GardenField.name],
      }
    );

    // Create User Garden Record
    await pb.collection(Collection.userGardenRecords).create(
      body: {
        UserGardenRecordField.user: currentUserID,
        UserGardenRecordField.gardenID: createdGarden.toJson()[Field.id]
      }
    );
  }

  Future<Garden> update(Map map) async {
    var result = await pb.collection(Collection.gardens).update(
      map[Field.id],
      body: {
        GardenField.name: map[GardenField.name],
      }
    );

    var record = result.toJson();
    var creator = await GetIt.instance<AuthRepository>().getUserByID(
      record[GardenField.creator]);

    return Garden(
      id: record[Field.id],
      creator: creator,
      name: record[GardenField.name]
    );
  }
}